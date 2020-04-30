#!/bin/sh
echo "NTFS partitions detected: "
echo "-------"
diskutil list | awk '{if ($2 == "Windows_NTFS") { print $0} }' | awk '{ print NR-1 " -> label: " $3 ", capacity: "  $4 " " $5 ", partition: " $6}' 
echo 
echo "X -> Exit"
echo "-------"
read -p "Select one option: " option
if [[ $option =~ [0-9]{1} ]]; then
	selected=`diskutil list | awk '{if ($2 == "Windows_NTFS") { print $0} }' | awk '{print NR-1 " " $6 " " $3}' | awk -v opt="$option" '{if ($1 == opt) {print $0}}'`
	#part=`diskutil list | awk '{if ($2 == "Windows_NTFS") { print $0} }' | awk '{print NR-1 " " $6 }' | awk -v opt="$option" '{if ($1 == opt) {print $2}}'`
	part=`echo $selected | awk '{print $2}'`
	if [[ -n $part ]]; then
		label=`echo $selected | awk '{print $3}'`
		echo "Selected partition: $part"
		diskutil unmount /dev/$part
		sudo mkdir -p "/Volumes/$label"
		sudo /usr/local/bin/ntfs-3g /dev/$part "/Volumes/$label" -olocal -oallow_other -o auto_xattr
	else
		echo "Not valid selection..."
	fi
else
	if [[ $option =~ [xX]{1} ]]; then
		echo "GoodBye!"
	else
		echo "Must be a number or letter 'X'..."
	fi
fi
echo
