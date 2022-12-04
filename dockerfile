FROM rocker/shiny-verse:latest

ENV PORT=3838

# # make user shiny
# RUN useradd -m shiny
# RUN chown shiny:shiny /home/shiny

# create app folder for user
RUN mkdir /home/shiny/app
RUN chown shiny:shiny /home/shiny/app

# copy app
COPY . /home/shiny/app
RUN ls /home/shiny/app
RUN ls /home/shiny/app/app

# run app
WORKDIR /home/shiny/app
EXPOSE 3838
CMD ["Rscript", "/home/shiny/app/run.R"]
