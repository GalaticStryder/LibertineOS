#!/bin/bash
#
# Copyright - Ícaro Hoff <icarohoff@gmail.com>
#

# Colorize
red='\033[01;31m'
green='\033[01;32m'
yellow='\033[01;33m'
blue='\033[01;34m'
rose="\033[01;35m"
cyan="\033[01;36m"
blink_red='\033[05;31m'
blink_green='\033[05;32m'
blink_yellow='\033[05;33m'
blink_blue='\033[05;34m'
blink_rose="\033[05;35m"
blink_cyan="\033[05;36m"
restore='\033[0m'

# Cleaning
clear

# Naming
NAME="LibertineOS"

# Date
BUILD_DATE=$(date -u +%m%d%Y)

# Arguments
MODE=${1};
CONFIG=${2};

# Host
HOST_ARCH=`uname -m`
HOST_OS=`uname -s`
HOST_OS_EXTRA=`uname -a`

# Paths
LOS_FOLDER=`pwd`
ROM_FOLDER="${LOS_FOLDER}/rom"
ANALYZE_FOLDER="${LOS_FOLDER}/analyze"
CONFIG_FOLDER="${LOS_FOLDER}/configuration"
DOWNLOAD_FOLDER="${LOS_FOLDER}/download"
SCRIPTS_FOLDER="${LOS_FOLDER}/scripts"
UTILITY_FOLDER="${LOS_FOLDER}/utility"
AROMA_FOLDER="${LOS_FOLDER}/aroma"
ASSETS_FOLDER="${LOS_FOLDER}/assets"
TEMPORARY_FOLDER="${LOS_FOLDER}/temporary"
OUTPUT_FOLDER="${LOS_FOLDER}/output"

# Functions
function header_logo {
	LOGO=${LOS_FOLDER}/ascii.txt
	echo -e ${blink_cyan}"" && cat ${LOGO} && echo -e ${restore}""
}

function check_folders {
	if [ ! -d ${ROM_FOLDER} ]; then
		echo -e ${yellow}"Could not find ROM folder. Creating it..."${restore}
		mkdir -p ${ROM_FOLDER}
		echo ""
	fi;
	if [ ! -d ${ANALYZE_FOLDER} ]; then
		echo -e ${yellow}"Could not find analisis folder. Creating it..."${restore}
		mkdir -p ${ANALYZE_FOLDER}
		echo ""
	fi;
	if [ ! -d ${DOWNLOAD_FOLDER} ]; then
		echo -e ${yellow}"Could not find download folder. Creating it..."${restore}
		mkdir -p ${DOWNLOAD_FOLDER}
		echo ""
	fi;
	if [ ! -d ${TEMPORARY_FOLDER} ]; then
		echo -e ${yellow}"Could not find temporary folder. Creating it..."${restore}
		mkdir -p ${TEMPORARY_FOLDER}
		echo ""
	fi;
	if [ ! -d ${OUTPUT_FOLDER} ]; then
		echo -e ${yellow}"Could not find output folder. Creating it..."${restore}
		mkdir -p ${OUTPUT_FOLDER}
		echo ""
	fi;
}

function def_devar {
	echo ""
	echo -e ${blue}"Setting up definitions for ${CONFIG}..."${restore}
	source ${CONFIG_FOLDER}/${CONFIG}.ini
	IDENTIFIER="${CODENAME}-${ROM_ID}"
	DAROMA_FOLDER="${AROMA_FOLDER}/${IDENTIFIER}"
	OUTPUT_FILE="${NAME}-${DEVICE}-${BIG_ID}-${TAG}-${BUILD_DATE}"
}

function download_rom {
	echo -e ${blue}"Checking ROM..."${restore}
	if [ ! -f  ${DOWNLOAD_FOLDER}/${ROM_NAME}.zip ]; then
		echo "File ${ROM_NAME}.zip does not exist. Downloading ..."
		if wget --spider ${ROM_LINK} &> /dev/null
		then
			if [ $(which aria2c) ]; then
				aria2c ${ROM_LINK} -d ${DOWNLOAD_FOLDER}
			else
				cd ${DOWNLOAD_FOLDER}
				wget ${ROM_LINK} &> /dev/null
				cd - &> /dev/null
			fi;
		else
			echo -e ${red}"The mirror for ${ROM_NAME} is offline! Check your connection."${restore}
			exit
		fi;
	else
		echo "Checking MD5 of ${ROM_NAME}.zip"
		if [[ ${ROM_MD5} == $(md5sum ${DOWNLOAD_FOLDER}/${ROM_NAME}.zip | cut -d ' ' -f 1) ]]; then
			echo "Checked MD5 of ${ROM_NAME}.zip."
			echo -e ${green}"Checksums OK."${restore}
		else
			echo "File ${ROM_NAME}.zip is corrupted, restarting download..."
			rm -rvf ${DOWNLOAD_FOLDER}/${ROM_NAME}.zip.bak
			mv -vf ${DOWNLOAD_FOLDER}/${ROM_NAME}.zip ${DOWNLOAD_FOLDER}/${ROM_NAME}.zip.bak
			download_rom
		fi;
	fi;
}

