Descriptive table
================

``` r
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
```

### Import data

``` r
data <- rio::import(here("data/linelist_cleaned.rds"))
```

### Browse data

`skimr` package

``` r
skimr::skim(data)
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | data |
| Number of rows                                   | 5888 |
| Number of columns                                | 30   |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| character                                        | 13   |
| Date                                             | 4    |
| factor                                           | 2    |
| numeric                                          | 11   |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Data summary

**Variable type: character**

| skim_variable  | n_missing | complete_rate | min | max | empty | n_unique | whitespace |
|:---------------|----------:|--------------:|----:|----:|------:|---------:|-----------:|
| case_id        |         0 |          1.00 |   6 |   6 |     0 |     5888 |          0 |
| outcome        |      1323 |          0.78 |   5 |   7 |     0 |        2 |          0 |
| gender         |       278 |          0.95 |   1 |   1 |     0 |        2 |          0 |
| age_unit       |         0 |          1.00 |   5 |   6 |     0 |        2 |          0 |
| hospital       |         0 |          1.00 |   5 |  36 |     0 |        6 |          0 |
| infector       |      2088 |          0.65 |   6 |   6 |     0 |     2697 |          0 |
| source         |      2088 |          0.65 |   5 |   7 |     0 |        2 |          0 |
| fever          |       249 |          0.96 |   2 |   3 |     0 |        2 |          0 |
| chills         |       249 |          0.96 |   2 |   3 |     0 |        2 |          0 |
| cough          |       249 |          0.96 |   2 |   3 |     0 |        2 |          0 |
| aches          |       249 |          0.96 |   2 |   3 |     0 |        2 |          0 |
| vomit          |       249 |          0.96 |   2 |   3 |     0 |        2 |          0 |
| time_admission |       765 |          0.87 |   5 |   5 |     0 |     1072 |          0 |

**Variable type: Date**

| skim_variable        | n_missing | complete_rate | min        | max        | median     | n_unique |
|:---------------------|----------:|--------------:|:-----------|:-----------|:-----------|---------:|
| date_infection       |      2087 |          0.65 | 2014-03-19 | 2015-04-27 | 2014-10-11 |      359 |
| date_onset           |       256 |          0.96 | 2014-04-07 | 2015-04-30 | 2014-10-23 |      367 |
| date_hospitalisation |         0 |          1.00 | 2014-04-17 | 2015-04-30 | 2014-10-23 |      363 |
| date_outcome         |       936 |          0.84 | 2014-04-19 | 2015-06-04 | 2014-11-01 |      371 |

**Variable type: factor**

| skim_variable | n_missing | complete_rate | ordered | n_unique | top_counts                                |
|:--------------|----------:|--------------:|:--------|---------:|:------------------------------------------|
| age_cat       |        86 |          0.99 | FALSE   |        8 | 0-4: 1095, 5-9: 1095, 20-: 1073, 10-: 941 |
| age_cat5      |        86 |          0.99 | FALSE   |       17 | 0-4: 1095, 5-9: 1095, 10-: 941, 15-: 743  |

**Variable type: numeric**

| skim_variable   | n_missing | complete_rate |   mean |    sd |       p0 |    p25 |    p50 |    p75 |    p100 | hist  |
|:----------------|----------:|--------------:|-------:|------:|---------:|-------:|-------:|-------:|--------:|:------|
| generation      |         0 |          1.00 |  16.56 |  5.79 |     0.00 |  13.00 |  16.00 |  20.00 |   37.00 | ▁▆▇▂▁ |
| age             |        86 |          0.99 |  16.07 | 12.62 |     0.00 |   6.00 |  13.00 |  23.00 |   84.00 | ▇▅▁▁▁ |
| age_years       |        86 |          0.99 |  16.02 | 12.64 |     0.00 |   6.00 |  13.00 |  23.00 |   84.00 | ▇▅▁▁▁ |
| lon             |         0 |          1.00 | -13.23 |  0.02 |   -13.27 | -13.25 | -13.23 | -13.22 |  -13.21 | ▅▃▃▆▇ |
| lat             |         0 |          1.00 |   8.47 |  0.01 |     8.45 |   8.46 |   8.47 |   8.48 |    8.49 | ▅▇▇▇▆ |
| wt_kg           |         0 |          1.00 |  52.64 | 18.58 |   -11.00 |  41.00 |  54.00 |  66.00 |  111.00 | ▁▃▇▅▁ |
| ht_cm           |         0 |          1.00 | 124.96 | 49.52 |     4.00 |  91.00 | 129.00 | 159.00 |  295.00 | ▂▅▇▂▁ |
| ct_blood        |         0 |          1.00 |  21.21 |  1.69 |    16.00 |  20.00 |  22.00 |  22.00 |   26.00 | ▁▃▇▃▁ |
| temp            |       149 |          0.97 |  38.56 |  0.98 |    35.20 |  38.20 |  38.80 |  39.20 |   40.80 | ▁▂▂▇▁ |
| bmi             |         0 |          1.00 |  46.89 | 55.39 | -1200.00 |  24.56 |  32.12 |  50.01 | 1250.00 | ▁▁▇▁▁ |
| days_onset_hosp |       256 |          0.96 |   2.06 |  2.26 |     0.00 |   1.00 |   1.00 |   3.00 |   22.00 | ▇▁▁▁▁ |

`rstatix` package

``` r
rstatix::get_summary_stats(data)
```

    ## # A tibble: 11 × 13
    ##    variable     n     min     max median     q1     q3    iqr    mad   mean     sd    se    ci
    ##    <fct>    <dbl>   <dbl>   <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>
    ##  1 generat…  5888  0        37     16     13     20     7      5.93   16.6   5.79  0.075 0.148
    ##  2 age       5802  0        84     13      6     23    17     11.9    16.1  12.6   0.166 0.325
    ##  3 age_yea…  5802  0        84     13      6     23    17     11.9    16.0  12.6   0.166 0.325
    ##  4 lon       5888 -1.33e1  -13.2  -13.2  -13.3  -13.2   0.035  0.021 -13.2   0.019 0     0    
    ##  5 lat       5888  8.45e0    8.49   8.47   8.46   8.48  0.018  0.014   8.47  0.011 0     0    
    ##  6 wt_kg     5888 -1.1 e1  111     54     41     66    25     17.8    52.6  18.6   0.242 0.475
    ##  7 ht_cm     5888  4   e0  295    129     91    159    68     48.9   125.   49.5   0.645 1.26 
    ##  8 ct_blood  5888  1.6 e1   26     22     20     22     2      1.48   21.2   1.69  0.022 0.043
    ##  9 temp      5739  3.52e1   40.8   38.8   38.2   39.2   1      0.741  38.6   0.977 0.013 0.025
    ## 10 bmi       5888 -1.2 e3 1250     32.1   24.6   50.0  25.4   14.4    46.9  55.4   0.722 1.42 
    ## 11 days_on…  5632  0        22      1      1      3     2      1.48    2.06  2.26  0.03  0.059

### `janitor` package

Simple tabyl

``` r
data %>% janitor::tabyl(age_cat)
```

    ##  age_cat    n     percent valid_percent
    ##      0-4 1095 0.185971467   0.188728025
    ##      5-9 1095 0.185971467   0.188728025
    ##    10-14  941 0.159816576   0.162185453
    ##    15-19  743 0.126188859   0.128059290
    ##    20-29 1073 0.182235054   0.184936229
    ##    30-49  754 0.128057065   0.129955188
    ##    50-69   95 0.016134511   0.016373664
    ##      70+    6 0.001019022   0.001034126
    ##     <NA>   86 0.014605978            NA

Cross-tabulation

``` r
data %>% janitor::tabyl(age_cat, gender)
```

    ##  age_cat   f   m NA_
    ##      0-4 640 416  39
    ##      5-9 641 412  42
    ##    10-14 518 383  40
    ##    15-19 359 364  20
    ##    20-29 468 575  30
    ##    30-49 179 557  18
    ##    50-69   2  91   2
    ##      70+   0   5   1
    ##     <NA>   0   0  86

“Adorning” the tabyl

``` r
data %>% tabyl(age_cat, gender) %>%
        adorn_totals(where = "both", name = "N-Total")
