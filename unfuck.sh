#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later

#    Haruka Development [General Scripts]
#    Copyright (C) 2019 Haruka LLC. (behalf of Akito Mizukito)

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.

#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

function pause(){
   read -p "$*"
}
echo "-------------------------------"
echo ""
echo ""
echo "Please have your phone in fastboot mode!"
echo "and you must also plug it in your PC/Laptop"
echo ""
echo ""
echo "-------------------------------"
pause 'Press [Enter] key to continue...'

# Best way to check if your phone are connected to PC/Laptop or not, and to check if fastboot is installed or not.
fastboot devices || echo "You don't have fastboot installed! Go and get it installed :V" && exit 1


WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Creating folder
mkdir -p $WORKING_DIR/temp $WORKING_DIR/MIUI_FASTBOOT $WORKING_DIR/STUFF

# Some case stuff
PS3='Please enter your phone variant: '
options=("GLOBAL" "EEA" "CN" "RU" "INDIA" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "GLOBAL")
            URL="http://bigota.d.miui.com/V10.3.11.0.PFJMIXM/davinci_global_images_V10.3.11.0.PFJMIXM_20190802.0000.00_9.0_global_ea6683ef55.tgz"
            DIRNAME="davinci_global_images_V10.3.11.0.PFJMIXM_20190802.0000.00_9.0_global_ea6683ef55"
            FFN="$DIRNAME.tgz"
            break
            ;;
        "EEA")
            URL="http://bigota.d.miui.com/V10.3.12.0.PFJEUXM/davinci_eea_global_images_V10.3.12.0.PFJEUXM_20190801.0000.00_9.0_eea_1d38ae0ec5.tgz"
            DIRNAME="davinci_eea_global_images_V10.3.12.0.PFJEUXM_20190801.0000.00_9.0_eea_1d38ae0ec5"
            FFN="$DIRNAME.tgz"
            break
            ;;
        "CN")
            URL="http://bigota.d.miui.com/V10.3.15.0.PFJCNXM/davinci_images_V10.3.15.0.PFJCNXM_20190827.0000.00_9.0_cn_62327c4a51.tgz"
            DIRNAME="davinci_images_V10.3.15.0.PFJCNXM_20190827.0000.00_9.0_cn_62327c4a51"
            FFN="$DIRNAME.tgz"
            break
            ;;
        "RU")
            URL="http://bigota.d.miui.com/V10.3.10.0.PFJRUXM/davinci_ru_global_images_V10.3.10.0.PFJRUXM_20190801.0000.00_9.0_global_6fbab43f85.tgz"
            DIRNAME="davinci_ru_global_images_V10.3.10.0.PFJRUXM_20190801.0000.00_9.0_global_6fbab43f85"
            FFN="$DIRNAME.tgz"
            break
            ;;
        "INDIA")
            URL="http://bigota.d.miui.com/V10.3.8.0.PFJINXM/davinciin_in_global_images_V10.3.8.0.PFJINXM_20190816.0000.00_9.0_in_f68dcf8608.tgz"
            DIRNAME="davinciin_in_global_images_V10.3.8.0.PFJINXM_20190816.0000.00_9.0_in_f68dcf8608"
            FFN="$DIRNAME.tgz"
            break
            ;;
        "Quit")
            echo "Quitting!"
            exit 1
            ;;

        *) echo "Invalid option! option $REPLY";;
    esac
done

# Fetching builds, If it cannot find aria2c it gonna fall to wget, if your service are suck and does not have wget, MEH
aria2c -x16 -j$(nproc) ${URL} || wget ${URL} || exit 1

# Extract Fastboot File :3
tar -xzf $WORKING_DIR/temp/$FFN -C $WORKING_DIR/MIUI_FASTBOOT

# Removed stock flash_all_except_storage.sh from extracted fastboot folder
rm -rf $WORKING_DIR/MIUI_FASTBOOT/$DIRNAME/flash_all_except_storage.sh

# Copy our flash_all_except_storage.sh into extracted fastboot folder
cp $WORKING_DIR/flash_all_except_storage.sh $WORKING_DIR/MIUI_FASTBOOT/$DIRNAME/./

# CD to extracted fastboot folder
cd $WORKING_DIR/MIUI_FASTBOOT/$DIRNAME

# Run flashing script~
bash flash_all_except_storage.sh

# CD to working dir indeed
cd $WORKING_DIR

# Flash vbmeeta with disable verification
fastboot --disable-verity --disable-verification flash vbmeta $WORKING_DIR/vbmeta.img

# Erase TWRP
fastboot erase recovery

# Reflash TWRP
fastboot flash recovery $WORKING_DIR/twrp.img

# Removed our work stuff
rm -rf $WORKING_DIR/STUFF/ $WORKING_DIR/MIUI_FASTBOOT/ $WORKING_DIR/temp/

echo ""
echo ""
echo "-------------------------------"
echo ""
echo ""
echo "Done! You are now unfucked! Please reflash Evolution X"
echo "and then flash Magisk and boom! You'll be booting the rom"
echo "without losing any data, you're successfully UNFUCKED!"
echo ""
echo ""
echo "-------------------------------"

