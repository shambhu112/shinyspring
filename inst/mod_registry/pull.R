  library(googlesheets4)
  url <- "https://docs.google.com/spreadsheets/d/15HXspcKqGyDYAM1Jfa7SFjCALHMWTPyTbjrXnWuHY2I/"
  r <- read_sheet(url)

  r$value <- as.character(r$value)
  readr::write_csv(r , "mod_registry.csv"  )