```

    ##  age_cat    f    m NA_ N-Total
    ##      0-4  640  416  39    1095
    ##      5-9  641  412  42    1095
    ##    10-14  518  383  40     941
    ##    15-19  359  364  20     743
    ##    20-29  468  575  30    1073
    ##    30-49  179  557  18     754
    ##    50-69    2   91   2      95
    ##      70+    0    5   1       6
    ##     <NA>    0    0  86      86
    ##  N-Total 2807 2803 278    5888

``` r
data %>% tabyl(age_cat) %>%
        adorn_pct_formatting()
```

    ##  age_cat    n percent valid_percent
    ##      0-4 1095   18.6%         18.9%
    ##      5-9 1095   18.6%         18.9%
    ##    10-14  941   16.0%         16.2%
    ##    15-19  743   12.6%         12.8%
    ##    20-29 1073   18.2%         18.5%
    ##    30-49  754   12.8%         13.0%
    ##    50-69   95    1.6%          1.6%
    ##      70+    6    0.1%          0.1%
    ##     <NA>   86    1.5%             -

``` r
data %>%                                  
        tabyl(age_cat, gender) %>%                  # counts by age and gender
        adorn_totals(where = "row") %>%             # add total row
        adorn_percentages(denominator = "row") %>%  # convert counts to proportions
        adorn_pct_formatting(digits = 1)            # convert proportions to percents
