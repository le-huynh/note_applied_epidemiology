#'---
#' title: Data Cleaning
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,        # importing data  
        here,       # relative file pathways  
        janitor,    # data cleaning and tables
        lubridate,  # working with dates
        matchmaker, # dictionary-based cleaning
        epikit,     # age_categories() function
        tidyverse   # data management and visualization
)

#' ### Import data
data_raw <- rio::import(here("data/linelist_raw.xlsx"))

data_raw %>% head()

#' ### Check data
skimr::skim(data_raw)

#' ### Clean column names
# check column names
data_raw %>% names()

# clean column names automatically
data_raw %>% 
        janitor::clean_names() %>% 
        names()

# rename columns manually using `janitor::clean_names()`
data_raw %>% 
        janitor::clean_names(replace = c(onset = "date_of_onset")) %>% 
        names()

# rename columns manually using `dplyr::rename()`
data <- data_raw %>% 
        janitor::clean_names() %>% 
        dplyr::rename(# new column = old column
                      date_infection = infection_date,
                      date_hospitalisation = hosp_date,
                      date_outcome = date_of_outcome) 
data %>% names()

#' ### `tidyselect` helper functions
#' `where()`
# select Numeric columns
data %>% 
        select(where(is.numeric)) %>% 
        names()

#' `matches()`
data %>%
        select(matches("onset|hosp|fev")) %>%
        names()

#' `any_of()`
data %>%
        select(any_of(c("date_onset",
                        "month_onset",
                        "year_onset",
                        "fever"))) %>%
        names()

#' ### Remove columns
data %>%
        select(-c(row_num, merged_header, x28)) %>% 
        names()

#' ### De-duplication
data_raw %>% nrow()
data %>% distinct() %>% nrow()


#' ### Transform data
#' `coalesce()`
#' Find the first non-missing value at each position?

#' Cumulative math
# simple example
cumsum(c(2, 5, 10, 15))

#' Calculate the cumulative number of cases per day in an outbreak
data %>%
        # count of rows per day, as column 'n'
        count(date_onset) %>%
        # new column, of the cumulative sum at each row
        mutate(cumulative_cases = cumsum(n)) %>%
        tail(n = 15)

# cumsum(), cummean(), cummin(), cummax(), cumany(), cumall()

#' ### Recode values
#' #### Specific values
#' Fix incorrect value manually
data %>% 
        select(date_onset) %>%
        mutate(new_date_onset = recode(date_onset,
                                       # old value = new value
                                       "2014-05-16" = "2024-05-16")) %>% 
        head(4)

# re-coding multiple values within one column.
# check "hospital" column --> several different spellings + many missing values
data %>% count(hospital)

# re-code values
data %>%
        mutate(hospital = recode(hospital,
                                 # old value = new value
                                 "Mitylira Hopital"  = "Military Hospital",
                                 "Mitylira Hospital" = "Military Hospital",
                                 "Military Hopital"  = "Military Hospital",
                                 "Port Hopital"      = "Port Hospital",
                                 "Central Hopital"   = "Central Hospital",
                                 "other"             = "Other",
                                 "St. Marks Maternity Hopital (SMMH)" = "St. Mark's Maternity Hospital (SMMH)")) %>%
        count(hospital)

#' #### Re-code value by logic
#' `replace()`
# change gender of one specific observation to "Female" 
data %>% select(case_id:date_onset, gender) %>%
        filter(date_onset == "2014-05-16")

data %>% select(case_id:date_onset,
                gender) %>%
        filter(date_onset == "2014-05-16") %>%
        mutate(gender = replace(gender,
                                date_onset == "2014-05-16",
                                "Female"))

#' `ifelse()` and `if_else()`
data %>% count(source)

data %>% select(source) %>% head(10)

data %>% mutate(source_known = if_else(!is.na(source),
                                       "known",
                                       "unknown")) %>%
        select(source, source_known) %>%
        head(10)

data %>% select(outcome, date_outcome) %>%
        tail()

data %>% select(outcome, date_outcome) %>%
        mutate(date_death = if_else(outcome == "Death",
                                    date_outcome,
                                    NA)) %>%
        tail()

