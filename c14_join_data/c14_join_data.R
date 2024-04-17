#'---
#' title: Grouping Data
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export
        here,           # locate files 
        tidyverse,      # data management and visualisation
        RecordLinkage,  # probabilistic matches
        fastLink        # probabilistic matches)
)

#' ### Import data
data <- rio::import(here("data/linelist_cleaned.rds"))

# subset of data
(data_mini <- data %>% 
        select(case_id, date_onset, hospital) %>%
        head(10))

# hospital information dataframe
(hosp_info <-  data.frame(
        hosp_name     = c("central hospital",
                          "military",
                          "military",
                          "port",
                          "St. Mark's",
                          "ignace",
                          "sisters"),
        catchment_pop = c(1950280,
                          40500,
                          10000,
                          50280,
                          12000,
                          5000,
                          4200),
        level         = c("Tertiary",
                          "Secondary",
                          "Primary",
                          "Secondary",
                          "Secondary",
                          "Primary",
                          "Primary")))

#' ### Pre-cleaning
#' Match hospital names in 2 dataframes
data_mini %>% count(hospital)

hosp_info %>% count(hosp_name)

hosp_info %>% 
        mutate(hosp_name_new = case_when(
                hosp_name == "military" ~ "Military Hospital",
                hosp_name == "port" ~ "Port Hospital",
                hosp_name == "St. Mark's" ~ "St. Mark's Maternity Hospital (SMMH)",
                hosp_name == "central hospital" ~ "Central Hospital",
                TRUE ~ hosp_name)) %>%
        select(hosp_name, hosp_name_new)

(hosp_df <- hosp_info %>% 
        mutate(hosp_name = case_when(
                hosp_name == "military" ~ "Military Hospital",
                hosp_name == "port" ~ "Port Hospital",
                hosp_name == "St. Mark's" ~ "St. Mark's Maternity Hospital (SMMH)",
                hosp_name == "central hospital" ~ "Central Hospital",
                TRUE ~ hosp_name)))

#' ### `dplyr::*_join()`
data_mini %>% left_join(hosp_df,
                        by = c("hospital" = "hosp_name"))

data_mini %>% full_join(hosp_df,
                        by = c("hospital" = "hosp_name"))

data_mini %>% inner_join(hosp_df,
                         by = c("hospital" = "hosp_name"))

data_mini %>% semi_join(hosp_df,
                        by = c("hospital" = "hosp_name"))

hosp_df %>% semi_join(data_mini,
                      by = c("hosp_name" = "hospital"))

hosp_df %>% anti_join(data_mini,
                        by = c("hosp_name" = "hospital"))

#' ### Probabilistic matching
#' Example datasets

(cases <- tribble(
        ~gender, ~first,      ~middle,     ~last,        ~yr,   ~mon, ~day, ~district,
        "M",     "Amir",      NA,          "Khan",       1989,  11,   22,   "River",
        "M",     "Anthony",   "B.",        "Smith",      1970,  09,   19,   "River", 
        "F",     "Marialisa", "Contreras", "Rodrigues",  1972,  04,   15,   "River",
        "F",     "Elizabeth", "Casteel",   "Chase",      1954,  03,   03,   "City",
        "M",     "Jose",      "Sanchez",   "Lopez",      1996,  01,   06,   "City",
        "F",     "Cassidy",   "Jones",     "Davis",      1980,  07,   20,   "City",
        "M",     "Michael",   "Murphy",    "O'Calaghan", 1969,  04,   12,   "Rural", 
        "M",     "Oliver",    "Laurent",   "De Bordow" , 1971,  02,   04,   "River",
        "F",     "Blessing",  NA,          "Adebayo",    1955,  02,   14,   "Rural"
))

(results <- tribble(
        ~gender,  ~first,     ~middle,     ~last,          ~yr, ~mon, ~day, ~district, ~result,
        "M",      "Amir",     NA,          "Khan",         1989, 11,   22,  "River", "positive",
        "M",      "Tony",     "B",         "Smith",        1970, 09,   19,  "River", "positive",
        "F",      "Maria",    "Contreras", "Rodriguez",    1972, 04,   15,  "Cty",   "negative",
        "F",      "Betty",    "Castel",    "Chase",        1954, 03,   30,  "City",  "positive",
        "F",      "Andrea",   NA,          "Kumaraswamy",  2001, 01,   05,  "Rural", "positive",      
        "F",      "Caroline", NA,          "Wang",         1988, 12,   11,  "Rural", "negative",
        "F",      "Trang",    NA,          "Nguyen",       1981, 06,   10,  "Rural", "positive",
        "M",      "Olivier" , "Laurent",   "De Bordeaux",  NA,   NA,   NA,  "River", "positive",
        "M",      "Mike",     "Murphy",    "O'Callaghan",  1969, 04,   12,  "Rural", "negative",
        "F",      "Cassidy",  "Jones",     "Davis",        1980, 07,   02,  "City",  "positive",
        "M",      "Mohammad", NA,          "Ali",          1942, 01,   17,  "City",  "negative",
        NA,       "Jose",     "Sanchez",   "Lopez",        1995, 01,   06,  "City",  "negative",
        "M",      "Abubakar", NA,          "Abullahi",     1960, 01,   01,  "River", "positive",
        "F",      "Maria",    "Salinas",   "Contreras",    1955, 03,   03,  "River", "positive"
))