```

    ##  age_cat     f     m    NA_
    ##      0-4 58.4% 38.0%   3.6%
    ##      5-9 58.5% 37.6%   3.8%
    ##    10-14 55.0% 40.7%   4.3%
    ##    15-19 48.3% 49.0%   2.7%
    ##    20-29 43.6% 53.6%   2.8%
    ##    30-49 23.7% 73.9%   2.4%
    ##    50-69  2.1% 95.8%   2.1%
    ##      70+  0.0% 83.3%  16.7%
    ##     <NA>  0.0%  0.0% 100.0%
    ##    Total 47.7% 47.6%   4.7%

``` r
data %>%
        tabyl(age_cat, gender) %>%                  # cross-tabulate counts
        adorn_totals(where = "row") %>%             # add a total row
        adorn_percentages(denominator = "col") %>%  # convert to proportions
        adorn_pct_formatting() %>%                  # convert to percents
        adorn_ns(position = "front") %>%            # display as: "count (percent)"
        adorn_title(                                # adjust titles
                row_name = "Age Category",
                col_name = "Gender")
```

    ##                       Gender                            
    ##  Age Category              f              m          NA_
    ##           0-4   640  (22.8%)   416  (14.8%)  39  (14.0%)
    ##           5-9   641  (22.8%)   412  (14.7%)  42  (15.1%)
    ##         10-14   518  (18.5%)   383  (13.7%)  40  (14.4%)
    ##         15-19   359  (12.8%)   364  (13.0%)  20   (7.2%)
    ##         20-29   468  (16.7%)   575  (20.5%)  30  (10.8%)
    ##         30-49   179   (6.4%)   557  (19.9%)  18   (6.5%)
    ##         50-69     2   (0.1%)    91   (3.2%)   2   (0.7%)
    ##           70+     0   (0.0%)     5   (0.2%)   1   (0.4%)
    ##          <NA>     0   (0.0%)     0   (0.0%)  86  (30.9%)
    ##         Total 2,807 (100.0%) 2,803 (100.0%) 278 (100.0%)

``` r
data %>% count(hospital) %>%
        adorn_totals()
