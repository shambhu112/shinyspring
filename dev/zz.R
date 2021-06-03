Sys.setenv(RETICULATE_PYTHON = "venv/bin/python")
reticulate::py_config()
system("cheetah test")
