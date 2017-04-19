#!/bin/bash
# Copyright 2016-2017 Antoine GRAVELOT
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

# FreedomOS device build script
# Contributors :

function build_arise {
  remove_list="
  am3d
  atmos
  ddplus
  dirac
  smeejaytee
  v4a_xhifi
  "

  echo "Building A.R.I.S.E. flashable file..."
  sed -i '/exit 0/d' ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary
  sed -i '/sleep/d' ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary
  sed -i 's/nui_print" >/nui_print" >>/g' ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary

  for i in $remove_list; do
    rm -rf ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/modules/$i
  done

  echo "rm -rf /data/data/dk.icesound.icepower" >> ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary
  echo "rm -rf /data/data/com.arkamys.audio" >> ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary
  echo "rm -rf /data/data/com.audlabs.viperfx" >> ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary
  echo "rm -rf /data/data/com.fihtdc.am3dfx" >> ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary
  echo "exit 0" >> ${TEMPORARY_FOLDER}/tools/arise/META-INF/com/google/android/update-binary
  cd ${TEMPORARY_FOLDER}/tools/arise/
  zip -r9 arise.zip * -x install.sh
  cd -
  rm -rvf ${TEMPORARY_FOLDER}/tools/arise/*/
}

function build_arise4magisk {
  echo "Building ARISE4Magisk module..."
  mv ${TEMPORARY_FOLDER}/tools/arise4magisk ${TEMPORARY_FOLDER}/tools/arise4magisk_tmp
  mkdir -p ${TEMPORARY_FOLDER}/tools/arise4magisk
  cd ${TEMPORARY_FOLDER}/tools/arise4magisk_tmp
  zip -r9 arise4magisk.zip *
  cd -
  mv ${TEMPORARY_FOLDER}/tools/arise4magisk_tmp/arise4magisk.zip ${TEMPORARY_FOLDER}/tools/arise4magisk/
  rm -rvf ${TEMPORARY_FOLDER}/tools/arise4magisk_tmp
}
