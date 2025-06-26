#!/bin/zsh

readonly CURRENT_TIME=$(date "+%Y-%m-%d_%H-%M-%S")
readonly LOG_FILE="log_${CURRENT_TIME}.txt"

function show_error() {
    print -P "%F{red}$1%f" >&2 | tee -a $LOG_FILE
}

function show_msg() {
    print -P "%F{green}$1%f" | tee -a $LOG_FILE
}

function show_log() {
    echo "[+] $1" | tee -a $LOG_FILE
}

function check_internet_connection() {
    local -r target=$1
    ping -c 1 $target &> /dev/null
    if [ $? -eq 0 ]; then
        show_msg "Able to access $1"
    else
        show_error "Unable to access $1"
        exit 1
    fi
}

function check_os_version() {
    local -r product_version=$(sw_vers -productVersion)
    # Check whether running OS is between Ventura (13.x) and Tahoe (26.x)
    if [[ $product_version =~ '^([0-9]+)' ]]; then
        local -r major_version=${match[1]}
        if (( major_version < 13 )) || (( major_version > 26 )); then
            show_error "This version ($product_version) is not supported. Please run on macOS between Ventura (13.x) and Tahoe (26.x)."
            exit 1
        fi
    else
        show_error "Failed to get OS version information."
        exit 1
    fi
}

function check_vm() {
    local -r hardware_model=$(sysctl -n hw.model)
    if [[ $hardware_model == *"Mac"* ]] && [[ $hardware_model != "VirtualMac"* ]]; then
        show_error "Please run this script on a virtual machine because restoring the state is difficult"
        show_error "Continue if you know what you are doing"
        show_error "Do you want to proceed the following steps? [Y/N]"
        read ans
        if [[ $ans != "Y" ]]; then
            exit 1
        fi
    fi
}

function check_terminal_has_fda() {
    local -r tcc_folder="$HOME/Library/Application Support/com.apple.TCC/"
    if [ -d "$tcc_folder" ] && [ "$(ls "$tcc_folder")" ]; then
        show_msg "Full Disk Access permission is granted."
    else
        show_error "Full Disk Access permission is not granted."
        exit 1
    fi
}

function check_running_as_root() {
    if [ "$(id -u)" != "0" ]; then
        show_error "Please run this script as root"
        exit 1
    fi
}

function check_device_has_enough_disk_space() {
    local -r disk_space=$(df / | tail -n 1 | awk '{print $4}')
    local -r min_disk_space=31457280 # 30 GB in KB
    if [ $disk_space -lt $min_disk_space ]; then
        show_error "Not enough disk space available. At least 30GB of free space is required."
        exit 1
    fi
}

function disable_macos_updates() {
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool FALSE
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool FALSE
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool FALSE
    defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool FALSE
    defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool FALSE
}

show_log "Checking this script is running as root"
check_running_as_root

show_log "Checking the terminal has Full Disk Access"
check_terminal_has_fda

show_log "Checking for Internet connectivity"
check_internet_connection "google.com"
check_internet_connection "brew.sh"

show_log "Checking OS version"
check_os_version

show_log "Checking VM"
check_vm

show_log "Checking the device has enough disk space"
check_device_has_enough_disk_space

show_log "Disabling macOS updates"
disable_macos_updates

readonly LOGIN_USER_NAME=$(stat -f "%Su" /dev/console)
readonly ARCH=$(uname -m)
if [[ $ARCH == "arm64" ]]; then
    homebrew_root=/opt/homebrew
    show_log "Installing Rosetta 2"
    sudo -u $LOGIN_USER_NAME softwareupdate --install-rosetta --agree-to-license
else
    homebrew_root=/usr/local
fi

show_log "Installing homebrew"
NONINTERACTIVE=1 sudo -E -u $LOGIN_USER_NAME /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo -u $LOGIN_USER_NAME printf 'eval "$(%s/bin/brew shellenv)"\n' $homebrew_root | sudo -u $LOGIN_USER_NAME tee -a $HOME/.zprofile

show_log "Installing packages from Brewfile"
if [[ -e Brewfile ]]; then
    sudo -u $LOGIN_USER_NAME $homebrew_root/bin/brew bundle --file=Brewfile
else
    show_error "Brewfile not found. Please create a Brewfile and run this script again."
    exit 1
fi

show_log "Running custom package installation scripts"
for script in ./custom/*; do
    source "$script"
done

show_log "Running post-install actions"
source ./postinstall.sh
