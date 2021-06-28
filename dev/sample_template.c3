# This Shiny App created with Shinyspring - http://www.shinyspring.dev
# template bs4Dash

library(shiny)
library(bs4Dash)
library(thematic)
library(waiter)
library(sweetmods)

thematic_shiny()

params <- config::get(file = "@@shinyspring_config") # @@shinyspring_config
controller <- sweetmods::app_master$new(params)

#for {menu_count} in
