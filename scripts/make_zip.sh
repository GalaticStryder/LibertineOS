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
#
# FreedomOS device build script
# Contributors : TimVNL, Mavy

function make_zip {
  cd ${TEMPORARY_FOLDER}
  echo "Making flashable zip file..."
  zip -r9 "${OUTPUT_FILE}.zip" * -x "*EMPTY_DIRECTORY*"

  cd -
  echo "Copying unsigned zip file to output folder..."
  mv -v "${TEMPORARY_FOLDER}/${OUTPUT_FILE}.zip" "${OUTPUT_FOLDER}/"

  echo "Testing zip file integrity..."
  zip -T ${OUTPUT_FOLDER}/${OUTPUT_FILE}.zip

  echo "Generating md5 hash for unsigned file..."
  openssl md5 "${OUTPUT_FOLDER}/${OUTPUT_FILE}.zip" | cut -f 2 -d " " > "${OUTPUT_FOLDER}/${OUTPUT_FILE}.zip.md5"

  echo ""
  read -n 1 -p "Do you want to sign the output file? (y/n)" signer
  if [ "$signer" = "y" ] || [ "$signer" = "Y" ]; then
    echo ""
    echo "Signing the final zip file..."
    chmod +x ${UTILITY_FOLDER}/signapk.jar
    java -jar "${UTILITY_FOLDER}/signapk.jar" "${LOS_FOLDER}/certificate.pem" "${LOS_FOLDER}/key.pk8" "${OUTPUT_FOLDER}/${OUTPUT_FILE}.zip" "${OUTPUT_FOLDER}/${OUTPUT_FILE}-signed.zip"

    echo "Generating md5 hash for signed file..."
    openssl md5 "${OUTPUT_FOLDER}/${OUTPUT_FILE}-signed.zip" | cut -f 2 -d " " > "${OUTPUT_FOLDER}/${OUTPUT_FILE}-signed.zip.md5"
  fi;

  echo ""
  echo "Cleaning temporary folder..."
  rm -rvf ${TEMPORARY_FOLDER}/*
}
