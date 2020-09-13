#!/bin/bash

printf "\nWelcome to Docker images retainer!\n"

read -p "Please enter your Docker Hub user name: " user_name

printf "\nAll your images will be pulled and then deleted locally.\n"
printf "Every image you already had locally will be restored after this process.\n"
printf "Hold on, this can take a while...\n"

images=( "$@" )
present_images=( "$@" )

echo $(docker search --format "{{.Name}}" $user_name)| tr " " "\n" > ./images_file.txt
echo $(docker images --filter=reference=$user_name/*:* --format "{{.Repository}}:{{.Tag}}")|tr " " "\n" > ./present_images_file.txt

readarray -t images < ./images_file.txt
readarray -t present_images < ./present_images_file.txt

rm -f ./images_file.txt
rm -f ./present_images_file.txt

if [ ${#images[@]} -eq 1 ]
then
    printf "\nNo images were found for this username, exiting...\n"
else
    for i in $(seq 0 $((${#images[@]}-1)))
    do
        printf "\nPulling all tags of ${images[$i]}...\n\n"
        docker pull --all-tags ${images[$i]}
    done

    printf "\nDeleting all the pulled images...\n\n"
    docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | grep $user_name)

    if [ ${#present_images[@]} -eq 1 ]
    then
        printf "\nNone of your images were found locally, so nothing to restore.\n"
    else
        for i in $(seq 0 $((${#present_images[@]}-1)))
        do
            printf "\nRestoring ${present_images[$i]}...\n\n"
            docker pull ${present_images[$i]}
        done
    fi

    exp_date=$(date +%F -d "+6 months")
    printf "\nRemember using Docker images retainer again before $exp_date in order not to lose your images!\n"

fi
