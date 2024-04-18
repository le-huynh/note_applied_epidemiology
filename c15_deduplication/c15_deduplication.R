#'---
#' title: Grouping Data
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export
        here,           # locate files 
        tidyverse,      # data management and visualization
        janitor,        # function for reviewing duplicates
        stringr      # for string searches, can be used in "rolling-up" values
)

#' ### Create dataframe
(obs <- data.frame(
        recordID  = c(1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18),
        personID  = c(1,1,2,2,3,2,4,5,6,7,2,1,3,3,4,5,5,7,8),
        name      = c("adam", "adam", "amrish", "amrish", "mariah", "amrish",
                      "nikhil", "brian", "smita", "raquel", "amrish", "adam",
                      "mariah", "mariah", "nikhil", "brian", "brian", "raquel",
                      "natalie"),
        date      = c("1/1/2020", "1/1/2020", "2/1/2020", "2/1/2020",
                      "5/1/2020", "5/1/2020", "5/1/2020", "5/1/2020",
                      "5/1/2020","5/1/2020", "2/1/2020", "5/1/2020",
                      "6/1/2020", "6/1/2020", "6/1/2020", "6/1/2020",
                      "7/1/2020", "7/1/2020", "7/1/2020"),
        time      = c("09:00", "09:00", "14:20", "14:20", "12:00", "16:10",
                      "13:01", "15:20", "14:20", "12:30", "10:24", "09:40",
                      "07:25", "08:32", "15:36", "15:31", "07:59", "11:13",
                      "17:12"),
        encounter = c(1,1,1,1,1,3,1,1,1,1,2,2,2,3,2,2,3,2,1),
        purpose   = c("contact", "contact", "contact", "contact", "case",
                      "case", "contact", "contact", "contact", "contact",
                      "contact", "case", "contact", "contact", "contact",
                      "contact", "case", "contact", "case"),
        symptoms_ever = c(NA, NA, "No", "No", "No", "Yes", "Yes", "No",
                          "Yes", NA, "Yes", "No", "No", "No", "Yes", "Yes",
                          "No","No", "No")) %>% 
        mutate(date = as.Date(date, format = "%d/%m/%Y")))

obs %>% janitor::tabyl(name, purpose)

#' ### De-duplication
#' `janitor::get_dupes()`
# default: 100% duplicates
obs %>% janitor::get_dupes()

# ignore column recordID, wrap in c() if multiple columns
obs %>% janitor::get_dupes(-recordID)

# duplicates based on name and purpose columns ONLY
obs %>% janitor::get_dupes(name, purpose)

#' keep only unique rows
obs %>% dplyr::distinct(across(-recordID),
                        .keep_all = TRUE)

#' deduplicate based on specific columns
obs %>% distinct(name, purpose) %>%
        arrange(name)

obs %>% distinct(name, purpose, .keep_all = TRUE) %>%
        arrange(name)

#' deduplicate elements in vector
(x <- c(1, 1, 2, NA, NA, 4, 5, 4, 4, 1, 2))

base::duplicated(x)

# return only duplicated elements
x[duplicated(x)]

# return only unique elements
x[!duplicated(x)]

base::unique(x)

# remove NAs
unique(na.omit(x))

#' ### Slicing
obs %>% dplyr::slice(c(4, 7))

obs %>% dplyr::slice(-c(4, 7))

obs %>% dplyr::slice(c(4:7))

# return rows with the largest encounter number
obs %>% slice_max(encounter, n = 1)

# keep only the latest encounter per person
obs %>% group_by(name) %>%
        slice_max(date, # keep row per group with maximum date value 
                  n = 1, # keep only the single highest row 
                  with_ties = F) # if there's a tie (of date), take the first row

# Example of multiple slice statements to "break ties"
obs %>% group_by(name) %>%
        # FIRST - slice by latest date
        slice_max(date, n = 1, with_ties = TRUE) %>% 
        # SECOND - if there is a tie, select row with latest time; ties prohibited
        slice_max(lubridate::hm(time), n = 1, with_ties = FALSE)

# 1. Define data frame of rows to keep for analysis
(obs_keep <- obs %>%
        group_by(name) %>%
        # keep only latest encounter per person
        slice_max(encounter, n = 1, with_ties = FALSE))


# 2. Mark original data frame
(obs_marked <- obs %>%
        # make new dup_record column
        mutate(dup_record = case_when(
                # if record is in obs_keep data frame
                recordID %in% obs_keep$recordID ~ "For analysis", 
                # all else marked as "Ignore" for analysis purposes
                TRUE                            ~ "Ignore")))

#' Calculate row completeness
# create a "key variable completeness" column
# this is a *proportion* of the columns designated as "key_cols" that have non-missing values

key_cols = c("personID", "name", "symptoms_ever")

obs %>% 
        mutate(key_completeness = rowSums(!is.na(.[,key_cols]))/length(key_cols)) 

#' ### Roll-up values
#' Roll-up values into one row
# "Roll-up" values into one row per group (per "personID") 
(cases_rolled <- 
        obs %>% 
        group_by(personID) %>% 
        # order the rows within each group (e.g. by date)
        arrange(date, .by_group = TRUE))

# for each column, paste together all values within the grouped rows, separated by ";"
cases_rolled %>%
        summarise(across(everything(),      # apply to all columns
                         # function is defined which combines non-NA values
                       ~paste0(na.omit(.x),
                               collapse = "; "))) 

# shows unique values only
cases_rolled %>%
        summarise(across(everything(),
                         ~paste0(unique(na.omit(.x)),
                                 collapse = "; ")))


cases_rolled %>%
        summarise(across(everything(),
                         list(roll = ~paste0(na.omit(.x),
                                             collapse = "; "))))

#' Overwrite values
cases_rolled %>%
        summarise(across(everything(),
                         ~paste0(na.omit(.x),
                                 collapse = "; "))) %>%
        # clean Yes-No-Unknown vars: replace text with "highest" value present in the string
        mutate(across(c(contains("symptoms_ever")),                     # operates on specified columns (Y/N/U)
                      list(mod = ~case_when(                                 # adds suffix "_mod" to new cols; implements case_when()
                              
                              str_detect(.x, "Yes")       ~ "Yes",                 # if "Yes" is detected, then cell value converts to yes
                              str_detect(.x, "No")        ~ "No",                  # then, if "No" is detected, then cell value converts to no
                              str_detect(.x, "Unknown")   ~ "Unknown",             # then, if "Unknown" is detected, then cell value converts to Unknown
                              TRUE                        ~ as.character(.x)))),   # then, if anything else if it kept as is
               .keep = "unused")                                             # old columns removed, leaving only _mod columns

#rmarkdown::render()



















