library(shinyspring)
library(testthat)

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

