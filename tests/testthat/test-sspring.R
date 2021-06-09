library(shinyspring)
library(testthat)


params <- config::get(file = "tests/testthat/config.yml")


test_that("template create_mst_filename ", {

  dots <- list(dashboard_template = "bs4_dash" , app_type = "minimal" , config_file = "config.yml")
  yml_mst <- create_mst_filename(dots , type = "yml")
  t <-stringr::str_detect(yml_mst , "bs4/bs4_minimal_yml.mst")
  expect_true(t)

  dots <- list(dashboard_template = "bs4_dash" , app_type = "standard" , config_file = "config.yml")
  template_mst <- create_mst_filename(dots , type = "template")
  t <-stringr::str_detect(template_mst , "bs4/bs4_standard.mst")
  expect_true(t)


})

test_that("create new project ", {

  dir <- tempdir()
  curr_dir <- getwd()
  setwd(dir)
  shinyspring::create_new_project()
  a <- file.exists("config.yml")
  b <- file.exists("user_script.R")
  c <- file.exists("on_startup.R")

  file.remove("config.yml")
  file.remove("user_script.R")
  file.remove("on_startup.R")

  expect_true(a)
  expect_true(b)
  expect_true(c)

  setwd(curr_dir)

})



test_that("create _targets ", {

  dir <- tempdir()
  curr_dir <- getwd()
  setwd(dir)
  create_targets(params)
  a <- file.exists("_targets.R")
  file.remove("_targets.R")
  expect_true(a)
  setwd(curr_dir)

})