```

    ##                              hospital    n
    ##                      Central Hospital  454
    ##                     Military Hospital  896
    ##                               Missing 1469
    ##                                 Other  885
    ##                         Port Hospital 1762
    ##  St. Mark's Maternity Hospital (SMMH)  422
    ##                                 Total 5888

### `dplyr` package

Proportions = n / sum(n) = counts-column / sum(counts-column)

``` r
data %>% count(age_cat) %>%
        mutate(percent = scales::percent(n / sum(n)))
```

    ##   age_cat    n percent
    ## 1     0-4 1095  18.60%
    ## 2     5-9 1095  18.60%
    ## 3   10-14  941  15.98%
    ## 4   15-19  743  12.62%
    ## 5   20-29 1073  18.22%
    ## 6   30-49  754  12.81%
    ## 7   50-69   95   1.61%
    ## 8     70+    6   0.10%
    ## 9    <NA>   86   1.46%

``` r
data %>% group_by(outcome) %>%
        count(age_cat) %>%
        mutate(percent = scales::percent(n / sum(n)))
```

    ## # A tibble: 26 × 4
    ## # Groups:   outcome [3]
    ##    outcome age_cat     n percent
    ##    <chr>   <fct>   <int> <chr>  
    ##  1 Death   0-4       471 18.242%
    ##  2 Death   5-9       476 18.435%
    ##  3 Death   10-14     438 16.964%
    ##  4 Death   15-19     323 12.510%
    ##  5 Death   20-29     477 18.474%
    ##  6 Death   30-49     329 12.742%
    ##  7 Death   50-69      33 1.278% 
    ##  8 Death   70+         3 0.116% 
    ##  9 Death   <NA>       32 1.239% 
    ## 10 Recover 0-4       364 18.36% 
    ## # ℹ 16 more rows

Summary statistics

``` r
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
```

    ## # A tibble: 6 × 7
    ##   hospital                             cases delay_max delay_mean delay_sd delay_3 pct_delay_3
    ##   <chr>                                <int>     <dbl>      <dbl>    <dbl>   <int> <chr>      
    ## 1 Central Hospital                       454        12        1.9      1.9     108 24%        
    ## 2 Military Hospital                      896        15        2.1      2.4     253 28%        
    ## 3 Missing                               1469        22        2.1      2.3     399 27%        
    ## 4 Other                                  885        18        2        2.2     234 26%        
    ## 5 Port Hospital                         1762        16        2.1      2.2     470 27%        
    ## 6 St. Mark's Maternity Hospital (SMMH)   422        18        2.1      2.3     116 27%

Conditional statistics

``` r
# return maximum temperature for patients classified having or not having fever
data %>% group_by(hospital) %>%
        summarise(max_temp_fever = max(temp[fever == "yes"], na.rm = TRUE),
                  max_temp_nofever = max(temp[fever == "no"], na.rm = TRUE))
```

    ## # A tibble: 6 × 3
    ##   hospital                             max_temp_fever max_temp_nofever
    ##   <chr>                                         <dbl>            <dbl>
    ## 1 Central Hospital                               40.4             38  
    ## 2 Military Hospital                              40.5             38  
    ## 3 Missing                                        40.6             38  
    ## 4 Other                                          40.8             37.9
    ## 5 Port Hospital                                  40.6             38  
    ## 6 St. Mark's Maternity Hospital (SMMH)           40.6             37.9

Glueing together

``` r
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
```

    ##                         Hospital Name Cases Mean (sd)
    ##                      Central Hospital   454 1.9 (1.9)
    ##                     Military Hospital   896 2.1 (2.4)
    ##                               Missing  1469 2.1 (2.3)
    ##                                 Other   885   2 (2.2)
    ##                         Port Hospital  1762 2.1 (2.2)
    ##  St. Mark's Maternity Hospital (SMMH)   422 2.1 (2.3)
    ##                                 Total  5888         -

Percentiles

``` r
# get default percentile values of age (0%, 25%, 50%, 75%, 100%)
data %>% summarise(age_percentiles = quantile(age_years,
                                              na.rm = TRUE))
