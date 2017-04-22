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

function build_gapps {
  echo "Building OpenGapps flashable file..."

  logo_start=$(grep -nr '####' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh | gawk '{print $1}' FS=":" | head -1)
  logo_end=$(grep -nr '####' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh | gawk '{print $1}' FS=":" | tail -1)
  logo_end=$((logo_end+3))
  sed -ie "$logo_start,$logo_end d;" ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/-maxdepth 0 ! -path/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/set_progress/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/- Mounting/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/- Gathering device & ROM information/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/- Performing system space calculations/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/- Removing existing\/obsolete Apps/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/- Copying Log to $log_folder/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i 's/ui_print "- /ui_print "/g' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/ui_print " "/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/ui_print "- Installation complete!"/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/Installation complete!/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/Unmounting/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh
  sed -i '/app\/Calculator/d' ${TEMPORARY_FOLDER}/tools/opengapps/installer.sh

  cd ${TEMPORARY_FOLDER}/tools/opengapps/
  zip -r9 opengapps.zip *
  mv opengapps.zip ${TEMPORARY_FOLDER}/tools/
  cd -
  rm -rvf ${TEMPORARY_FOLDER}/tools/opengapps/*
  mv ${TEMPORARY_FOLDER}/tools/opengapps.zip ${TEMPORARY_FOLDER}/tools/opengapps/
}
