
# shinyspring <a href='https://www.shinyspring.dev'><img src="https://storage.googleapis.com/shiny-pics/spring_logo.png" align="right" height="139"/></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/dplyr)](https://cran.r-project.org/package=dplyr)
[![R build
status](https://github.com/tidyverse/dplyr/workflows/R-CMD-check/badge.svg)](https://github.com/tidyverse/dplyr/actions?workflow=R-CMD-check)
[![Codecov test
coverage](https://codecov.io/gh/tidyverse/dplyr/branch/master/graph/badge.svg)](https://codecov.io/gh/tidyverse/dplyr?branch=master)

<!-- badges: end -->

> Build fast production ready shiny apps.

## Overview

shinyspring provides a development framework , templates and automation
to build
[bs4dash](https://rinterface.github.io/bs4Dash/ "Admin LTE3 based dashboard")
based shinyapps. In collaboration with the
{{[sweetmods](https://github.com/shambhu112/sweetmods "Sweetmods on github")}}package
shinyframework enables you to focus on developing the core insights app
for your usebase leaving all the other needed stuff for building a
complete dashboard to the shinyframework

A lot of peripheral modules related to *user authentication , datasource
management, job scheduling via targets, Data explorations and several
others* can added in a plug and play manner to build a complete robust
shinyapp.

### New Project Creation : **Programmatically**

-   `shinyspring::create_new_project()` creates a new default project

    -   Options include :
        `shinyspring::create_new_project(dashboard_template = "bs4_dash" , app_type = "standard" , config_file = "config.yml"`

    -   *dashboard\_templates* : bs4\_dash (available today) , future
        plans for shiny\_dashboard and semantic\_dashboard

    -   *app\_type* : minimal (bare minimum app) , standard (default) ,
        full\_demo (full app with all sweetmods visible)

## Steps to create a new app

-   Step 1 : Create a new project with Rstudio or in an empty project
    call `shinyspring::create_new_project()` this creates two file
    `config.yml` and `user_script.R`

-   Step 2 : open `user_script.R` and follow instructions . Instructions

    ``` r
    ## Start your Shiny Spring Journey here

    ## Step 1 : Make sure that your properties in config.yml are set as per your needs
    file.edit('config.yml')

    ## Step 2 : Create app.R for your application
    params <- config::get(file = "config.yml") # load params
    shinyspring::create_shinyapp(params = params )
    shinyspring::test_config_file(params)


    ## Step 3 : Launch the App
    shiny::runApp()
    ```

-   Step 4 : After testing the basic app launch you can now create your
    custom module for you application with
    `shinyspring::create_module("my_custom_module")` . Implement the
    module

-   Step 5 : Adjust `config.yml` to add menu’s and leverage pre-built /
    tested [sweetmod](https://github.com/shambhu112/sweetmods)s that can
    be used in your app in a plug and play manner . The power of
    shinyspring is in the reuse of sweetmods.

### New Project Creation in Rstudio

| Screen 1                                                     | Screen 2                                                     |
|--------------------------------------------------------------|--------------------------------------------------------------|
| <img src="man/figures/README-newproject-1.png" width="400"/> | <img src="man/figures/README-newproject-2.png" width="400"/> |

## FAQ’s

-   Why Shinyspring ? What is the value add ?

-   What is the development framework for Shinyspring ?

-   What are current modules available and what are the plans for future
    ?

-   How can I build modules that work with shiynspring ?

-   How can I contribute to shinyspring ?

-   Is Shinyspring robust and production ready ?
