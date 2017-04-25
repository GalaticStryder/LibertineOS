#!/bin/bash
# Copyright 2016 Antoine GRAVELOT
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
# Contributors : TimVNL, Mavy

function add_files {
  echo "Adding META-INF files..."
  mkdir -p ${TEMPORARY_FOLDER}/META-INF/com/google/android/
  cp -vf ${DAROMA_FOLDER}/aroma-config ${TEMPORARY_FOLDER}/META-INF/com/google/android/
  cp -vf ${DAROMA_FOLDER}/updater-script ${TEMPORARY_FOLDER}/META-INF/com/google/android/

  echo "Adding aroma binaries..."
  cp -vf ${AROMA_FOLDER}/update-binary/update-binary ${TEMPORARY_FOLDER}/META-INF/com/google/android/
  cp -vf ${AROMA_FOLDER}/update-binary/update-binary-installer ${TEMPORARY_FOLDER}/META-INF/com/google/android/

  echo "Adding aroma configuration files..."
  mkdir -p ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma/
  cp -vf ${DAROMA_FOLDER}/changelog.txt ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma/
  cp -rvf ${AROMA_FOLDER}/common/* ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma/

  echo "Placing tools in temporary folder..."
  mkdir -p ${TEMPORARY_FOLDER}/tools
  for i in ${TOOLS_LIST}
  do
    cp -rvf ${ASSETS_FOLDER}/tools/${i} ${TEMPORARY_FOLDER}/tools/
  done

  echo "Setting device assert in updater-script..."
  sed -i "s:!assert!:$ASSERT:" ${TEMPORARY_FOLDER}/META-INF/com/google/android/updater-script

  echo "Setting VERSION as TAG in aroma..."
  sed -i "s:!version!:$TAG:" ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma-config

  echo "Setting device in aroma..."
  sed -i "s:!device!:$DEVICE:" ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma-config

  echo "Setting date in aroma..."
  sed -i "s:!date!:$(date +"%d%m%y"):" ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma-config

  echo "Setting date in en.lang..."
  sed -i "s:!date!:$(date +"%d%m%y"):" ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma/langs/en.lang

  echo "Setting firmware ID in en.lang..."
  sed -i "s:!id!:$BIG_ID:" ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma/langs/en.lang

  echo "Setting date in pt.lang..."
  sed -i "s:!date!:$(date +"%d%m%y"):" ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma/langs/pt.lang

  echo "Setting firmware ID in pt.lang..."
  sed -i "s:!id!:$BIG_ID:" ${TEMPORARY_FOLDER}/META-INF/com/google/android/aroma/langs/pt.lang
}
