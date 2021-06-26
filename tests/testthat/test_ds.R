source("test_init.R")



test_that("test ds params" , {
    master <- app_master$new(params = params)
    master$preload_master_with_config()
    p <- ds_parameters(master$ds_config , "mexico_2")

})

test_that("test custom load row ", {
    master <- app_master$new(params = params)
    master$preload_master_with_config()
    ds_names <- master$dataset_names()

    # Custom Load test
    expect_true("mexico_2" %in% ds_names)

    p <- ds_parameters(master , "mexico_2")

    # Row test
    row <- load_row("mexico_2" , ds_params = p , master )
    expect_true("data.frame" %in% class(row$datasets))


})

test_that("test ds_validation" , {
    master <- app_master$new(params = params)
    master$preload_master_with_config()
    v <- master$ds_validate_and_prep()
    expect_true(v)

    m3 <- master$dataset_by_name("mexico_2")
    expect_true("y98" %in% colnames(m3))
    expect_true(is.numeric(m3$y98))

})
