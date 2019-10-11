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

WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

mkdir -p $WORKING_DIR/temp $WORKING_DIR/MIUI_FASTBOOT $WORKING_DIR/STUFF


PS3='Please enter your phone variant: '
options=("GLOBAL" "EEA" "CN" "RU" "INDIA" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "GLOBAL")
            URL="http://bigota.d.miui.com/V10.3.11.0.PFJMIXM/davinci_global_images_V10.3.11.0.PFJMIXM_20190802.0000.00_9.0_global_ea6683ef55.tgz"
            FILENAME="davinci_global_images_V10.3.11.0.PFJMIXM_20190802.0000.00_9.0_global_ea6683ef55"
            FULLFILENAME="$FILENAME.tar"
            break
            ;;
        "EEA")
            URL="http://bigota.d.miui.com/V10.3.12.0.PFJEUXM/davinci_eea_global_images_V10.3.12.0.PFJEUXM_20190801.0000.00_9.0_eea_1d38ae0ec5.tgz"
            FILENAME="davinci_eea_global_images_V10.3.12.0.PFJEUXM_20190801.0000.00_9.0_eea_1d38ae0ec5"
            FULLFILENAME="$FILENAME.tar"
            break
            ;;
        "CN")
            URL="http://bigota.d.miui.com/V10.3.15.0.PFJCNXM/davinci_images_V10.3.15.0.PFJCNXM_20190827.0000.00_9.0_cn_62327c4a51.tgz"
            FILENAME="davinci_images_V10.3.15.0.PFJCNXM_20190827.0000.00_9.0_cn_62327c4a51"
            FULLFILENAME="$FILENAME.tar"
            break
            ;;
        "RU")
            URL="http://bigota.d.miui.com/V10.3.10.0.PFJRUXM/davinci_ru_global_images_V10.3.10.0.PFJRUXM_20190801.0000.00_9.0_global_6fbab43f85.tgz"
            FILENAME="davinci_ru_global_images_V10.3.10.0.PFJRUXM_20190801.0000.00_9.0_global_6fbab43f85"
            FULLFILENAME="$FILENAME.tar"
            break
            ;;
        "INDIA")
            URL="http://bigota.d.miui.com/V10.3.8.0.PFJINXM/davinciin_in_global_images_V10.3.8.0.PFJINXM_20190816.0000.00_9.0_in_f68dcf8608.tgz"
            FILENAME="davinciin_in_global_images_V10.3.8.0.PFJINXM_20190816.0000.00_9.0_in_f68dcf8608"
            FULLFILENAME="$FILENAME.tar"
            break
            ;;
        "Quit")
            echo "Quitting!"
            exit 1
            ;;

        *) echo "Invalid option! option $REPLY";;
    esac
done

fastboot devices || echo "You don't have fastboot installed! Go and get it installed :V" && exit 1
cd $WORKING_DIR/temp
aria2c -x16 -j$(nproc) ${URL} || wget ${URL} || exit 1

tar -xvzf $WORKING_DIR/temp/$FULLFILENAME -C $WORKING_DIR/MIUI_FASTBOOT

# Wat am i even duing
rm -rf $WORKING_DIR/MIUI_FASTBOOT/$FILENAME/flash_all_except_storage.sh
cp $WORKING_DIR/flash_all_except_storage.sh $WORKING_DIR/MIUI_FASTBOOT/$FILENAME/./
cd $WORKING_DIR/MIUI_FASTBOOT/$FILENAME

bash flash_all_except_storage.sh

cd $WORKING_DIR
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
fastboot erase recovery
fastboot flash recovery twrp.img
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

