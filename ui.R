library(shiny)
library(shinyjs)
library(shinydashboard)
library(plotly)

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
          h5("Stuff can go here")
          
        ),
        dashboardBody(
          tabsetPanel(tabPanel("Data Pull",
                               div(
                                 fluidRow(
                                  selectInput("hshd_num", label="HSHD", choices=NULL) 
                                 ),
                                 fluidRow(
                                        h1("Households"),
                                        DT::dataTableOutput('hshd_households'),
                                        br(), 
                                        h1("Transactions"),
                                        DT::dataTableOutput('hshd_transactions'),
                                        br(),
                                        h1("Products"),
                                        DT::dataTableOutput('hshd_products')

                                        )
                                 
                                 
                               )
                                 
                                 
                               ), 
                      tabPanel("Update Dataset",
                               div(
                                 fileInput("household_file", "Upload Household Records DB", multiple=F, accept='.csv'), 
                                 fileInput("product_file", "Upload Products DB", multiple=F, accept='.csv'), 
                                 fileInput('transaction_file', "Upload Transactions DB", multiple=F, accept='.csv'),
                                 actionButton("upload", "Upload"), 
                                 br()
                                 )
                                 
                                 
                               ), 
                      tabPanel("Visualizations", 
                               div(selectInput("pipeline", "Pipeline Mode", choices=c("AGE_RANGE", "MARITAL", "INCOME_RANGE", "HOMEOWNER", "HH_SIZE", "CHILDREN")), 
                                   h1("Number of Transactions by Group"),
                                   plotlyOutput('transactions'), 
                                   h1("Total $$ Sales By Group"),
                                   plotlyOutput('amount')
                                   #selectInput("pipelineY", "Y Axis", choices=c('Num Transactions', 'Total Spent'))
                                   
                                   
                                   ))
                               
                               
                      ), 
                      
                               ))
                      # Show a plot of the generated distribution
                      
          )
  
  
  
}
ui <- fluidPage(
  useShinyjs(),
  login(),
  signup(),
  main_page()
  
)