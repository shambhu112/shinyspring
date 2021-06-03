## This Shiny App created with Shinyspring - http://www.shinyspring.dev
## template bs4Dash

library(shiny)
library(bs4Dash)
library(thematic)
library(waiter)
library(stringr)
library(dplyr)
library(ggplot2)
library(viridis)
#library(hrbrthemes)
library(esquisse)
library(sweetmods)

thematic_shiny()

params <- config::get(file = "whisker.yml")
controller <- app_master$new(params)
controller$preload_master_with_config()

demo_ui <- function(id, control) {
  ns <- NS(id)
  h4(paste0("Hello " , id))
}

demo_server <- function(id, control) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}

create_tab_module <- function(tab_name , module_name , module_function , control = "controller"){
  tabItem(
    tabName = tab_name,
    eval(parse(text = paste0(module_function , "(id = '" , module_name  ,"' , control = " , control, " )"  )))
  )
}


## Define UI
ui <- bs4Dash::dashboardPage(

  dark = FALSE,
  help = FALSE,
  fullscreen = TRUE,
  scrollToTop = TRUE,
  header = dashboardHeader(
    title = dashboardBrand(
      title = "Whisker Based App",
      color = "primary",
      href = "https://www.shinyspring.dev", ## @@header_href
      image = "https://storage.googleapis.com/shiny-pics/spring_logo.png", ##@@header_image
      opacity = 0.8
    ),
    fixed = TRUE, ## @@header_fixed
    rightUi = tagList(
      dropdownMenu(
        badgeStatus = "info",
        type = "notifications",
        messageItem(
          inputId = "triggerAction1",
          message = "FDIC issues list of Bank Examined for CRA compliance",
          from = "FDIC",
          image = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Seal_of_the_United_States_Federal_Deposit_Insurance_Corporation.svg/1200px-Seal_of_the_United_States_Federal_Deposit_Insurance_Corporation.svg.png",
          time = "today",
          color = "lime"
        )
      )
      ##    ,
      ##    userOutput("user")
    ),
    leftUi = tagList(
      ## Close dropdownMenu
      tags$li(class = "dropdown",
              tags$h3("Sweet Mods Test") ## $$app_title_h3
      )
    ) ## close left UI
  ),
  sidebar = dashboardSidebar(
    fixed = TRUE,
    skin = "light",
    status = "primary",
    id = "sidebar",

    ##    sidebarUserPanel(
    ##      image = "https://image.flaticon.com/icons/svg/1149/1149168.svg", ## @@welcome_image
    ##      name = "CORA" ## @@welcome_message
    ##    ),
    sidebarMenu(
      id = "current_tab",
      flat = FALSE,
      compact = FALSE,
      childIndent = TRUE,
      sidebarHeader("Data Exploration"),

      # Whisker:  Menus
     menuItem(
          "Banks" ,
          tabName = "bank_mod_tab",
          icon = icon("university")
        ),

     menuItem(
          "Branches" ,
          tabName = "branch_mod_tab",
          icon = icon("university")
        ),

     menuItem(
          "Data Exploration" ,
          tabName = "esquiee_mod_tab",
          icon = icon("university")
        )

    )

  ), ## Close of sidebar
  body = dashboardBody(
    tabItems(
      create_tab_module(tab_name = "bank_mod_tab" ,
                        module_name = "bank_mod" ,
                        module_function = "demo_ui" ) ,
      create_tab_module(tab_name = "branch_mod_tab" ,
                        module_name = "branch_mod" ,
                        module_function = "demo_ui" ) ,
      create_tab_module(tab_name = "esquiee_mod_tab" ,
                        module_name = "esquiee_mod" ,
                        module_function = "demo_ui" ) 
    )
  ) ## close of body
)

## Define server logic required to draw a histogram
server <- function(input, output , session) {
      demo_server(id = "bank_mod" , control = controller)
      demo_server(id = "branch_mod" , control = controller)
      demo_server(id = "esquiee_mod" , control = controller)

}

## Run the application
shinyApp(ui = ui, server = server)

