# material-calendar-docker


To start, run docker build -t hagen/booking-app . && docker run -it -v PathToMaterialCalendarRepo:/var/www/nodejs/material-calendar -v PathToMaterialCalendarAPIRepo:/var/www/nodejs/material-calendar-api -p 3000:3000 -p 3001:3001 -p 81:80 hagen/booking-app
