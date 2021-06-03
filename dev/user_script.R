library(config)
library(readr)

getwd()

source("R/code_gen.R")

#reticulate::configure_environment(pkgname)


Sys.setenv(R_CONFIG_ACTIVE = "dev")
params <- config::get(file = "inst/cheetah/bs4dash/bs4_config.yml" , use_parent = TRUE )

create_app_r(params , template_file = "inst/cheetah/bs4dash/bs4dash_template.c3" ,
             intermediate = FALSE , target_file =  "play_app.R" )


## Trial
Sys.setenv(R_CONFIG_ACTIVE = "dev")
params <- config::get(file = "dev/trial.yml" , use_parent = TRUE )


create_app_r(params , template_file = "dev/trial.c3" ,
             intermediate = TRUE , target_file = "trial.txt")



## ymlon
Sys.setenv(R_CONFIG_ACTIVE = "dev")
params <- config::get(file = "dev/trial.yml" , use_parent = TRUE )

yon <- ymlon$new(params)

yon$print()

####
library(stringr)
Sys.setenv(R_CONFIG_ACTIVE = "dev")
params <- config::get(file = "dev/trial.yml" , use_parent = TRUE )


v <- names(params)

params$obj.count

for(i in 1:params$obj.count){
  tag <- paste0("obj." , i , ".name")
  params[tag]
}








