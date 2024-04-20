#'---
#' title: Descriptive table
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,          # File import
        here,         # File locator
        skimr,        # get overview of data
        tidyverse,    # data management + ggplot2 graphics 
        gtsummary,    # summary statistics and tests
        rstatix,      # summary statistics and statistical tests
        janitor,      # adding totals and percents to tables
        scales,       # easily convert proportions to percents  
        flextable     # converting tables to pretty images
        )

#' ### Import data
data <- rio::import(here("data/linelist_cleaned.rds"))

#' ### Browse data
#' `skimr` package
skimr::skim(data)

#' `rstatix` package
rstatix::get_summary_stats(data)

#' ### `janitor` package
#' Simple tabyl
data %>% janitor::tabyl(age_cat)

#' Cross-tabulation
data %>% janitor::tabyl(age_cat, gender)

#' "Adorning" the tabyl
data %>% tabyl(age_cat, gender) %>%
        adorn_totals(where = "both", name = "N-Total")

data %>% tabyl(age_cat) %>%
        adorn_pct_formatting()

data %>%                                  
        tabyl(age_cat, gender) %>%                  # counts by age and gender
        adorn_totals(where = "row") %>%             # add total row
        adorn_percentages(denominator = "row") %>%  # convert counts to proportions
        adorn_pct_formatting(digits = 1)            # convert proportions to percents

data %>%
        tabyl(age_cat, gender) %>%                  # cross-tabulate counts
        adorn_totals(where = "row") %>%             # add a total row
        adorn_percentages(denominator = "col") %>%  # convert to proportions
        adorn_pct_formatting() %>%                  # convert to percents
        adorn_ns(position = "front") %>%            # display as: "count (percent)"
        adorn_title(                                # adjust titles
                row_name = "Age Category",
                col_name = "Gender")

data %>% count(hospital) %>%
        adorn_totals()

#' ### `dplyr` package
#' Proportions = n / sum(n) = counts-column / sum(counts-column)
data %>% count(age_cat) %>%
        mutate(percent = scales::percent(n / sum(n)))

data %>% group_by(outcome) %>%
        count(age_cat) %>%
        mutate(percent = scales::percent(n / sum(n)))

#' Summary statistics
data %>%
        group_by(hospital) %>%
        summarise(# number of rows per group
                  cases       = n(),
                  # max delay
                  delay_max   = max(days_onset_hosp, na.rm = T),
                  # mean delay, rounded
                  delay_mean  = round(mean(days_onset_hosp, na.rm=T), digits = 1),
                  # standard deviation of delays, rounded
                  delay_sd    = round(sd(days_onset_hosp, na.rm = T), digits = 1),
                  # number of rows with delay of 3 or more days
                  delay_3     = sum(days_onset_hosp >= 3, na.rm = T),
                  # convert previously-defined delay column to percent
                  pct_delay_3 = scales::percent(delay_3 / cases))

#' Conditional statistics
# return maximum temperature for patients classified having or not having fever
data %>% group_by(hospital) %>%
        summarise(max_temp_fever = max(temp[fever == "yes"], na.rm = TRUE),
                  max_temp_nofever = max(temp[fever == "no"], na.rm = TRUE))

#' Glueing together
data %>% group_by(hospital) %>%
        summarise(# number of rows per group
                cases       = n(),
                # mean delay, rounded
                delay_mean  = round(mean(days_onset_hosp, na.rm = T),
                                    digits = 1),
                # standard deviation of delays, rounded
                delay_sd    = round(sd(days_onset_hosp, na.rm = T),
                                    digits = 1)) %>%
        mutate(delay = str_glue("{delay_mean} ({delay_sd})")) %>%
        select(-c(delay_mean, delay_sd)) %>%
        adorn_totals(where = "row") %>%
        select("Hospital Name" = hospital,
               "Cases" = cases,
               "Mean (sd)" = delay)

#' Percentiles
# get default percentile values of age (0%, 25%, 50%, 75%, 100%)
data %>% summarise(age_percentiles = quantile(age_years,
                                              na.rm = TRUE))

# get manually-specified percentile values of age (5%, 50%, 75%, 98%)
data %>% summarise(age_percentiles = quantile(age_years,
                                              probs = c(0.05, 0.5, 0.75, 0.98),
                                              na.rm = TRUE))

# use `rstatix`
data %>% rstatix::get_summary_stats(age_years,
                                    type = "quantile")

data %>% rstatix::get_summary_stats(age_years,
                                    type = "quantile",
                                    probs = c(0.05, 0.5, 0.75, 0.98))
#' Summarize aggregated data
(data_agg <- data %>% drop_na(gender, outcome) %>%
                count(gender, outcome))

data_agg %>% group_by(outcome) %>%
        summarise(total_cases = sum(n, na.rm = TRUE),
                  male_cases = sum(n[gender == "m"], na.rm = TRUE),
                  female_cases = sum(n[gender == "f"], na.rm = TRUE))

#' `across()` multiple columns
# 1 function
data %>% group_by(outcome) %>%
        summarise(across(.cols = c(age_years,
                                   temp,
                                   wt_kg,
                                   ht_cm),
                         .fns = ~ mean(.x, na.rm = TRUE)))

# multiple functions
data %>% group_by(outcome) %>%
        summarise(across(.cols = c(age_years,
                                   temp),
                         .fns = list("mean" = mean,
                                     "sd" = sd),
                         na.rm = TRUE))


#' ### `gtsummary` package
#' Summary table
data %>% select(age_years, gender, outcome) %>%
        gtsummary::tbl_summary()

data %>% select(age_years) %>%
        tbl_summary(statistic = age_years ~ "{mean}")

data %>% select(age_years) %>%
        tbl_summary(statistic = age_years ~ "({min}, {max})")

data %>% select(age_years, gender, outcome) %>%
        tbl_summary(# stratify entire table by outcome
                    by = outcome,
                    statistic = list(# stats and format for continuous columns
                                     all_continuous() ~ "{mean} ({sd})",
                                     # stats and format for categorical columns
                                     all_categorical() ~ "{n} / {N} ({p}%)"),
                    # rounding for continuous columns
                    digits = all_continuous() ~ 1,
                    # force all categorical levels to display
                    type = all_categorical() ~ "categorical",
                    # display labels for column names
                    label = list(outcome ~ "Outcome",
                                 age_years ~ "Age (years)",
                                 gender ~ "Gender"))

data %>% select(age_years, temp) %>%
        tbl_summary(# indicate that you want to print multiple statistics 
                    type = all_continuous() ~ "continuous2",
                    statistic = all_continuous() ~ c(# line 1: mean and SD
                                                     "{mean} ({sd})",
                                                     # line 2: median and IQR
                                                     "{median} ({p25}, {p75})",
                                                     # line 3: min and max
                                                     "{min}, {max}"))

#rmarkdown::render()
