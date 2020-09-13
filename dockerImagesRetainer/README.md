# dockerImagesRetainer

Docker recently changed its Terms of Service, adding a clause that allows it to delete users' files if they haven’t been used for six months or more.

To prevent the images from being deleted, the users will have to pull or push them at least once in a period of 6 months. Pulling the images and then deleting the ones not needed from local storage could take years for users with a big volume of images stored.

This script is designed to automatically pull all of the images of a certain Docker Hub user and then deleting the ones which are not present locally before executing the script.

This will cause a renewal of the lifespan of the images and won't affect in any manner your local Docker environment.

**How to use:**

For private repositories, be sure to "docker login" before executing the script as the images won't be available for public pulls.

Locally, I have 2 images of my own repositories:

```
joeltaberne@local:~$ docker images
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
joeltf99/hostnamed-http2   latest              962d26ba8705        29 hours ago        166MB
joeltf99/hostnamed-http    latest              895f300c1ab8        30 hours ago        166MB
```

Don't be scared of losing these images, they will be restored later as I will show. You can execute the script:

```
joeltaberne@local:~$ bash images_retainer.sh

Welcome to Docker images retainer!
Please enter your Docker Hub profile name:
```

Enter your Docker Hub profile or the profile of the repositories you want to retain.

```
Please enter your Docker Hub profile name: joeltf99

All your images will be pulled and then deleted locally.
Every image you already had locally will be restored after this process.
Hold on, this can take a while...

Pulling all tags of joeltf99/apache-alpine-x86...

latest: Pulling from joeltf99/apache-alpine-x86
c9b1b535fdd9: Pull complete 
0010ddddf672: Pull complete 
d5e17d7643cd: Pull complete 
Digest: sha256:983abfc25ab137696c2744a56f75aca32b49349b83c782986ac3d5e8d17f6190
Status: Downloaded newer image for joeltf99/apache-alpine-x86
docker.io/joeltf99/apache-alpine-x86

Deleting all tags of joeltf99/apache-alpine-x86...

Untagged: joeltf99/apache-alpine-x86:latest
Untagged: joeltf99/apache-alpine-x86@sha256:983abfc25ab137696c2744a56f75aca32b49349b83c782986ac3d5e8d17f6190
Deleted: sha256:4e6d9276a61aec3b95d49390f9334fece7536c8df701e7a9109c6d425c631fc3
Deleted: sha256:9cd4f9050e1134a159ef7ca2df646ba9252374c01d63f7385a247a271bdfb469
Deleted: sha256:8f1980ac41ffa8af7338284dc0f21e828bcfde45f3a9ed6cfb6448d57a457dba
Deleted: sha256:5216338b40a7b96416b8b9858974bbe4acc3096ee60acbc4dfb1ee02aecceb10
```

This process will repeat for every single image and tag of your repos. Once finished, the images that were available locally before will be restored.

```
Restoring joeltf99/hostnamed-http2:latest...

latest: Pulling from joeltf99/hostnamed-http2
d121f8d1c412: Pull complete 
9cd35c2006cf: Pull complete 
7acc0e74847e: Pull complete 
053934cb42f0: Pull complete 
9c324bbac9b8: Pull complete 
Digest: sha256:3f66602a101ceec10e66980a11b274ecd6bc16fbcc9f3cc260ce3c45a0189904
Status: Downloaded newer image for joeltf99/hostnamed-http2:latest
docker.io/joeltf99/hostnamed-http2:latest
```

When the images are restored, the expiration date of your repositories after this script execution will be shown.

```
Remember using Docker images retainer again before 2021-03-12 in order not to lose your images!
```