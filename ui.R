library(shiny)
library(shinyjs)
library(shinydashboard)

login <- function(){
  
  div(id='log_in_div',
      h1("Login"),
      h5(id='reg_success', "Registration Successful"), 
      h5(id='missing_login_info', 'Please make sure your username and password have both been entered and try again. '),
      h5(id='wrong_login', "Your username or password were incorrect. Please try again."),
      textInput('username',"Username"), 
      textInput('password', "Password"), 
      actionButton("login", 'Log In'), 
      actionButton("signup", "Create New Account")
  )
}
signup <- function(){
  
  
  div(id='sign_up_div',
      h1("Sign Up"),
      h5(id="missing_info", "You are missing something. Please make sure everthing is filled out and try again"), 
      h5(id="unique_user", "Username already taken. Please try something else"),
      textInput('reg_username',"Username"), 
      textInput('reg_password', "Password"), 
      textInput("reg_email", "EMail"),
      actionButton("register", "Register")
  )
}

main_page <- function(){
  div(id='main_page_div',
      dashboardPage(
        dashboardHeader(title="KPI Dashboard"),
        
        # Sidebar with a slider input for number of bins 
        dashboardSidebar(
          selectInput('pipeline', "Pipeline mode", choices=c('Default'='no_pipeline',
                                                             'Close Status'='close_status',
                                                             'Close Reason'='close_reason',
                                                             'Customer Name'='customer_name',
                                                             'Market Segment'='segment',
                                                             'Created By'='full_name',
                                                             'Customer Country'= 'customer_country',
                                                             'Customer Region'='customer_region',
                                                             'rs flavor family'='rs_flavor_family'), multiple = F)
          
        ),
        dashboardBody(
          tabsetPanel(tabPanel("a", h1("Hello"))
                      # Show a plot of the generated distribution
                      
          )))
  )
  
  
}
ui <- fluidPage(
  useShinyjs(),
  login(),
  signup(),
  main_page()
  
)