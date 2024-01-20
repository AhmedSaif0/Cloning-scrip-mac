

# sources and destinations drives
    source_volumes=("/dev/disk3s2" "/dev/disk3s3" "/dev/disk3s5" "/dev/disk3s6" "/dev/disk3s7" "/dev/disk4")
    destination_volumes=("/dev/disk5s2" "/dev/disk5s3" "/dev/disk5s4" "/dev/disk5s5" "/dev/disk5s6" "/dev/disk5s7")

    source="/dev/disk3"
    destination="disk5"

    # first step format dis as jhfs
    sudo diskutil eraseDisk JHFS+ NewDrive disk5 
    sleep 4

    totalSize=$(diskutil info disk5 | awk '/Disk Size/ {print $3}')
    totalSizeFormatted=$(echo $totalSize | sed 's/^[^0-9]*//;s/[Bb]$//')

    echo "                                                           "
    echo "total size of destination volume : "$totalSizeFormatted" GB"
    echo "                                                           "

    quota=$((totalSizeFormatted / 7))
    echo "each volume will be "$quota"GB"
    echo "                                                           "

    diskutil splitPartition disk5s2 JHFS+ NewVolume1 $quota"g" JHFS+ NewVolume2 $quota"g"  JHFS+ NewVolume3 $quota"g" JHFS+ NewVolume4 $quota"g" JHFS+ NewVolume5 $quota"g" JHFS+ NewVolume6 $quota"g"
echo "▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲"
    echo "                                                           "
    echo "created 6 volumes completed successfully."
    echo "                                                           "
echo "▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲"

   sleep 3

# Restoe Functons
restore_volume() {
    local source_volume="$1"
    local destination_volume="$2"

    echo "Restoring from source volume: $source_volume to destination volume: $destination_volume"
    sudo asr restore --source "$source_volume" --target "$destination_volume" --erase --noprompt
  

    sleep 2
}

# Loop through the volumes and perform the restoration
for ((i=1; i<=${#source_volumes[@]}; i++)); do

    echo "Unmounting source volume: ${source_volumes[$i]}"
    diskutil unmountDisk force "${source_volumes[$i]}"

    
    sleep 1
    echo "Unmounting destination volume: ${destination_volumes[$i]}"
    diskutil unmountDisk force "${destination_volumes[$i]}"
   
    echo "                                                           "
    echo "███████████████████████████████████████████████████████████"
    echo "                                                           "

    restore_volume "${source_volumes[$i]}" "${destination_volumes[$i]}"
done

# Final Process Remounting

    echo "Remounting source volume: $source"
    diskutil mount "$source"
  

    echo "Remounting destination volume: $destination"
    diskutil mount "$destination"
  

echo "▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲"
echo "                                                               "
    echo "Volume cloning and verification completed successfully."
echo "                                                               "
echo "▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲"

