#'---
#' output: github_document
#'---

#+ message=FALSE
library(here)
library(tidyverse)

#' # Import and Export files

#' ### Pasting data from clipboard
#' As data frame
clipr::read_clip_tbl() # imports current clipboard as data frame

read.table(file = "clipboard",  # specify this as "clipboard"
           sep = "t",           # separator could be tab, or commas, etc.
           header=TRUE)         # if there is a header row

#' As character vector
clipr::read_clip()

#' ### APIs
# load packages
pacman::p_load(httr, jsonlite, tidyverse)

# prepare the request
path <- "http://api.ratings.food.gov.uk/Establishments"
request <- GET(url = path,
               query = list(
                       localAuthorityId = 188,
                       BusinessTypeId = 7844,
                       pageNumber = 1,
                       pageSize = 5000),
               add_headers("x-api-version" = "2"))

# check for any server error ("200" is good!)
request$status_code

# submit the request, parse the response, and convert to a data frame
content(request, as = "text", encoding = "UTF-8") %>%
        fromJSON(flatten = TRUE) %>%
        pluck("establishments") %>%
        tibble()

# rmarkdown::render()










