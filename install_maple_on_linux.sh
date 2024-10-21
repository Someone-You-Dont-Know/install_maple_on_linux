#!/usr/bin/env bash

INSTALLER_FILE="Maple2022.2LinuxX64Installer.run"
CRACK_FILE="Maplesoft.Maple.2022.2.x64.Linux.Crack.zip"
CRACK_FILE_PASSWORD="www.p30download.com"

read -sp "Enter your password: " PASSWORD

install_dialog() {
    if ! command -v dialog &> /dev/null; then
        # Detect the Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                ubuntu|debian)
                    echo "$PASSWORD" | sudo apt-get update
                    echo "$PASSWORD" | sudo apt-get install -y dialog
                    ;;
                centos|rhel|fedora)
                    echo "$PASSWORD" | sudo dnf install -y dialog
                    ;;
                arch)
                    echo "$PASSWORD" | sudo pacman -S --noconfirm dialog
                    ;;
                *)
                    echo "Unsupported distribution. Please install dialog manually."
                    exit 1
                    ;;
            esac
        else
            echo "Unable to detect Linux distribution."
            exit 1
        fi
    fi
}

install_dialog

cp $HOME/.dialogrc $HOME/.dialogrc.old 2>/dev/null
echo -e "screen_color = (RED,RED,ON)\ntitle_color = (RED,WHITE,ON)\nbutton_active_color = (RED,WHITE,ON)\nbutton_label_active_color = (RED,WHITE,ON)\nbutton_key_inactive_color = (RED,WHITE,ON)" > $HOME/.dialogrc
dialog --title "How to install the package" --msgbox " Using cracked licenses is illegal and can lead to serious consequences. It is important to respect software licensing agreements and support developers by purchasing legitimate licenses.\n\n As an Iranian, I understand the challenges of affording software due to currency value. While I have chosen to use a workaround, I strongly advise you to purchase a proper license.\n\n If you cannot afford it, please be aware that using cracked software is at your own risk, and I am not responsible for any repercussions. Additionally, I would like to clarify that I have not cracked the software; I only created a script to automate the installation process.\n\n Stay safe and consider legal options whenever possible!" 26 50 && clear
rm $HOME/.dialogrc && cp $HOME/.dialogrc.old $HOME/.dialogrc 2>/dev/null


TEMP_FILE=$(mktemp)

dialog --title "Select Options" --checklist "Choose your options:" 15 68 2 \
    1 "Install Maple 2022" off \
    2 "Crack Maple that installed in \$HOME/maple2022 path" off 2> "$TEMP_FILE" \
    && clear

RESULT=$(<"$TEMP_FILE")
rm "$TEMP_FILE"

if [ -z "$RESULT" ]; then
    exit 0
fi

if echo "$RESULT" | grep 1 2>&1 >/dev/null; then
    if [ ! -f "$INSTALLER_FILE" ]; then
        wget -O $INSTALLER_FILE https://www.maplesoft.com/downloads/\?d\=61AB59890F2313B2241FDE3423FD975E\&v\=4\&f\=Maple2022.2LinuxX64Installer.run
    fi
    chmod +x "$INSTALLER_FILE"
fi

if echo "$RESULT" | grep 2 2>&1 >/dev/null; then
    if [ ! -f "$CRACK_FILE" ]; then
        wget https://pdn.sharezilla.ir/d/software/Maplesoft.Maple.2022.2.x64.Linux.Crack.zip
    fi
    unzip -P "$CRACK_FILE_PASSWORD" "$CRACK_FILE" 2>&1 >/dev/null

fi


if echo "$RESULT" | grep 1 2>&1 >/dev/null; then
    if echo "$RESULT" | grep 2 2>&1 >/dev/null; then
        dialog --title "How to install the package" --msgbox " Please do not change the installation path; just press 'Next Next Next' until you finish.\n\n After the installation is finished, close the window so the script can do all its jobs." 10 50 && clear
    fi
    ./"$INSTALLER_FILE"
fi

if echo "$RESULT" | grep 2 2>&1 >/dev/null; then
    cp Crack/libmaple.so "$HOME"/maple2022/bin.X86_64_LINUX/
    cp Crack/license.dat "$HOME"/maple2022/license/
    rm -rf Crack
fi

dialog --title "All done" --msgbox "Launch the Maple and be enjoy." 5 35
