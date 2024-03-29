#' R6 master class (Controller) for your shiny application.
#'
#' @description
#' app_master is the master class used across all modules of the the shiny app. It Stores all datasets needed in the applications
#' as tibbles. All datasets meta information is also stored in this object
#'
#' @name app_master
#' @import shiny
#' @importFrom R6 R6Class
#' @export
app_master <- R6::R6Class(
  "app_master",
  public = list(
    #' @field params initialization parameters
    params = NA,
    #' @field reactive_vals reactiveValues instance that stores all reactive values needed in app
    reactive_vals = NULL ,

    #' @field master_data static values, non-reactive static datasets needed in the application. Note you can pre-load these
    master_data = NULL ,

    #' @field  ds_config configuration extracted from master config
    ds_config = NULL ,

    #' @field dq_master Stores Data Quality Information for each dataset
    dq_master = NULL ,

    #' @description Standard R6 Initialize function
    #'
    #' @param params the config yml driven params for initialization
    #' @return  a new `app_master` object
    initialize = function(params) {
      cli::cli_alert_info("Object app_master initialized")
      self$params <- params
      options("scipen" = 100, "digits" = 4)
      self$master_data <- tibble::tibble(srnum = numeric() , connection_str = character() , dataset_names =  character() ,
                                         datasets  = tibble::tibble() , original_cols = list() , pretty_cols = list() , connection_type = character())

      self$load_ds_config(params)
      self$reactive_vals <- shiny::reactiveValues()
    },

    #' @description Gets SmartEDA::ExpData(type = 1) dataframe in lazy maner
    #'
    #' @param ds_name the ds_name
    #' @param max_rows if max_rows > nrow of ds than a random max_rows are selected else nrow is used.
    #'        default is Inf for all rows
    #' @return  a new `app_master` object
    get_dq_summary = function(ds_name , max_rows = Inf){
      the_row <- lazy_update_dq_row(ds_name , self , max_rows)
      ret <-as.data.frame(the_row$dq_summary$data)
    },

    #' @description Gets SmartEDA::ExpData(type = 2) dataframe in lazy manner
    #' @param max_rows if max_rows > nrow of ds than a random max_rows are selected else nrow is used.
    #'        default is Inf for all rows
    #' @param ds_name the ds_name
    #' @return  a new `app_master` object
    get_dq_detail = function(ds_name , max_rows = Inf){
      the_row <- lazy_update_dq_row(ds_name , self , max_rows)
      ret <-as.data.frame(the_row$dq_detail$data)
    },

    #' Add a row to app_master `
    #'
    #' @param row  new row object created with create_row
    add_master_data_row = function(row){
      self$master_data <- dplyr::bind_rows(self$master_data , row)
    },

    #' removes the indexed row from app_master `
    #' Note: the indexes are reindexed from 1 to nrow(master_data) after removal
    #' @param index the rowindex
    remove_dataset = function(index){
      self$master_data <- self$master_data[-index,]
      self$master_data$srnum <- seq(1:nrow(self$master_data))
      #TODO - remove the dq also
    },

    #' replaces dataset with new row at the same index
    #' @param dataset_name the ds_name
    #' @param replace_with the row created with create_row
    replace_dataset_by_name = function(dataset_name , replace_with){
      index <- which(self$master_data$dataset_names == dataset_name)
      stopifnot(length(index) == 1) #TODO : Clean handling needed here , message
      self$master_data$datasets[index,] <- tidyr::nest(replace_with , data =  dplyr::everything())
    },
    #' load dataset config in a consumable fashion
    #' @param params the params
    load_ds_config = function(params){
      #     index <- which(stringr::str_detect(names(params) , pattern = "ds.\\D"))
      index <- which(stringr::str_detect(names(params) , pattern = "^ds."))

      if(length(index) == 0 ) return(NULL)

      prop <- names(params)[index]

      t <- stringr::str_split(prop , pattern = "[.]")

      ds_names <- sapply(1:length(t), function(x){
        t[[x]][[2]]
      })
      ds_names <- unique(ds_names)

      ds_params <- sapply(ds_names, function(x){
        pat <- paste0("ds." , x , ".\\D")
        sindex <- which(stringr::str_detect(names(params) , pattern = pat ))
        sub_config <- params[sindex]
        sub_ds_props <- sapply(names(sub_config), function(x2){
          p <- stringr::str_split(x2 , pattern = "[.]")
          param_nm <- p[[1]][3]
        })
        sub_ds_props <- as.list(sub_ds_props)
        names(sub_config) <- sub_ds_props
        sub_config
      })


      if("matrix" %in% class(ds_params)){
        ds_params <- as.list(as.data.frame(ds_params))
      }

      self$ds_config <- ds_params
    },

    #' Preload app_master with csv files provided in config `
    #'
    #' Note this creates new mdata overiding rvals
    #' @return self object
    preload_master_with_config = function(){
      config <- self$ds_config

      # TODO  : consider parallel options here
      for(x in names(config)){
        ds_nm <- x
        ds_params <- config[[ds_nm]]
        row <- load_row(name = ds_nm, ds_params = ds_params , controller = self)
        self$add_master_data_row(row)
      }
      invisible(self)
    },


    #' access dataset names as list
    #' @return the names of datasets
    dataset_names = function(){
      self$master_data$dataset_names
    },

    #' search for a tibble based on dataset_name
    #' @param dataset_name the name of the dataset to lookup
    #' @param max_rows (optional) if max_rows is set then sample max_rows from dataset.
    #' @return the mapped dataset in tibble format
    dataset_by_name = function(dataset_name , max_rows = Inf){
      index <- which(self$master_data$dataset_names == dataset_name)
      stopifnot(length(index) == 1) #TODO : Clean handling needed here , message
      ret <- as.data.frame(self$master_data$datasets[index,]$data)
      v <- as.numeric(max_rows)
      if(length(v) > 0 && (v < nrow(ret)) ){
        ret <- dplyr::sample_n(ret , size = max_rows )
      }
      ret
    },

    #' search for a tibble based on index in mdata
    #' @param  index the row index of the dataset
    #' @return the mapped dataset in tibble format
    data_by_index = function(index){
      self$master_data$datasets[[index]]
    },

    #' get colnames for a dataset
    #' @param dataset_name the name of the dataset to lookup
    #' @return characted list of colnames
    colnames_for_dataset = function(dataset_name){
      index <- which(self$master_data$dataset_names == dataset_name)
      stopifnot(length(index) == 1) #TODO : Clean handling needed here , message
      ret <- self$master_data$original_cols[index]$cname
      ret
    } ,

    #' Validate Datasets based on rules and prep conduct basic data prep
    #' Typically this method is called from _targets or at Design time when building the app
    #' Not ideal to call this method from shiny app.
    #' Note: validtion is done only if the dataset has the following set in config file
    #' ds_info_type and ds_info_url
    #' supported ds_info_type : google , excel and csv
    #' @return logical FALSE if data validation Warnings or Errors elase TRUE
    ds_validate_and_prep = function(){
      ds_names <- self$dataset_names()
      for(x in 1:length(ds_names)){
        sub_ds <- self$ds_config[ds_names[x]]
        ds_props <- names(sub_ds[[1]])
        if("ds_info_type" %in% ds_props){
          values <- sub_ds[[1]]
          ds <- self$dataset_by_name(ds_names[x])
          ds_info <- switch (values$ds_info_type ,
                             "google" = googlesheets4::read_sheet(values$ds_info_url) ,
                             "csv" = read_ds_info_csv(values$ds_info_url) ,
                             "excel" = read_ds_info_excel(values$ds_info_url)
          )
          new_ds <- ds_validate_and_prep2(ds , ds_info)
          self$replace_dataset_by_name(ds_names[x] , new_ds)
          self$master_data$pretty_cols[x]$pnames <- as.list(ds_info$pretty_name)
          cli::cli_alert_success("dataset {ds_names[x]} replaced in master after prep ")
          return(TRUE)
        }
    }
    },

    #' get pretty colnames  for a dataset
    #' @param dataset_name the name of the dataset to lookup
    #' @return characted list of colnames
    prettynames_for_dataset = function(dataset_name){
      index <- which(self$master_data$dataset_names == dataset_name)
      stopifnot(length(index) == 1) #TODO : Clean handling needed here , message
      ret <- self$master_data$pretty_cols[index]$pnames
      ret
    }
  )
)
