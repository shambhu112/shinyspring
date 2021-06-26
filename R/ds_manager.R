is.defined = function(x)!is.null(x)


#' Loads a Row based on file type
#' @param name the name of dataset
#' @param ds_params the params specific to the ds
#' @param controller app_master
#' @return row a Row object
#' @export
load_row <- function(name , ds_params , controller){
  type <- ds_params$type
  the_ds <- NULL
  if(identical(type ,"csv")) the_ds <- csv_file(name , ds_params , controller)
  if(identical(type ,"xls")) the_ds <- xls_file(name , ds_params , controller)
  if(identical(type , "csv_dir")) the_ds <- csv_dir(name , ds_params , controller)
  if(identical(type , "rds")) the_ds <- rds_file(name , ds_params , controller)
  if(identical(type , "arrow")) the_ds <- arrow_file(name , ds_params , controller)
  if(identical(type , "feather"))the_ds <- feather_file(name , ds_params , controller)
  if(identical(type , "built_in")) the_ds <- built_in_file(name , ds_params , controller)
  if(identical(type , "custom")) the_ds <- custom_file(name , ds_params , controller)

  if(is.null(the_ds))  cli::cli_alert_danger("Error : Dataset load for type {type} not implemented or previous call returned null")

  size <- nrow(controller$master_data)
  row <- new_row(sr_num = size +1 , ds = the_ds , ds_name = name , ds_params = ds_params)
  row

}

#' Fetch ds params from config
#' @param controller  the  app_master
#' @param ds_name the name of DS
ds_parameters <- function(controller , ds_name){
  ds_params <- controller$ds_config[[ds_name]]
}

ds_validate_and_prep2 <- function(ds , ds_info){

  '%notin%' <- Negate('%in%')

  data_colnames <- colnames(ds)
  dic_colnames <- ds_info$data_colname
  ## DQ Check 1 : check column names match
  x <- list(dictionary = dic_colnames , data = data_colnames)
  # ggVennDiagram::ggVennDiagram(x)
  inter <- intersect(dic_colnames , data_colnames)
  dic_only <-  dic_colnames[dic_colnames %notin%  inter]
  data_only <-  data_colnames[data_colnames %notin%  inter]

  if(length(dic_only) >0 ){
    cli::cli_alert_warning("Columns found in dictionary but not in data {dic_only}")
  } else if(length(data_only) >0){
    cli::cli_alert_warning("Columns found in data but not in dictionary {data_only}")
  } else {
    cli::cli_alert_success(" Columns Names match in data and dictionary  ")
  }


  ###  DQ Check 2: pull data ignoring cols marked as ignore ----

  data <- ds
  ignore_cols <- which(as.logical(ds_info$drop_col))
  if(length(ignore_cols) > 0){
    data <- data[-c(ignore_cols)]
  }
  cli::cli_alert_success(" column count {length(ignore_cols)} : {ignore_cols} dropped from dataset")

  ###  DQ Check 3: Rename Cols ----
  # Note: this is naem based look at each col name level
  new_names <- sapply(colnames(data), function(x){
    new_name <- ds_info[ds_info$data_colname == x,]$newcol_name
    if(is_valid_str(new_name))
      return(new_name)
    else
      return(x)
  })

  colnames(data) <- new_names


  ### DQ Check 3 change type ----
  for(x in colnames(data)){
    type <- ds_info[ds_info$newcol_name == x,]$type
    if(is_valid_str(type)){
      cli::cli_alert_info(" Change Type: Colname {x} new type  {type}")

      index <- which(colnames(data) == x)
      v <-    switch (type,
                      "numeric" =  as.numeric(data[,index]),
                      "factor" =  as.factor(data[,index]),
                      "date_mdy" =  lubridate::mdy(data[,index]),
                      "date_dmy" =  lubridate::dmy(data[,index])
      )

      data[,index] <- v
    }
  }

  ### DQ Check 5 na_threshhold ----

  cnames <- colnames(data)

  for(x in cnames){
    v <- ds_info[ds_info$newcol_name == x,]$na_threshhold
    if(is_valid_str(v)){
      v <- as.numeric(v)
      index <- which(colnames(data) == x)
      na_count <- sum(is.na(data[,index]))
      row_count <- nrow(data)
      per <- na_count/row_count
      if(per > v){
        cli::cli_alert_danger(" NA count for column{x} is above threshold. Expected at {v} , Current at {per}")
      }
    }
  }



  ### DQ Check 6 DQ Rules  ----

  return(data)

}

read_ds_info_csv <- function(csv_file){
  csv <- readr::read_csv(csv_file)
  return(csv)
}

read_ds_info_excel <- function(xls_file){
  xl <- readxl::read_xls(xls_file())
  return(xl)
}

csv_file <- function(name , ds_params , controller){
  ds <- vroom::vroom(ds_params$connection)
  if(is.defined(ds_params$subset)){
    ds <- dplyr::sample_n(ds , as.integer(ds_params$subset))
  }
  cli::cli_alert_success(" csv ds {name} loaded ")
  ds
}


xls_file <- function(name , ds_params , controller){
  ds <- readxl::read_excel(ds_params$connection )
  if(is.defined(ds_params$subset)){
    ds <- dplyr::sample_n(ds , as.integer(ds_params$subset))
  }
  cli::cli_alert_success(" xls ds {name} loaded ")
  ds
}

csv_dir <- function(name , ds_params , controller){
  cli::cli_alert_danger(" csv_dir is  not implemented ds :{name} ")
}

rds_file <- function(name , ds_params , controller){
  ds <- readr::read_rds(ds_params$connection)
  if(is.defined(ds_params$subset)){
    ds <- dplyr::sample_n(ds , as.integer(ds_params$subset))
  }
  cli::cli_alert_success(" rds ds {name} loaded ")
  ds
}


arrow_file <- function(name , ds_params , controller){
  arrow::read_arrow(ds_params$connection) #TODO : check if we can load arrow subset in arrow api
  if(is.defined(ds_params$subset)){
    ds <- dplyr::sample_n(ds , as.integer(ds_params$subset))
  }

  cli::cli_alert_success(" arrow ds {name} loaded ")
  ds

}

feather_file <-  function(name , ds_params , controller){
  ds <- arrow::read_feather(ds_params$connection) #TODO : check if we can load arrow subset in arrow api

  if(is.defined(ds_params$subset)){
    ds <- dplyr::sample_n(ds , as.integer(ds_params$subset))
  }
  cli::cli_alert_success(" feather ds {name} loaded ")
  ds
}


built_in_file <- function(name , ds_params , controller){
  ds <- load_built_ts_as_tibble(ds_name = ds_params$connection)
  if(is.defined(ds_params$subset)){
    ds <- dplyr::sample_n(ds , as.integer(ds_params$subset))
  }
  cli::cli_alert_success(" built_in ds {name} loaded ")
  ds
}

custom_file <- function(name , ds_params , controller){
  ds <- eval(parse(text = ds_params$connection))

  if(is.defined(ds_params$subset)){
    ds <- dplyr::sample_n(ds , as.integer(ds_params$subset))
  }
  cli::cli_alert_success(" Custom ds {name} loaded ")
  ds_params$connection <- "removed to save memory"
  ds

}