#' Match the data on string distance across the name and district columns, 
#' and on numeric distance for year, month, and day of birth.
#' Match threshold of 95% probability.
fl_output <- fastLink::fastLink(
        dfA = cases,
        dfB = results,
        varnames = c("gender", "first", "middle", "last", "yr", "mon", "day", "district"),
        stringdist.match = c("first", "middle", "last", "district"),
        numeric.match = c("yr", "mon", "day"),
        threshold.match = 0.95)

#' `matches` df: most likely matches across `cases` and `results` (row index)
(my_matches <- fl_output$matches)

#' Clean data prior to joining
# convert cases rownames to a column 
(cases_clean <- cases %>% rownames_to_column())

# convert test_results rownames to a column
(results_clean <- results %>% rownames_to_column())

# convert all columns in matches dataset to character, so they can be joined to the rownames
(matches_clean <- my_matches %>%
        mutate(across(everything(), as.character)))

#' Join matches to dfA, then add dfB
# column "inds.b" is added to dfA
(complete <- left_join(cases_clean,
                      matches_clean,
                      by = c("rowname" = "inds.a")))

# column(s) from dfB are added 
(complete <- left_join(complete,
                      results_clean,
                      by = c("inds.b" = "rowname")))

#' De-duplicate rows
# create dataframe with duplicated rows
(cases_dup <- tribble(
        ~gender, ~first,      ~middle,     ~last,        ~yr,   ~mon, ~day, ~district,
        "M",     "Amir",      NA,          "Khan",       1989,  11,   22,   "River",
        "M",     "Anthony",   "B.",        "Smith",      1970,  09,   19,   "River", 
        "F",     "Marialisa", "Contreras", "Rodrigues",  1972,  04,   15,   "River",
        "F",     "Elizabeth", "Casteel",   "Chase",      1954,  03,   03,   "City",
        "M",     "Jose",      "Sanchez",   "Lopez",      1996,  01,   06,   "City",
        "F",     "Cassidy",   "Jones",     "Davis",      1980,  07,   20,   "City",
        "M",     "Michael",   "Murphy",    "O'Calaghan", 1969,  04,   12,   "Rural", 
        "M",     "Oliver",    "Laurent",   "De Bordow" , 1971,  02,   04,   "River",
        "F",     "Blessing",  NA,          "Adebayo",    1955,  02,   14,   "Rural",
        "M",     "Tony",      "B.",        "Smith",      1970,  09,   19,   "River", 
        "F",     "Maria",     "Contreras", "Rodrigues",  1972,  04,   15,   "River"
        ))

# run fastLink on the same dataset
dedupe_output <- fastLink(
        dfA = cases_dup,
        dfB = cases_dup,
        varnames = c("gender", "first", "middle", "last", "yr", "mon", "day", "district")
)

# run `getMatches()`: review the potential duplicates
(cases_dedupe <- getMatches(
        dfA = cases_dup,
        dfB = cases_dup,
        fl.out = dedupe_output))

cases_dedupe %>% 
        count(dedupe.ids) %>% 
        filter(n > 1)

# displays duplicates
cases_dedupe %>% filter(dedupe.ids %in% c(2, 3))

#' ### Bind rows
# create core table
(hosp_summary <- data %>% 
        group_by(hospital) %>%
        summarise(# number of rows per hospital-outcome group
                  cases = n(),
                  # median CT value per group
                  ct_value_med = median(ct_blood, na.rm=T)))

# create totals
(totals <- data %>% 
        summarise(cases = n(),
                  ct_value_med = median(ct_blood, na.rm=T)))

# bind dataframes together
bind_rows(hosp_summary, totals) %>%
        mutate(hospital = replace_na(hospital, "Totals"))


#rmarkdown::render()

