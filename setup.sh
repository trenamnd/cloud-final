# build image
docker build -t shinyapp . --no-cache

# start image
docker run --name shinyapp -p 3838:3838 shinyapp
docker run -d --name shinyapp -p 3838:3838 shinyapp

# connect to image
docker exec -it shinyapp /bin/bash

# stop and remove image
docker stop shinyapp && docker rm shinyapp
