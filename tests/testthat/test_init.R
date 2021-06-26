library(shinyspring)
library(testthat)
library(shiny)

params <- config::get(file = "tests/testthat/config.yml")

mexico_ds_info <- "https://docs.google.com/spreadsheets/d/1T-p5kHvC3YcYwmuH8IVfXkCM2T4M4VS_RRuZ3-boXzI/"

custom_file_load <- function(){
    nm <- read.csv("CHART4_NM.csv")
    nm
}
