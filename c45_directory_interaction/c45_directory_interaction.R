#'---
#' title: Directory interaction
#' output: github_document
#'---

#+ message=FALSE
library(here)
library(tidyverse)


#' ### List files in directory
#' file name only
base::dir(here("data")) %>% head()

#' file path
base::list.files(here("data")) %>% head()

fs::dir_ls(here("data")) %>% head()

#' all meta info
fs::dir_info(here("data"))

#' ### File information
base::file.info(here("data/20201007linelist.csv"))

fs::file_info(here("data/20201007linelist.csv"))

#' ### Check if exists
#' R object
#base::exists("object_name")

#' directory
base::file.exists(here("data"))

fs::is_dir(here("data"))

#' file
base::file.exists(here("data/20201007linelist.csv"))

fs::is_file(here("data/20201007linelist.csv"))

#' ### Create
#' directory
# existed dir
base::dir.create(here("data"))
# non-existed dir
base::dir.create(here("my_dir"))

fs::dir_create(here("my_dir"))

#' file
base::file.create(here("test.rds"))

fs::file_create(here("test.rds"))

#' ### Delete
# R object
rm()

# directory
fs::dir_delete(here("my_dir"))

# file
fs::file_delete(here("test.rds"))


# rmarkdown::render()





