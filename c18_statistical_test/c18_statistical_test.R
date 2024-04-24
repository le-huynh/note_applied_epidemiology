#'---
#' title: Simple statistical tests
#' output: github_document
#'---

#+ message=FALSE
pacman::p_load(
        rio,            # import and export files
        here,           # locate files 
        tidyverse,      # data management and visualization
        skimr,          # get overview of data
        gtsummary,    # summary statistics and tests
        rstatix,      # statistics
        corrr,        # correlation analysis for numeric variables
        janitor,      # adding totals and percents to tables
        flextable     # converting tables to HTML
)

#' ## Import data
data <- rio::import(here("data/linelist_cleaned.rds"))

#' ## `t-test`
#' #### Syntax 1: numeric and categorical columns are in the same dataframe
#' `baseR`
t.test(age_years ~ gender, data = data)

#' `rstatix::`
data %>% rstatix::t_test(age_years ~ gender)

#' `gtsummary::`
data %>% select(age_years, gender) %>%
        tbl_summary(statistic = age_years ~ "{mean} ({sd})",
                    by = gender) %>%
        add_p(age_years ~ "t.test")

#' #### Syntax 2: compare two separate numeric vectors from different datasets
# t.test(df1$col1, df2$col2)

#' #### one-sample t-test
#' `baseR`
t.test(data$age_years, mu = 20)

#' `rstatix::`
data %>% rstatix::t_test(age_years ~ 1, mu = 20)

data %>% group_by(gender) %>%
        t_test(age_years ~ 1, mu = 20)

#' ## `Shapiro-Wilk test`
#' `baseR`
# sample size must be between 3 and 5000
df <- data %>% head(1000)
shapiro.test(df$age_years)

#' `rstatix::`
# sample size must be between 3 and 5000
data %>% head(1000) %>%
        shapiro_test(age_years)

#' ## `Wilcoxon rank sum test` or `Mann–Whitney U test`
#' `baseR`
wilcox.test(age_years ~ outcome, data = data)

#' `rstatix::`
data %>% wilcox_test(age_years ~ outcome)

#' `gtsummary::`
data %>% select(age_years, outcome) %>%
        tbl_summary(statistic = age_years ~ "{median} ({p25}, {p75})",
                    by = outcome) %>%
        add_p(age_years ~ "wilcox.test")

#' ## `Kruskal-Wallis test`
#' `baseR`
kruskal.test(age_years ~ outcome, data = data)

#' `rstatix::`
data %>% kruskal_test(age_years ~ outcome)

#' `gtsummary::`
data %>% select(age_years, outcome) %>%
        tbl_summary(statistic = age_years ~ "{median} ({p25}, {p75})",
                    by = outcome) %>%
        add_p(age_years ~ "kruskal.test")

#' ## `Chi-squared test`
#' `baseR`
stats::chisq.test(data$gender, data$outcome)

#' `rstatix::`
data %>% tabyl(gender, outcome)

data %>% tabyl(gender, outcome) %>%
        select(-1)

data %>% tabyl(gender, outcome) %>%
        select(-1) %>%
        chisq_test()

#' `gtsummary::`
data %>% select(gender, outcome) %>%
        tbl_summary(by = outcome) %>%
        add_p()

#' ## Correlation
#' `corrr::correlate()`: computing Pearson, Kendall tau or Spearman rho correlation
data %>% select(generation, age, ct_blood) %>%
        corrr::correlate()

# remove duplicate entries
data %>% select(generation, age, ct_blood) %>%
        corrr::correlate() %>%
        shave()

# rmarkdown::render()

