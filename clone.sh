

         source_volumes=("/dev/disk3s3" "/dev/disk3s4" "/dev/disk3s5" "/dev/disk3s6" "/dev/disk3s7" "/dev/disk5" "/dev/disk4")
    destination_volumes=("/volumes/NewVolume1" "/volumes/NewVolume2" "/volumes/NewVolume3" "/volumes/NewVolume4" "/volumes/NewVolume5" "/volumes/NewVolume6" "/volumes/NewVolume7")
   # destination_volumes=("/dev/disk6s2" "/dev/disk6s3" "/dev/disk6s4" "/dev/disk6s5" "/dev/disk6s6" "/dev/disk6s7" "/dev/disk6s8")

    source="/dev/disk3"
    destination="disk6"

    # first step format dis as jhfs
    sudo diskutil eraseDisk JHFS+ NewDrive $destination
    sleep 4

    totalSize=$(diskutil info $destination | awk '/Disk Size/ {print $3}')
    totalSizeFormatted=$(echo $totalSize | sed 's/^[^0-9]*//;s/[Bb]$//;s/\.[0-9]*$//')

    if [ "$totalSizeFormatted" = "1" ]; then
         totalSizeFormatted= 931
    fi

    echo "                                                           "
    echo "total size of destination volume : "$totalSizeFormatted" TB"
    echo "                                                           "

   quota=$((totalSizeFormatted / 7))
   echo "each volume will be "$quota"GB"
    echo "                                                           "

   diskutil splitPartition disk6s2 JHFS+ NewVolume1 $quota"g" JHFS+ NewVolume2 $quota"g"  JHFS+ NewVolume3 $quota"g" JHFS+ NewVolume4 $quota"g" JHFS+ NewVolume5 $quota"g" JHFS+ NewVolume6 $quota"g"


  # diskutil splitPartition disk6s2 JHFS+ NewVolume1 50g JHFS+ NewVolume2 22g  JHFS+ NewVolume3 30g JHFS+ NewVolume4 39g JHFS+ NewVolume5 39g JHFS+ NewVolume6 50g JHFS+ NewVolume7 670g

    echo "▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲"
    echo "                                                           "
    echo "created 7 volumes completed successfully."
    echo "                                                           "
    echo "▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲"

    echo "==================================================================="
    echo "this script created by Eng : Ahmed Saifeldeen for more information"
    echo "visit http://ahmedsaif.netlify.app"
    echo "==================================================================="

   sleep 3

# Restoe Functons
restore_volume() {
    local source_volume="$1"
    local destination_volume="$2"

    echo "Restoring from source volume: $source_volume to destination volume: $destination_volume"
     sudo asr restore --source "$source_volume" --target "$destination_volume"   --noverify --erase --noprompt
  

    sleep 2
}

# Loop through the volumes and perform the restoration
for ((i=0; i<=${#source_volumes[@]}; i++)); do

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


