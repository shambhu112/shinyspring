library(testthat)

run_checks <- function(params){
  minimum_checks
}


minimum_checks <- function(params){
  expect_equal("bs4_dash" ,   params$dashboard_template)
  expect_match(params$template_file , "bs4/bs4_standard.mst")
  expect_true(!is.null(params$code_gen_location))
  expect_true(!is.null(params$dummy_test.mod_name))
  expect_true(!is.null(params$dummy_test.weird_param))

  #Config file test
  expect_true(!is.null(params$sweetmod_config))

  expect_true(!is.null(params$preload_dataset))
  expect_true(!is.null(params$source_file_onstartup))
}
