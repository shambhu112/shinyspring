## This Shiny App created with Shinyspring - http://www.shinyspring.dev
## template bs4Dash

library(shiny)
library(bs4Dash)
library(thematic)
library(waiter)
library(sweetmods)

thematic_shiny()

params <- config::get(file = "{{sweetmod_config}}") # @@ sweetmod_config
controller <- sweetmods::app_master$new(params)


## Define UI for application that draws a histogram
ui <- bs4Dash::dashboardPage(
  ##   preloader = list(
  ##       waiter = list(html = tagList(spin_1(), "Loading ..."), color = "##343a40"),
  ##       duration = 0
  ##   ),

  dark = TRUE,
  help = FALSE,
  fullscreen = TRUE,
  scrollToTop = TRUE,
  header = dashboardHeader(
    title = dashboardBrand(
      title = "{{app_title}}", ## @@app_title
      color = "primary",
      href = "{{header_href}}", ## @@header_href
      image = "{{header_image}}", ##@@header_image
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
      ),
      userOutput("user")
    ),
    leftUi = tagList(
      ## Close dropdownMenu
      tags$li(class = "dropdown",
              tags$h3("Application Name") ## $$app_title_h3
      )
    ) ## close left UI
  ),
  sidebar = dashboardSidebar(
    fixed = TRUE,
    skin = "light",
    status = "primary",
    id = "sidebar",
    sidebarUserPanel(
      image = "https://image.flaticon.com/icons/svg/1149/1149168.svg", ## @@welcome_image
      name = "Welcome" ## @@welcome_message
    ),
    sidebarMenu(
      id = "current_tab",
      flat = FALSE,
      compact = FALSE,
      childIndent = TRUE,
      sidebarHeader("Banks"),
      ## for loop here for cheetah3

      menuItem(
        "MenuItem 1",
        tabName = "institutions_tab",
        icon = icon("university")
      ),
      menuItem(
        "Branch Analysis",
        tabName = "branches_tab",
        icon = icon("piggy-bank")
      )

    )
  ), ## Close of sidebar
  body = dashboardBody(
    tabItems(
      ## for loop here for cheetah3
      tabItem(tabName = "learning_tab", "Learning"),
      tabItem(tabName = "credits_tab", "Credits")

    )
  ) ## close of body
)

## Define server logic required to draw a histogram
server <- function(input, output , session) {

}

## Run the application
shinyApp(ui = ui, server = server)