```

    ## Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in dplyr 1.1.0.
    ## ℹ Please use `reframe()` instead.
    ## ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()` always returns an
    ##   ungrouped data frame and adjust accordingly.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated.

    ##   age_percentiles
    ## 1               0
    ## 2               6
    ## 3              13
    ## 4              23
    ## 5              84

``` r
# get manually-specified percentile values of age (5%, 50%, 75%, 98%)
data %>% summarise(age_percentiles = quantile(age_years,
                                              probs = c(0.05, 0.5, 0.75, 0.98),
                                              na.rm = TRUE))
```

    ## Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in dplyr 1.1.0.
    ## ℹ Please use `reframe()` instead.
    ## ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()` always returns an
    ##   ungrouped data frame and adjust accordingly.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated.

    ##   age_percentiles
    ## 1               1
    ## 2              13
    ## 3              23
    ## 4              48

``` r
# use `rstatix`
data %>% rstatix::get_summary_stats(age_years,
                                    type = "quantile")
```

    ## # A tibble: 1 × 7
    ##   variable      n  `0%` `25%` `50%` `75%` `100%`
    ##   <fct>     <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>
    ## 1 age_years  5802     0     6    13    23     84

``` r
data %>% rstatix::get_summary_stats(age_years,
                                    type = "quantile",
                                    probs = c(0.05, 0.5, 0.75, 0.98))
```

    ## # A tibble: 1 × 6
    ##   variable      n  `5%` `50%` `75%` `98%`
    ##   <fct>     <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1 age_years  5802     1    13    23    48

Summarize aggregated data

``` r
(data_agg <- data %>% drop_na(gender, outcome) %>%
                count(gender, outcome))
```

    ##   gender outcome    n
    ## 1      f   Death 1227
    ## 2      f Recover  953
    ## 3      m   Death 1228
    ## 4      m Recover  950

``` r
data_agg %>% group_by(outcome) %>%
        summarise(total_cases = sum(n, na.rm = TRUE),
                  male_cases = sum(n[gender == "m"], na.rm = TRUE),
                  female_cases = sum(n[gender == "f"], na.rm = TRUE))
```

    ## # A tibble: 2 × 4
    ##   outcome total_cases male_cases female_cases
    ##   <chr>         <int>      <int>        <int>
    ## 1 Death          2455       1228         1227
    ## 2 Recover        1903        950          953

`across()` multiple columns

``` r
# 1 function
data %>% group_by(outcome) %>%
        summarise(across(.cols = c(age_years,
                                   temp,
                                   wt_kg,
                                   ht_cm),
                         .fns = ~ mean(.x, na.rm = TRUE)))
```

    ## # A tibble: 3 × 5
    ##   outcome age_years  temp wt_kg ht_cm
    ##   <chr>       <dbl> <dbl> <dbl> <dbl>
    ## 1 Death        15.9  38.6  52.6  125.
    ## 2 Recover      16.1  38.6  52.5  125.
    ## 3 <NA>         16.2  38.6  53.0  125.

``` r
# multiple functions
data %>% group_by(outcome) %>%
        summarise(across(.cols = c(age_years,
                                   temp),
                         .fns = list("mean" = mean,
                                     "sd" = sd),
                         na.rm = TRUE))
```

    ## # A tibble: 3 × 5
    ##   outcome age_years_mean age_years_sd temp_mean temp_sd
    ##   <chr>            <dbl>        <dbl>     <dbl>   <dbl>
    ## 1 Death             15.9         12.3      38.6   0.962
    ## 2 Recover           16.1         13.0      38.6   0.997
    ## 3 <NA>              16.2         12.8      38.6   0.976

### `gtsummary` package

Summary table

``` r
data %>% select(age_years, gender, outcome) %>%
        gtsummary::tbl_summary()
```

<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;N = 5,888&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>N = 5,888</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age_years</td>
<td headers="stat_0" class="gt_row gt_center">13 (6, 23)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">86</td></tr>
    <tr><td headers="label" class="gt_row gt_left">gender</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    f</td>
