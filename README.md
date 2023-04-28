# Material Calendar Docker
This is a docker container that runs the [Material Calendar Frontend](https://github.com/dwmorrin/material-calendar), [API Backend](https://github.com/dwmorrin/material-calendar-api), and mysql compaitble server. It is intended mainly for development purposes. While the latest commits on the repos are pulled during setup and can be used directly, it is intended that you mount the repos as volumes to the container so that you can make changes to the code and see them reflected in the container.

## Usage
The container can either be started via docker-compose or docker run. Examples are below.
### Docker-Compose
```
version: '3'
services:
  material-calendar-app:
    container_name: material-calendar-app
    build: .
    ports:
      - "3000:3000"
      - "3001:3001"
      - "81:80"
    volumes:
      - PATH_TO_MATERIAL_CALENDAR_REPO:/var/www/nodejs/material-calendar
      - PATH_TO_MATERIAL_CALENDAR_API_REPO:/var/www/nodejs/material-calendar-api
```
### Docker Run
```
#Build the container
docker build -t material-calendar-app .

# Run the container
docker run -it \
-v PATH_TO_MATERIAL_CALENDAR_REPO:/var/www/nodejs/material-calendar \
-v PATH_TO_MATERIAL_CALENDAR_API_REPO:/var/www/nodejs/material-calendar-api \
-p 3000:3000 -p 3001:3001 -p 81:80 \
material-calendar-app
```
