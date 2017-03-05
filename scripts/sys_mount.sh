function sys_mount {
  echo "Copying ${ROM_NAME} needed files..."
  rsync -vr ${ROM_FOLDER}/${ROM_NAME}/* ${ANALYZE_FOLDER}/
  mkdir -p ${ANALYZE_FOLDER}/system

  echo "Extracting system.new.dat..."
  ${UTILITY_FOLDER}/sdat2img/sdat2img.py ${ROM_FOLDER}/${ROM_NAME}/system.transfer.list ${ROM_FOLDER}/${ROM_NAME}/system.new.dat ${ANALYZE_FOLDER}/system.img

  echo "Mounting EXT4 system.img..."
  sudo mount -t ext4 -o loop ${ANALYZE_FOLDER}/system.img ${ANALYZE_FOLDER}/system/
}

function sys_umount {
  echo "Unmounting ROM..."
  sudo umount ${ANALYZE_FOLDER}/system/

  echo "Cleaning unneeded temporary files..."
  rm -rvf ${ANALYZE_FOLDER}/*
}