<td headers="stat_0" class="gt_row gt_center">2,807 (50%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    m</td>
<td headers="stat_0" class="gt_row gt_center">2,803 (50%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">278</td></tr>
    <tr><td headers="label" class="gt_row gt_left">outcome</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Death</td>
<td headers="stat_0" class="gt_row gt_center">2,582 (57%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Recover</td>
<td headers="stat_0" class="gt_row gt_center">1,983 (43%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">1,323</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="2"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> Median (IQR); n (%)</td>
    </tr>
  </tfoot>
</table>
</div>

``` r
data %>% select(age_years) %>%
        tbl_summary(statistic = age_years ~ "{mean}")
```

<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;N = 5,888&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>N = 5,888</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age_years</td>
<td headers="stat_0" class="gt_row gt_center">16</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">86</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="2"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> Mean</td>
    </tr>
  </tfoot>
</table>
</div>

``` r
data %>% select(age_years) %>%
        tbl_summary(statistic = age_years ~ "({min}, {max})")
```

<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;N = 5,888&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>N = 5,888</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age_years</td>
<td headers="stat_0" class="gt_row gt_center">(0, 84)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">86</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="2"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> (Range)</td>
    </tr>
  </tfoot>
</table>
</div>

``` r
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
```

    ## 1323 observations missing `outcome` have been removed. To include these observations, use `forcats::fct_na_value_to_level()` on `outcome` column before passing to `tbl_summary()`.


<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Death&lt;/strong&gt;, N = 2,582&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Death</strong>, N = 2,582<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Recover&lt;/strong&gt;, N = 1,983&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Recover</strong>, N = 1,983<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">Age (years)</td>
<td headers="stat_1" class="gt_row gt_center">15.9 (12.3)</td>
<td headers="stat_2" class="gt_row gt_center">16.1 (13.0)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_1" class="gt_row gt_center">32</td>
<td headers="stat_2" class="gt_row gt_center">28</td></tr>
    <tr><td headers="label" class="gt_row gt_left">Gender</td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    f</td>
<td headers="stat_1" class="gt_row gt_center">1,227 / 2,455 (50%)</td>
<td headers="stat_2" class="gt_row gt_center">953 / 1,903 (50%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    m</td>
<td headers="stat_1" class="gt_row gt_center">1,228 / 2,455 (50%)</td>
<td headers="stat_2" class="gt_row gt_center">950 / 1,903 (50%)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_1" class="gt_row gt_center">127</td>
<td headers="stat_2" class="gt_row gt_center">80</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="3"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> Mean (SD); n / N (%)</td>
    </tr>
  </tfoot>
</table>
</div>

``` r
data %>% select(age_years, temp) %>%
        tbl_summary(# indicate that you want to print multiple statistics 
                    type = all_continuous() ~ "continuous2",
                    statistic = all_continuous() ~ c(# line 1: mean and SD
                                                     "{mean} ({sd})",
                                                     # line 2: median and IQR
                                                     "{median} ({p25}, {p75})",
                                                     # line 3: min and max
                                                     "{min}, {max}"))
```


<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;N = 5,888&lt;/strong&gt;"><strong>N = 5,888</strong></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age_years</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Mean (SD)</td>
<td headers="stat_0" class="gt_row gt_center">16 (13)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Median (IQR)</td>
<td headers="stat_0" class="gt_row gt_center">13 (6, 23)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Range</td>
<td headers="stat_0" class="gt_row gt_center">0, 84</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">86</td></tr>
    <tr><td headers="label" class="gt_row gt_left">temp</td>
<td headers="stat_0" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Mean (SD)</td>
<td headers="stat_0" class="gt_row gt_center">38.56 (0.98)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Median (IQR)</td>
<td headers="stat_0" class="gt_row gt_center">38.80 (38.20, 39.20)</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Range</td>
<td headers="stat_0" class="gt_row gt_center">35.20, 40.80</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_0" class="gt_row gt_center">149</td></tr>
  </tbody>
  &#10;  
</table>
</div>

``` r
#rmarkdown::render()
```
