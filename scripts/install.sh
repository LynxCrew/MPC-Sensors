#!/bin/bash

KLIPPER_PATH="${HOME}/klipper"
REPO_PATH="${HOME}/mpc-sensors"
EXTENSIONS="mpc_ambient_temperature mpc_block_temperature"

set -eu
export LC_ALL=C


function preflight_checks {
    if [ "$EUID" -eq 0 ]; then
        echo "[PRE-CHECK] This script must not be run as root!"
        exit -1
    fi

    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F 'klipper.service')" ]; then
        printf "[PRE-CHECK] Klipper service found! Continuing...\n\n"
    else
        echo "[ERROR] Klipper service not found, please install Klipper first!"
        exit -1
    fi
}

function check_download {
    local mpcsensorsdirname mpcsensorsbasename
    mpcsensorsdirname="$(dirname ${REPO_PATH})"
    mpcsensorsbasename="$(basename ${REPO_PATH})"

    if [ ! -d "${REPO_PATH}" ]; then
        echo "[DOWNLOAD] Downloading MPC-Sensors repository..."
        if git -C $mpcsensorsdirname clone https://github.com/LynxCrew/MPC-Sensors.git $mpcsensorsbasename; then
            chmod +x ${REPO_PATH}/scripts/install.sh
            chmod +x ${REPO_PATH}/scripts/update.sh
            chmod +x ${REPO_PATH}/scripts/uninstall.sh
            printf "[DOWNLOAD] Download complete!\n\n"
        else
            echo "[ERROR] Download of MPC-Sensors git repository failed!"
            exit -1
        fi
    else
        printf "[DOWNLOAD] MPC-Sensors repository already found locally. Continuing...\n\n"
    fi
}

function link_extension {
    echo "[INSTALL] Linking extension to Klipper..."

    for extension in ${EXTENSIONS}; do
        if [ ! -f "${KLIPPER_PATH}/klippy/extras/${extension}.py" ]; then
            ln -sf "${REPO_PATH}/source/${extension}.py" "${KLIPPER_PATH}/klippy/extras/${extension}.py"
        fi
    done
}

function restart_klipper {
    echo "[POST-INSTALL] Restarting Klipper..."
    sudo systemctl restart klipper
}


printf "\n======================================\n"
echo "- MPC-Sensors install script -"
printf "======================================\n\n"


# Run steps
preflight_checks
check_download
link_extension
restart_klipper
