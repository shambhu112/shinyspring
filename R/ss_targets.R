#' ease of use method for initializing shinyspring in a target
#'
#' @param config_file the config.yml for shinyspring application.
#' @return master list with controller , registry and ds_names
#' @examples
#' # include the following 2 targets in your _targets.R file
#` tar_target(config_file , "config.yml", format = "file")
#` tar_target(master , tar_shinyspring(config_file))
#' @export
tar_shinyspring <- function(config_file){

    params <- config::get(file = config_file)
    controller <- app_master$new(params)
    controller$preload_master_with_config()
    r <- shinyspring::mod_registry$new(params)
    dnames <-  names(controller$ds_config)

    master <- list(control = controller ,  registry = r , ds_names = dnames)
    return(master)
}