#' `case_when()`
data %>% 
        mutate(age = as.numeric(age),
               age_years = case_when(# if age unit is years
                                     age_unit == "years"  ~ age,
                                     # if age unit is months, divide age by 12
                                     age_unit == "months" ~ age/12,
                                     # if age unit is missing, assume years
                                     # any other circumstance, assign NA (missing)
                                     is.na(age_unit)      ~ age)) %>%
        select(age, age_unit, age_years) %>% 
        tail(10)

data %>% 
        mutate(case_status = case_when(
                
                # if patient had lab test and it is positive,
                # then they are marked as a confirmed case 
                ct_blood < 20                   ~ "Confirmed",
                
                # given that a patient does not have a positive lab result,
                # if patient has a "source" (epidemiological link) AND has fever, 
                # then they are marked as a suspect case
                !is.na(source) & fever == "yes" ~ "Suspect",
                
                # any other patient not addressed above 
                # is marked for follow up
                TRUE                            ~ "To investigate")) %>%
        select(ct_blood, source, fever, case_status) %>%
        tail(15)

#' #### Work with missing value
data %>% count(hospital)

#' `replace_na()`
data %>% 
        mutate(hospital = replace_na(hospital, "Missing")) %>%
        count(hospital)

#' `fct_explicit_na()`
#' replace NA values of `factor` data class
data %>% 
        mutate(hospital = fct_explicit_na(hospital)) %>%
        count(hospital)

#' `na_if()`
data %>% 
        mutate(hospital = na_if(hospital, "Other")) %>%
        count(hospital)

#' Test
# convert temperatures above 40 to NA
data %>% count(temp)

data %>% 
        mutate(new_temp = replace(temp, temp > 40, NA)) %>%
        count(new_temp)

# convert onset dates earlier than 1 Jan 2000 to missing
data %>%
        mutate(new_onset = replace(date_onset,
                                   date_onset > as.Date("2000-01-01"),
                                   NA)) %>%
        select(date_onset, new_onset) %>%
        head(10)

#' #### Cleaning dictionary
# import cleaning dictionary
(cleaning_dict <- rio::import(here("data/cleaning_dict.csv")))

data %>% tail(15)

data %>%
        matchmaker::match_df(
                # name of your dictionary
                dictionary = cleaning_dict,
                # column with values to be replaced (default is col 1)
                from = "from",
                # column with final values (default is col 2)
                to = "to",
                # column with column names (default is col 3)
                by = "col"
        ) %>%
        head(15)

#' ### Numeric categories
#' #### `epikit::age_categories()`
data01 <- data %>% 
        mutate(age = as.numeric(age),
               age_years = case_when(# if age unit is years
                       age_unit == "years"  ~ age,
                       # if age unit is months, divide age by 12
                       age_unit == "months" ~ age/12,
                       # if age unit is missing, assume years
                       # any other circumstance, assign NA (missing)
                       is.na(age_unit)      ~ age),
               age_cat = epikit::age_categories(
                       age_years,
                       breakers = c(0, 5, 10, 15, 20, 30, 40, 50, 60, 70))) %>%
        select(age, age_unit, age_years, age_cat)

data01 %>% tibble()

# show table
base::table(data01$age_cat, useNA = "always")

table(Hospital = data$hospital,
      Year_onset = lubridate::year(data$date_onset),
      useNA = "always")

#' ### Filter
data %>% ggplot(aes(date_onset)) +
        geom_histogram(stat="count")

# filter data of the second break
df <- data %>%
        filter(date_onset > as.Date("2013-06-01") | 
                       (is.na(date_onset) & 
                                !hospital %in% c("Hospital A", "Hospital B")))

table(Hospital = df$hospital,
      Year_onset = lubridate::year(df$date_onset),
      useNA = "always")

#' `row_wise()`
data %>%
        rowwise() %>% 
        mutate(symptoms = sum(c(fever,
                                chills,
                                cough,
                                aches,
                                vomit) == "yes")) %>%
        # recommended, remove effects of rowwise() in subsequent steps
        ungroup() %>% 
        select(fever, chills, cough, aches, vomit, symptoms)


#rmarkdown::render()

