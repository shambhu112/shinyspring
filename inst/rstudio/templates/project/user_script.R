## Start your Shiny Spring Journey here

## Step 1 : Make sure that your properties in config.yml are set as per your needs
file.edit('{{config_file}}')

## Step 2 : Create app.R for your application
params <- config::get(file = "{{config_file}}") # load params
shinyspring::create_shinyapp(params = params )

## Step 3 : Launch the App
shiny::runApp()
