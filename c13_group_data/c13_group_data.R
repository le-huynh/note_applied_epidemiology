#'---
#' title: Grouping Data
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,        # importing data  
        here,       # relative file pathways  
        janitor,    # data cleaning and tables
        tidyverse   # data management and visualization
)

#' ### Import data
data <- rio::import(here("data/linelist_cleaned.rds"))

#' ### Grouping
#' `tally()`
data %>% group_by(outcome) %>% group_keys()

data %>% group_by(outcome) %>% tally()

data %>% group_by(outcome, gender) %>% tally()

#' New columns
data %>% mutate(age_class = ifelse(age >= 18,
                                   "adult",
                                   "child")) %>%
        group_by(age_class) %>%
        tally()

data %>% group_by(age_class = ifelse(age >= 18,
                                     "adult",
                                     "child")) %>%
        tally()

#' Add/drop grouping columns
# group by outcome
(df <- data %>% group_by(outcome))

# add grouping by gender
df %>% group_by(gender)

df %>% group_by(gender, .add = TRUE)

#' ### count() vs tally()
#' `tally()` <= `summarise(n = n())`
data %>% tally()

data %>% group_by(fever) %>% tally()

data %>% group_by(fever) %>% tally(sort = TRUE)

#' `count()` <= `group_by()` --> `summarise()` --> `ungroup()`
data %>% count(fever)

#' summarize the number of hospitals present for each gender
data %>% count(hospital, gender) %>%
        count(gender, name = "hospitals per gender")

#' `add_count()`: add a new column `n` with the counts of rows per group
data %>% add_count(hospital) %>% 
        select(hospital, n, everything()) %>%
        tibble()

#' `add_total()`: add total sum rows/columns after `tally()` or `count()`
# cross-tabulate counts of two columns
data %>% janitor::tabyl(age_cat, gender)

data %>% janitor::tabyl(age_cat, gender) %>%
        # add total row
        adorn_totals(where = "row")

data %>% janitor::tabyl(age_cat, gender) %>%
        # add total column
        adorn_totals(where = "col")

data %>% janitor::tabyl(age_cat, gender) %>%
        adorn_totals(where = "col") %>%
        # convert to proportions with column denominator
        adorn_percentages(denominator = "col")

data %>% janitor::tabyl(age_cat, gender) %>%
        adorn_totals(where = "col") %>%
        adorn_percentages(denominator = "col") %>%
        # convert proportions to percents
        adorn_pct_formatting() 

data %>% janitor::tabyl(age_cat, gender) %>%
        adorn_totals(where = "col") %>%
        adorn_percentages(denominator = "col") %>%
        adorn_pct_formatting() %>%
        # display as: "(count) percent"
        adorn_ns(position = "rear") %>%
        # adjust titles
        adorn_title(row_name = "Age Category",
                    col_name = "Gender")

#' ### Filter on grouped data
data %>% group_by(hospital) %>%
        # arrange data_hospitalisation from latest to earliest within each group
        arrange(hospital, date_hospitalisation) %>% 
        # slice first 5 rows from each hospital
        slice_head(n = 5) %>% 
        arrange(hospital) %>%
        select(case_id, hospital, date_hospitalisation)

data %>% add_count(hospital) %>% 
        filter(n < 500) %>% 
        select(hospital, n) %>%
        head(15)

#' ### Mutate on grouped data
data %>% group_by(hospital) %>%
        mutate(# mean days to admission per hospital
               group_delay_admit = round(mean(days_onset_hosp,
                                              na.rm = TRUE),
                                         2),
               # difference between row's delay and mean delay at their hospital
               diff_to_group     = round(days_onset_hosp - group_delay_admit,
                                         2)) %>%
        select(case_id, 
               hospital,
               days_onset_hosp,
               group_delay_admit,
               diff_to_group)


# rmarkdown::render()







