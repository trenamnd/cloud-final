FROM rocker/shiny-verse:latest

WORKDIR ./

RUN R -e 'install.packages(c(\
              "shiny", \
              "shinydashboard",\
              "shinyalert", \
              "shinyjs"), \
            repos="https://packagemanager.rstudio.com/all/latest"\
          )'

#RUN R -e 'install.packages("remotes")'
#run R -e 'httr::set_config( httr::config( ssl.verifypeer = 0L ) )'
#RUN R -e 'remotes::install_github("daattali/shinyjs")'
# copy the app to the image
#COPY *.Rproj /srv/shiny-server/
COPY *.R /srv/shiny-server/
COPY data/* /srv/shiny-server/data/
#COPY *.sqlite3 /srv/shiny-server/

# select port
EXPOSE 8100

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

# Copy further configuration files into the Docker image
COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]

ENTRYPOINT ["sh","/usr/bin/shiny-server.sh"]

# run app
CMD ["/usr/bin/shiny-server.sh"]
