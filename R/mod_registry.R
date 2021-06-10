#' R6  class for Modules Management for the shinyspring app
#'
#' @description
#' mod_registry is the call you cn
#'
#' @name mod_registry
#' @importFrom R6 R6Class
#' @export
mod_registry <- R6::R6Class(
  "mod_registry",

  public = list(
    #' @field mod_names initialization parameters
    mod_names = NULL,
    #' @field master_params initialization parameters
    master_params = NULL,
    #' @field mod_params initialization parameters
    mod_params = NULL,
    #' @field registry the registry object
    registry = NULL,

    #' @description Standard R6 Initialize function
    #'
    #' @param params the config yml driven params for initialization
    #' @return  a new `mod_registry` object
    initialize = function(params) {
      r <- stringr::str_detect(names(params), "\\D[.]\\D")
      l <- names(params[which(r)])
      sp <- stringr::str_split(string = l, pattern = "[.]")
      #  all_mods <- sapply(sp, function(x) {
      #    unlist(x)[1]
      #  })
      # all_mods <- unique(all_mods)

      # Using only mods that have mod_name as a property
      registry_mods <- sapply(sp, function(x){
        pvalue <- x[2]
        pname <- x[1]
        ret <- NULL
        if(pvalue == "mod_name")
          ret <- pname
      })

      registry_mods <- unlist(unique(registry_mods))
      registry_filename <- system.file("mod_registry/mod_registry.csv" , package = "shinyspring")
      r <- suppressMessages(readr::read_csv(registry_filename))
      cli::cli_alert_success("Registry Loaded")
      mparams <- masterparams_to_mod_params(master_params = params ,
                                            registry_df = r  ,
                                            mod_names = registry_mods )

      self$registry <- r
      self$mod_names <- registry_mods
      self$master_params <- params
      self$mod_params <- mparams
    },


    #' get mod names from config files
    #' @return characted list of mod_names
    mods_names = function() {
      self$mod_names
    },

    #TODO fix this to be cached .
    #' get sub params for a given mod_name
    #' @param mod_name the mod_name
    #' @return list ofparams
    params_for_mod = function(mod_name) {
      index <-which(names(self$mod_params) == mod_name)
      self$mod_params[[index]]
    },

    #' @description to implement
    validate_params = function(){

    },

    #' @description prints the mod properties and default values
    #' @param mod_ref the mod_ref name : eg: rmd_mod
    mod_definition = function(mod_ref){
      #TODO: move this to registry as a function for mod definitions
      registry_filename <- system.file("mod_registry/mod_registry.csv" , package = "shinyspring")
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
    },


    #' @description Prints this object
    print = function() {
      cli::cli_h3("Mod Names")
      ulid <- cli::cli_ul()

      for(x in 1:length(self$mod_names)){
        ps <- self$params_for_mod(self$mod_names[x])
        cli::cli_li("  {self$mod_names[x]} > {ps}")
      }

      cli::cli_end(ulid)
      invisible(self)
    }
  ))


params_base_minimum_check <- function(mods , reg){
  #check for mandatory functions

}

check_tab_menu_to_mod_names <- function (reg){

}
