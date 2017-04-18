#!/bin/bash
# Copyright 2016 FreedomOS
# Copyright 2017 LibertineOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function dat_to_dat {
  echo "Copying ${ROM_NAME} needed files..."
  rsync -vr ${ROM_FOLDER}/${ROM_NAME}/* ${TEMPORARY_FOLDER}/ --exclude='system.transfer.list' --exclude='system.new.dat' --exclude='system.patch.dat' --exclude='META-INF/'
  mkdir -p ${TEMPORARY_FOLDER}/mount
  mkdir -p ${TEMPORARY_FOLDER}/system

  mkdir -p ${TEMPORARY_FOLDER}/boot
  cp ${TEMPORARY_FOLDER}/boot.img ${TEMPORARY_FOLDER}/boot/boot.img
  cd ${TEMPORARY_FOLDER}/boot
  echo "Extracting the Kernel..."
  ${UTILITY_FOLDER}/unpackbootimg -i boot.img -o .
  echo "Extracting the ramdisk..."
  ${UTILITY_FOLDER}/abootimg-unpack-initrd boot.img-ramdisk.gz

  if [[ $ANDROID_VERSION = 6 ]]; then
    echo "Getting file_contexts..."
    cp ${TEMPORARY_FOLDER}/boot/ramdisk/file_contexts ${TEMPORARY_FOLDER}/
  elif [[ $ANDROID_VERSION = 7 ]]; then
    echo "Getting file_contexts.bin..."
    cp ${TEMPORARY_FOLDER}/boot/ramdisk/file_contexts.bin ${TEMPORARY_FOLDER}/
    #echo "Convert into file_contexts..."
    #${build_root}/tools/${HOST_ARCH}/sefcontext/sefcontext -o ${TEMPORARY_FOLDER}/file_contexts ${TEMPORARY_FOLDER}/file_contexts.bin
    #rm -vf ${TEMPORARY_FOLDER}/file_contexts.bin
  fi

  cd ${TEMPORARY_FOLDER}
  echo "Extracting system.new.dat..."
  ${UTILITY_FOLDER}/sdat2img/sdat2img.py ${ROM_FOLDER}/${ROM_NAME}/system.transfer.list ${ROM_FOLDER}/${ROM_NAME}/system.new.dat ${TEMPORARY_FOLDER}/system.img

  echo "Mounting EXT4 system.img..."
  sudo mount -t ext4 -o loop ${TEMPORARY_FOLDER}/system.img ${TEMPORARY_FOLDER}/mount/

  if [ ! -z "${CLEAN_SYSTEM_LIST}" ]; then
    echo "Removing unneeded system files..."
    for i in ${CLEAN_SYSTEM_LIST}
    do
      echo "Removing ${i}..."
      sudo rm -rvf ${TEMPORARY_FOLDER}/mount/${i}
    done
  fi

  if [ ! -z "${ADD_SYSTEM_LIST}" ]; then
    echo "Adding system files for ${ARCH}..."
    for i in ${ADD_SYSTEM_LIST}
    do
      echo "Adding ${i}..."
      sudo mkdir -p ${TEMPORARY_FOLDER}/mount/${i}
      sudo cp -rvf ${ASSETS_FOLDER}/system/${ARCH}/${i}/* ${TEMPORARY_FOLDER}/mount/${i}
    done
  fi

  # TODO: Convert to a global API handled by *.ini.
  echo "Modifying build properties..."
  sudo sed -i "s/ro.build.display.id=.*/ro.build.display.id=${NAME}-${TAG}-${ROM_ID} ${RELTYPE}/" ${TEMPORARY_FOLDER}/mount/build.prop
  sudo sed -i "s/ro.product.locale=.*/ro.product.locale=en-US/" ${TEMPORARY_FOLDER}/mount/build.prop
  sudo sed -i "/ro.mtk_default_ime=.*/d" ${TEMPORARY_FOLDER}/mount/build.prop

  echo "Building new EXT4 system..."
  sudo ${UTILITY_FOLDER}/make_ext4fs -T 0 -S file_contexts -l ${SYSTEMIMAGE_PARTITION_SIZE} -a system system_new.img mount/

  echo "Converting EXT4 raw image to sparse image..."
  ${UTILITY_FOLDER}/img2simg system_new.img system_new_sparse.img

  echo "Converting sparse image to sparse data..."
  if [[ $ANDROID_VERSION = 6 ]]; then
    ${SCRIPTS_FOLDER}/img2sdat.sh ${TEMPORARY_FOLDER}/system_new_sparse.img . 3
  elif [[ $ANDROID_VERSION = 7 ]]; then
    ${SCRIPTS_FOLDER}/img2sdat.sh ${TEMPORARY_FOLDER}/system_new_sparse.img . 4
  fi

  echo "Unmounting ROM..."
  sudo umount ${TEMPORARY_FOLDER}/mount/

  echo "Cleaning unneeded temporary files..."
  rm -rvf ${TEMPORARY_FOLDER}/mount
  rm -rvf ${TEMPORARY_FOLDER}/system.img
  rm -rvf ${TEMPORARY_FOLDER}/system_new*
  rm -rvf ${TEMPORARY_FOLDER}/boot
  rm -rvf ${TEMPORARY_FOLDER}/system
}
