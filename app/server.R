library(shiny)
library(shinyjs)
library(DT)
library(shinydashboard)
library(shinyalert)
options(shiny.maxRequestSize = 200 * 1024^2) # 200 MB max filesize upload

# Define UI for application that plots random distributions
DB_households = read.csv("data/400_households.csv")

DB_products = read.csv("data/400_products.csv")

DB_transactions = read.csv("data/400_transactions.csv")

DB_users = read.csv("data/users.csv")
server = shinyServer(function(input, output, session) {
  
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
  updateSelectizeInput(session, 'hshd_num', choices=unique(DB_households$HSHD_NUM), server=TRUE)
  
  output$hshd_households = DT::renderDataTable({
    req(input$hshd_num)
    DB_households[DB_households$HSHD_NUM %in% input$hshd_num, ]
    
    
  })
  
  output$hshd_transactions = DT::renderDataTable({
    req(input$hshd_num)
    DB_transactions[DB_transactions$HSHD_NUM %in% input$hshd_num, ]
    
    
  })
  output$hshd_products = DT::renderDataTable({
    req(input$hshd_num)
    trans = DB_transactions[DB_transactions$HSHD_NUM %in% input$hshd_num, ]
    
    DB_products[DB_products$PRODUCT_NUM %in% unique( trans$PRODUCT_NUM), ]
    
    
  })
  
  observeEvent(input$upload, {
    # Process uploading of new atlas and vas repo data
    req(input$household_file)
    req(input$product_file)
    req(input$transaction_file)
    shinyjs::hide("upload")
    DB_households = read.csv("data/400_households.csv")
    
    DB_products = read.csv("data/400_products.csv")
    
    DB_transactions = read.csv("data/400_transactions.csv")
    
    temp_DB_households = read.csv(input$household_file$datapath)
    
    temp_DB_products = read.csv(input$product_file$datapath)
    
    temp_DB_transactions = read.csv(input$transaction_file$datapath)
    
    if(!identical(names(temp_DB_households), names(DB_households))){
      shinyalert("Oops!", "Error 1: The column names of your HOUSEHOLDS file do not match what is currently in the database.", type='error')
    }else if(!identical(names(temp_DB_products), names(DB_products))){
      shinyalert("Oops!", "Error 2: The column names of your PRODUCTS file do not match what is currently in the database.", type='error')
    }else if(!identical(names(temp_DB_transactions), names(DB_transactions))){
      shinyalert("Oops!", "Error 3: The column names of your TRANSACTIONS file do not match what is currently in the database.", type='error')
      
      
    }else{
      
      write.csv(temp_DB_households, 'data/400_households.csv', row.names = FALSE)
      write.csv(temp_DB_products, 'data/400_products.csv', row.names = FALSE)
      write.csv(temp_DB_transactions, 'data/400_transactions.csv', row.names = FALSE)
      
      DB_households <<- temp_DB_households
      DB_products <<- temp_DB_products
      DB_transactions <<- temp_DB_transactions
      
      # Save data
      shinyalert("Upload Success!", "You are awesome", type='success')
      
      
    }
    shinyjs::show("upload")
    
    
    
  })
  
  output$amount <- renderPlotly({
    
    req(input$pipeline)
    pipeline = input$pipeline
    
    
    # Need to pivot dt to have a column for each of the pipelined elements (unique members of the pipeline channel)
    # Keep only one BR per instance
    
    
    DB_households <- DB_households[c('HSHD_NUM', pipeline)]
    DB_households <- DB_households[complete.cases(DB_households), ] # Remove any row with NA  
    View(DB_households)
    names(DB_households) <- c("HSHD_NUM", 'pipeline')
  
    

    
    dt <- dplyr::left_join(DB_households, DB_transactions, by='HSHD_NUM')
    View(dt)
    
    
    br_filt <- dt %>% dplyr::group_by(pipeline) %>% 
    dplyr::summarise(sales = sum(SPEND))
    View(br_filt)
    
    barmode = 'group'

    plot_ly(br_filt,x = ~pipeline ,y = ~sales, name=~pipeline, color = ~pipeline, type = 'bar') %>%
      layout(xaxis=list(title=input$pipeline), 
             yaxis=list(title="Total Sales"))
  })
  output$transactions <- renderPlotly({
    
    req(input$pipeline)
    pipeline = input$pipeline
    
    
    # Need to pivot dt to have a column for each of the pipelined elements (unique members of the pipeline channel)
    # Keep only one BR per instance
    
    
    DB_households <- DB_households[c('HSHD_NUM', pipeline)]
    DB_households <- DB_households[complete.cases(DB_households), ] # Remove any row with NA  
    View(DB_households)
    names(DB_households) <- c("HSHD_NUM", 'pipeline')
    
    
    DB_transactions$SPEND <- 1
    
    dt <- dplyr::left_join(DB_households, DB_transactions, by='HSHD_NUM')
    View(dt)
    
    
    br_filt <- dt %>% dplyr::group_by(pipeline) %>% 
      dplyr::summarise(sales = sum(SPEND))
    View(br_filt)
    
    barmode = 'group'
    
    plot_ly(br_filt,x = ~pipeline ,y = ~sales, name=~pipeline, color = ~pipeline, type = 'bar') %>%
      layout(xaxis=list(title=input$pipeline), 
             yaxis=list(title="Number of Transactions"))
  })
  
})