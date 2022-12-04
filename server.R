install.packages("shinyjs", repos="http://cran.us.r-project.org")
install.packages("shiny", repos="http://cran.us.r-project.org")
install.packages("shinydashboard", repos="http://cran.us.r-project.org")
library(shiny)
library(shinyjs)
library(shinydashboard)

# Define UI for application that plots random distributions
DB_households = read.csv("data/400_households.csv")

DB_products = read.csv("data/400_products.csv")

DB_transactions = read.csv("data/400_transactions.csv")

DB_users = read.csv("data/users.csv")
server = shinyServer(function(input, output) {
  
  observe({
    print("Hello")
    hide("missing_login_info")
    hide('wrong_login')
    # Default initialization shinyjs hides. 
    hide('reg_success')
    hide('missing_info')
    hide("unique_user")
    hide("main_page_div")
    hide("sign_up_div")
  })
  
  observeEvent(input$signup, { # Show sign up page
    hide("log_in_div")
    show("sign_up_div")
    hide("unique_user")
    hide("missing_info")
    
  })
  
  
  observeEvent(input$register, {
    # Check if no duplicate names, and append to user database
    
    # Make sure we inputted everything
    show("missing_info")
    req(input$reg_username)
    req(input$reg_password)
    req(input$reg_email)
    hide("missing_info")
    if(input$reg_username %in% DB_users$username){
      show("unique_user")
      
    }else{
      hide("unique_user")
      
      # TODO: Append data to row and then redirect to login screen
      new_user = data.frame(username=input$reg_username, password=input$reg_password, email=input$reg_email) 
      DB_users <<- rbind(DB_users, new_user)
      write.csv(DB_users, 'data/users.csv', row.names = FALSE)
      hide("sign_up_div")
      show("log_in_div")
      show("reg_success")
    }
    
  })
  
  observeEvent(input$login, {
    show("missing_login_info")
    req(input$username)
    req(input$password)
    hide('missing_login_info')
    
    if(input$username %in% DB_users$username){
      userObj = DB_users[DB_users$username=='']
      if(DB_users[DB_users$username==input$username,]$password == input$password){
        #LOGIN
        hide("log_in_div")
        show('main_page_div')
        
      }else{
        show("wrong_login")
        
      }
    }else{
      show("wrong_login")
      
    }
    
  })
  
  
})