function extract_sys {
	if [ ! -f ${ROM_FOLDER}/${ROM_NAME}/system.new.dat ]; then
		echo ""
		echo -e ${blue}"Extracting ${ROM_NAME} for the ${DEVICE}..."${restore}
		mkdir -p ${ROM_FOLDER}/${ROM_NAME}
		unzip -o ${DOWNLOAD_FOLDER}/${ROM_NAME}.zip -d ${ROM_FOLDER}/${ROM_NAME}
	fi;
}

function header_info {
	echo ""
	echo "============================================"
	echo "TARGET_DEVICE=${DEVICE}"
	echo "CODENAME=${CODENAME}"
	echo "ROM_ID=${BIG_ID}" # Display the uppercase one.
	echo "ASSERT=${ASSERT}"
	echo "ROM_NAME=${ROM_NAME}"
	echo "TARGET_ARCH=${ARCH}"
	echo "TARGET_PLATFORM=${PLATFORM}"
	echo "HOST_ARCH=${HOST_ARCH}"
	echo "HOST_OS=${HOST_OS}"
	echo "HOST_OS_EXTRA=${HOST_OS_EXTRA}"
	echo "BUILD_TAG=${TAG}"
	echo "BUILD_DATE=${BUILD_DATE}"
	echo "BUILD_ID=${IDENTIFIER}"
	echo "OUTPUT_FILE=${OUTPUT_FILE}.zip"
	echo "============================================"
	echo ""
}

# Display our ASCII art.
header_logo

# Properly set the script mode.
if [ -z "$2" ]; then
	CONFIG=${1};
	if [ -z "$1" ]; then
		echo -e ${blink_red}"No configuration was set, aborting..."${restore}
		exit
	fi;
	echo -e ${red}"Please, set the script mode below."${restore};
	echo -e ${yellow}"Available:"${restore};
	echo -e ${blue}"BUILD: Dumps the ROM, extracts and modifies the system, then repacks with AROMA support."${restore};
	echo -e ${blue}"ANALISIS: Dumps the ROM, extracts and mounts the system in the analyze folder for inspection."${restore};
	echo "";
	echo "Which is the script mode?"
	select fchoice in BUILD ANALISIS
	do
	case "$fchoice" in
		"BUILD")
			MODE="build"
			break;;
		"ANALISIS")
			MODE="analisis"
			break;;
	esac
	done
	echo ""
fi;
if [ "$MODE" = "-a" ] || [ "$MODE" = "--analisis" ]; then
	MODE="analisis"
elif [ "$MODE" = "-b" ] || [ "$MODE" = "--build" ]; then
	MODE="build"
fi;

# Look for all helper folders.
check_folders

# Select the build tag.
if [ "$MODE" = "build" ]; then
	echo "Which is the build tag?"
	select choice in SNAPSHOT NIGHTLY DEVEL
	do
	case "$choice" in
		"SNAPSHOT")
			TAG="SNAPSHOT"
			break;;
		"NIGHTLY")
			TAG="NIGHTLY"
			break;;
		"DEVEL")
			TAG="DEVEL"
			break;;
	esac
	done
fi;

# Setup definitions.
def_devar

# Get the base ROM.
download_rom

# Display build information.
header_info

# System extraction.
extract_sys

# Run the scripts.
if [ "$MODE" = "analisis" ]; then
	echo -e ${blue}"Entering system analyzer mode..."${restore}
	source ${SCRIPTS_FOLDER}/sys_mount.sh
	echo "Press M to mount your system."
	echo "Press U to unmount your system."
	
	read -n 1 -p "System analyzer:" analyzeopt
	if [ "$analyzeopt" = "M" ] || [ "$analyzeopt" = "m" ]; then
		echo ""
		sys_mount
	elif [ "$analyzeopt" = "U" ] || [ "$analyzeopt" = "u" ]; then
		echo ""
		sys_umount
	else
		echo ""
		echo -e ${blink_red}"Not valid, exiting..."${restore}
		exit
	fi;
else if [ "$MODE" = "build" ]; then
	echo -e ${blue}"Entering build system mode..."${restore}
	source ${SCRIPTS_FOLDER}/dat_to_dat.sh
	dat_to_dat

	source ${SCRIPTS_FOLDER}/add_files.sh
	add_files

	source ${SCRIPTS_FOLDER}/build_arise.sh
	build_arise
	build_arise4magisk

	# DEPRECATED: We'll switch to an AROMA gapps from OpenGapps instead.
	#source ${SCRIPTS_FOLDER}/build_gapps.sh
	#build_gapps

	source ${SCRIPTS_FOLDER}/make_zip.sh
	make_zip
fi;
fi;
