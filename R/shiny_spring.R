create_module_dependencies <- function(mod_name , package = "sweetmods"){

}

#' Checks if the config file is good to go
#' Note : this runs a bunch of testthat tests
#' @param params all params
#' @export
test_config_file <- function(params){
  run_checks(params)
}



#' Create _targets file based on shinyspring approach
#'
#' @param  params the params
#' @param filename (optional) defaults to _targets.R
#' @param  overwrite existing _targets.R file is already present. (optional) defaults to FALSE
#' @export
create_targets <- function(params , filename = "_targets.R" , overwrite = FALSE ){

  tar_template <- readr::read_file(system.file("rstudio/templates/project/ss_targets.mst"  , package = "shinyspring"))
  dots <- params
  tar_text <- whisker::whisker.render(tar_template , dots)

  if(file.exists(filename)){
    cli::cli_alert_warning("{filename} already exists. Overwrite (yes)? or create a sample .txt file (no)? ")

    overwrite <- confirm_boolean_interactive()

    if(overwrite){
      writeLines(tar_text, con = file.path(filename))
      cli::cli_alert_success("Targets File Overwritten : {filename} ")
    }else{
      writeLines(tar_text, con = file.path("ss_targets_sample.txt"))
      cli::cli_alert_success("Example Targets File created : ss_targets_sample.txt ")
      cli::cli_h3(" Cut and Paste targets from ss_targets_sample.txt into the _target.R ")
    }

  }else{
    writeLines(tar_text, con = file.path(filename))
    cli::cli_alert_success("{filename} created. :) ")
  }

  cli::cli_div(theme = list(span.emph = list(color = "orange")))
  cli::cli_text("Please run {.emph tar_make()} and test if target works")
  cli::cli_end()

}


#' Create a baseline Module for your shinyapp
#'
#' @param mod_name The Modules Name
#' @export
create_module <- function(mod_name){
  mod_template <- readr::read_file(system.file("rstudio/templates/project/new_module.mst"  , package = "shinyspring"))
  dots <- list(mod_name = mod_name )
  module_text <- whisker::whisker.render(mod_template , dots)
  mod_file <- paste0(mod_name ,  ".R")
  writeLines(module_text, con = file.path(mod_file))
  cli::cli_alert_success("Created module  : {mod_file} ")
}


#' CLI option to create a new Shiny Spring Project based on predefined templates in shinyspring
#' The New Project wizard in RStudio also call this method
#'
#' @param dashboard_template (optional) defaults to "bs4_dash". Options are shiny_dashboard_plus , argon_dash
#' @param app_type (optional) default to "basic". Options are
#' @param config_file (optional) default to config.yml
#' @param startup_file (optional) the on_startup file name
#' @param targets optionally create _targets.R
#' @export

create_new_project <- function(dashboard_template = "bs4_dash" , app_type = "standard" , config_file = "config.yml" ,
                               startup_file = "on_startup.R" , targets = FALSE){
  dots <- list(dashboard_template = dashboard_template , app_type = app_type ,
               config_file = config_file , startup_file = startup_file)

  yml_file <- create_file_txt(dots , type = "yml" )
  user_script <- create_file_txt(dots , type = "template" )

  start_file_template <- readr::read_file(system.file("rstudio/templates/project/on_startup.mst"  , package = "shinyspring"))
  start_script <- whisker::whisker.render(start_file_template , dots)


  writeLines(yml_file, con = file.path(dots$config_file))
  cli::cli_alert_success("Created config at file : {dots$config_file} ")

  writeLines(user_script, con = file.path("user_script.R"))
  cli::cli_alert_success("Created start script : user_script.R ")

  writeLines(start_script, con = file.path(startup_file))
  cli::cli_alert_success("Created on_startup file : {startup_file} ")

  if(targets){
    create_targets(dots)
  }

  cli::cli_h2("Open user_script.R to start your shiny spring journey")

}


#' Creates the app.R using the templates defined in inst/cheetah/*
#'
#' Based on the configuration defined in config.yml the app.R code is created
#' @param params the params for creating app.R
#' @param target_file (optional) default is app.R , you can change this
#' @param template_file (optiona) this is an override.Function expect that you params$template_file is set in params when template_file is NULL
#' @export

create_shinyapp <- function(params , target_file = "app.R" ,template_file = NULL){
  if(is.null(template_file))
    template_file <- params$template_file


  template <- readr::read_file(file= template_file)
  text <- whisker::whisker.render(template, params)
  app_r <- paste(params$code_gen_location , target_file , sep = "/")
  conn <- file(app_r)
  writeLines(text, conn)
  close(conn)
}


# to be used in RStudio "new project" GUI
new_project <- function(path, ...) {
  # ensure path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  dots <- list(...)

  template <- dots$dashboard_template
  app_type <- dots$app_type


  create_new_project(dashboard_template = dots$dashboard_template ,
                     app_type = dots$app_type ,
                     config_file =  dots$config_file)

  #yml_file <- create_file_txt(dots , type = "yml")
  #user_script <- create_file_txt(dots , type = "template")

  #start_file_template <- readr::read_file(system.file("rstudio/templates/project/on_startup.mst"  , package = "shinyspring"))
  #start_script <- whisker::whisker.render(start_file_template , dots)


  #writeLines(yml_file, con = file.path(path , dots$config_file))
  #cli::cli_alert_success("Created config at file : {dots$config_file} ")

  #writeLines(user_script, con = file.path(path , "user_script.R"))
  #cli::cli_alert_success("Created start script : user_script.R ")

  #startup_file <- "on_startup.R"
  #writeLines(start_script, con = file.path(startup_file))
  #cli::cli_alert_success("Created on_startup file : {startup_file} ")

  #cli::cli_h2("Open user_script.R to start your shiny spring journey")

}


create_file_txt <- function(dots , type ){
  if(type == "yml"){
    yml_template_file <- create_mst_filename(dots , type = "yml" )
    yml_template <- readr::read_file(yml_template_file)

    text <- whisker::whisker.render(yml_template, dots)
    ret <- text
  }else{
    user_file_template <- readr::read_file(system.file("rstudio/templates/project/user_script.mst"  , package = "shinyspring"))
    user_script <- whisker::whisker.render(user_file_template , dots)
    ret <- user_script
  }
  ret
}


create_mst_filename <- function(dots , type ){
  x <- dots$dashboard_template
  t_name <- dplyr::case_when(
    x == "bs4_dash" ~ "bs4_" ,
    TRUE ~ "plc_"
  )
  x <- dots$app_type
  a_type <- dplyr::case_when(
    x == "minimal" ~ "minimal" ,
    x == "standard" ~ "standard" ,
    x == "full_demo" ~ "full_demo",
    TRUE ~ "minimal"
  )

  x <- dots$dashboard_template
  dir <- dplyr::case_when(
    x == "bs4_dash" ~ "bs4" ,
    TRUE ~ "plc"
  )

  if(type == "yml"){
    str <- paste(t_name , a_type , "_yml" , ".mst" , sep = "")
  }else{
    str <- paste(t_name , a_type ,  ".mst" , sep = "")
  }

  tem <- paste(dir , "/" , str , sep = "")
  ret <- system.file(tem , package = "shinyspring")
  ret
}
