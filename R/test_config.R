#library(testthat)

#' Run Config File Check
#'
#' @param params the master params from config
#' @import testthat
run_checks <- function(params){
  testthat::test_that("minimum_checks" , {minimum_checks(params)})
  testthat::test_that("menu_mod_check" , {menu_mod_check(params)})

}

#' @description prints the mod properties and default values
#' @param mod_ref the mod_ref name : eg: rmd_mod
mod_definition <- function(mod_ref){

  registry_filename <- system.file("mod_registry/mod_registry.csv" , package = "shinyspring")

  #TODO : this is done to circumvent a note in CRAN check. find better way
  mod_name <- "rmd_mod"
  category <- "package_defined"

  r <- suppressMessages(readr::read_csv(registry_filename))

  r <- dplyr::filter(r , (mod_name == mod_ref) & (category != "package_defined"))
  cli::cli_div(theme = list(span.emph = list(color = "orange")))
  cli::cli_h3("Note: {.emph properties needed and optional} for {mod_ref}")
  cli::cli_end()
  ulid <- cli::cli_ul()
  for(x in 1:nrow(r)){
    cli::cli_li("   {r$property[x]} : ({r$category[x]}) : Default = {r$value[x]}")
  }
  cli::cli_end(ulid)
}



#' Minimum chekcsc
#'
#' @param params the master params from config
#' @import testthat
minimum_checks <- function(params){
  expect_equal("bs4_dash" ,   params$dashboard_template , label = "dashboard_template: [bs4dash] is only supported today: ")
  expect_match(params$template_file , "bs4/bs4_standard.mst")
  expect_true(!is.null(params$code_gen_location) , label = "[code_gen_location] is needed")
  expect_true(!is.null(params$dummy_test.mod_name) , label = "dummy_test.mod_name is needed. Suggest to create the config file")
  expect_true(!is.null(params$dummy_test.weird_param ) , label = "dummy_test.weird_param needed.Re-create config file")

  expect_true(!is.null(params$sweetmod_config))
  expect_true(!is.null(params$preload_dataset))
  expect_true(!is.null(params$source_file_onstartup))

  # Test ds
  index <- which(stringr::str_detect(names(params) , pattern = "^ds."))
  expect_gt(length(index) , 1 , label = "At least 1 dataset with ds.xxx is needed")

  types <- which(stringr::str_detect(names(params)[index] , pattern = ".type$"))
  connections <-  which(stringr::str_detect(names(params)[index] , pattern = ".connection$"))

  expect_gt(length(types) , 0 , label = "Each  [ds] needs to have a [type] eg: ds.type: csv ")
  expect_gt(length(connections) , 0 , label = "Each [ds] needs to have a [connection] eg: ds.connection: ~/data/a.csv")
  expect_equal(length(types) , length(connections) , label = "Each [ds] needs a [type] and [connection]")


}


#' Check menus
#'
#' @param params the master params from config
#' @import testthat
menu_mod_check <- function(params){
  r <- mod_registry$new(params)

  menu_count <- length(params$menus)
  menumods  <-sapply(1:menu_count, function(x){
    smenu <- params$menus[[x]]$sub_menu
    mod_names_for_menus <- params$menus[[x]]$name
    if(is.null(smenu)){
      expect_true(!is.null(params$menus[[x]]$title))
      expect_true(!is.null(params$menus[[x]]$name))
    }else{
      expect_true(is.null(params$menus[[x]]$name) , label = "for parent_menu you do not need [name] ")
      expect_true(params$menus[[x]]$parent_menu , label = "[parent_menu] is needed for menus with sub_menus")
      smenu_count <- length(smenu)
      mod_names_for_menus <- sapply(1:smenu_count, function(i){
        expect_true(!is.null(params$menus[[x]]$sub_menu[[i]]$submenu_title) , "[submenu_title] is needed")
        if(i == 1) expect_true(params$menus[[x]]$sub_menu[[i]]$first , "[first] is needed for first element in sub_menu")
        if(i == smenu_count) expect_true(params$menus[[x]]$sub_menu[[i]]$last_submenu , "[last_submenu] is needed for last element in sub_menu")
        sub_menu_name <- params$menus[[x]]$sub_menu[[i]]$submenu_name
        sub_menu_name
      })
    }
    mod_names_for_menus
  })

  menumods <- unlist(menumods)
  sapply(menumods, function(x){
    p <- r$params_for_mod(x)
    expect_gt(length(p) ,3)
  })


}
