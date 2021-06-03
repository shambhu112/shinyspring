library(whisker)

## Trial
Sys.setenv(R_CONFIG_ACTIVE = "dev")

params <- config::get(file = "dev/trial.yml" , use_parent = TRUE )

template <- readr::read_file(file= "dev/trial.whisker")

text <- whisker.render(template, params)
cli::cli_alert_info(text)

#conn <- file("dev/bs4.R")
#writeLines(text, conn)
#close(conn)



params <- config::get(file = "dev/whisker.yml" , use_parent = TRUE )

template <- readr::read_file(file= "dev/bs4.whisker")

text <- whisker.render(template, params)

cli::cli_verbatim(text)


conn <- file("dev/bs4.R")
writeLines(text, conn)
close(conn)
