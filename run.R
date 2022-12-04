install.packages("shiny", repos="http://cran.us.r-project.org")
install.packages("shinyjs", repos="http://cran.us.r-project.org")
install.packages("shinydashboard", repos="http://cran.us.r-project.org")
install.packages("shinyalert", repos="http://cran.us.r-project.org")
install.packages("DT", repos="http://cran.us.r-project.org")
install.packages("plotly", repos="http://cran.us.r-project.org")

library(shiny)
runApp("app", port=3838, host="0.0.0.0")
