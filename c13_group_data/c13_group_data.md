Grouping Data
================

``` r
pacman::p_load(
        rio,        # importing data  
        here,       # relative file pathways  
        janitor,    # data cleaning and tables
        tidyverse   # data management and visualization
)
```

### Import data

``` r
data <- rio::import(here("data/linelist_cleaned.rds"))
```

### Grouping

`tally()`

``` r
data %>% group_by(outcome) %>% group_keys()
```

    ## # A tibble: 3 × 1
    ##   outcome
    ##   <chr>  
    ## 1 Death  
    ## 2 Recover
    ## 3 <NA>

``` r
data %>% group_by(outcome) %>% tally()
```

    ## # A tibble: 3 × 2
    ##   outcome     n
    ##   <chr>   <int>
    ## 1 Death    2582
    ## 2 Recover  1983
    ## 3 <NA>     1323

``` r
data %>% group_by(outcome, gender) %>% tally()
```

    ## # A tibble: 9 × 3
    ## # Groups:   outcome [3]
    ##   outcome gender     n
    ##   <chr>   <chr>  <int>
    ## 1 Death   f       1227
    ## 2 Death   m       1228
    ## 3 Death   <NA>     127
    ## 4 Recover f        953
    ## 5 Recover m        950
    ## 6 Recover <NA>      80
    ## 7 <NA>    f        627
    ## 8 <NA>    m        625
    ## 9 <NA>    <NA>      71

New columns

``` r
data %>% mutate(age_class = ifelse(age >= 18,
                                   "adult",
                                   "child")) %>%
        group_by(age_class) %>%
        tally()
```

    ## # A tibble: 3 × 2
    ##   age_class     n
    ##   <chr>     <int>
    ## 1 adult      2184
    ## 2 child      3618
    ## 3 <NA>         86

``` r
data %>% group_by(age_class = ifelse(age >= 18,
                                     "adult",
                                     "child")) %>%
        tally()
```

    ## # A tibble: 3 × 2
    ##   age_class     n
    ##   <chr>     <int>
    ## 1 adult      2184
    ## 2 child      3618
    ## 3 <NA>         86

Add/drop grouping columns

``` r
# group by outcome
(df <- data %>% group_by(outcome))
```

    ## # A tibble: 5,888 × 30
    ## # Groups:   outcome [3]
    ##    case_id generation date_infection date_onset date_hospitalisation date_outcome outcome gender   age
    ##    <chr>        <dbl> <date>         <date>     <date>               <date>       <chr>   <chr>  <dbl>
    ##  1 5fe599           4 2014-05-08     2014-05-13 2014-05-15           NA           <NA>    m          2
    ##  2 8689b7           4 NA             2014-05-13 2014-05-14           2014-05-18   Recover f          3
    ##  3 11f8ea           2 NA             2014-05-16 2014-05-18           2014-05-30   Recover m         56
    ##  4 b8812a           3 2014-05-04     2014-05-18 2014-05-20           NA           <NA>    f         18
    ##  5 893f25           3 2014-05-18     2014-05-21 2014-05-22           2014-05-29   Recover m          3
    ##  6 be99c8           3 2014-05-03     2014-05-22 2014-05-23           2014-05-24   Recover f         16
    ##  7 07e3e8           4 2014-05-22     2014-05-27 2014-05-29           2014-06-01   Recover f         16
    ##  8 369449           4 2014-05-28     2014-06-02 2014-06-03           2014-06-07   Death   f          0
    ##  9 f393b4           4 NA             2014-06-05 2014-06-06           2014-06-18   Recover m         61
    ## 10 1389ca           4 NA             2014-06-05 2014-06-07           2014-06-09   Death   f         27
    ## # ℹ 5,878 more rows
    ## # ℹ 21 more variables: age_unit <chr>, age_years <dbl>, age_cat <fct>, age_cat5 <fct>, hospital <chr>,
    ## #   lon <dbl>, lat <dbl>, infector <chr>, source <chr>, wt_kg <dbl>, ht_cm <dbl>, ct_blood <dbl>,
    ## #   fever <chr>, chills <chr>, cough <chr>, aches <chr>, vomit <chr>, temp <dbl>, time_admission <chr>,
    ## #   bmi <dbl>, days_onset_hosp <dbl>

``` r
# add grouping by gender
df %>% group_by(gender)
```

    ## # A tibble: 5,888 × 30
    ## # Groups:   gender [3]
    ##    case_id generation date_infection date_onset date_hospitalisation date_outcome outcome gender   age
    ##    <chr>        <dbl> <date>         <date>     <date>               <date>       <chr>   <chr>  <dbl>
    ##  1 5fe599           4 2014-05-08     2014-05-13 2014-05-15           NA           <NA>    m          2
    ##  2 8689b7           4 NA             2014-05-13 2014-05-14           2014-05-18   Recover f          3
    ##  3 11f8ea           2 NA             2014-05-16 2014-05-18           2014-05-30   Recover m         56
    ##  4 b8812a           3 2014-05-04     2014-05-18 2014-05-20           NA           <NA>    f         18
    ##  5 893f25           3 2014-05-18     2014-05-21 2014-05-22           2014-05-29   Recover m          3
    ##  6 be99c8           3 2014-05-03     2014-05-22 2014-05-23           2014-05-24   Recover f         16
    ##  7 07e3e8           4 2014-05-22     2014-05-27 2014-05-29           2014-06-01   Recover f         16
    ##  8 369449           4 2014-05-28     2014-06-02 2014-06-03           2014-06-07   Death   f          0
    ##  9 f393b4           4 NA             2014-06-05 2014-06-06           2014-06-18   Recover m         61
    ## 10 1389ca           4 NA             2014-06-05 2014-06-07           2014-06-09   Death   f         27
    ## # ℹ 5,878 more rows
    ## # ℹ 21 more variables: age_unit <chr>, age_years <dbl>, age_cat <fct>, age_cat5 <fct>, hospital <chr>,
    ## #   lon <dbl>, lat <dbl>, infector <chr>, source <chr>, wt_kg <dbl>, ht_cm <dbl>, ct_blood <dbl>,
    ## #   fever <chr>, chills <chr>, cough <chr>, aches <chr>, vomit <chr>, temp <dbl>, time_admission <chr>,
    ## #   bmi <dbl>, days_onset_hosp <dbl>

``` r
df %>% group_by(gender, .add = TRUE)
```

    ## # A tibble: 5,888 × 30
    ## # Groups:   outcome, gender [9]
    ##    case_id generation date_infection date_onset date_hospitalisation date_outcome outcome gender   age
    ##    <chr>        <dbl> <date>         <date>     <date>               <date>       <chr>   <chr>  <dbl>
    ##  1 5fe599           4 2014-05-08     2014-05-13 2014-05-15           NA           <NA>    m          2
    ##  2 8689b7           4 NA             2014-05-13 2014-05-14           2014-05-18   Recover f          3
    ##  3 11f8ea           2 NA             2014-05-16 2014-05-18           2014-05-30   Recover m         56
    ##  4 b8812a           3 2014-05-04     2014-05-18 2014-05-20           NA           <NA>    f         18
    ##  5 893f25           3 2014-05-18     2014-05-21 2014-05-22           2014-05-29   Recover m          3
    ##  6 be99c8           3 2014-05-03     2014-05-22 2014-05-23           2014-05-24   Recover f         16
    ##  7 07e3e8           4 2014-05-22     2014-05-27 2014-05-29           2014-06-01   Recover f         16
    ##  8 369449           4 2014-05-28     2014-06-02 2014-06-03           2014-06-07   Death   f          0
    ##  9 f393b4           4 NA             2014-06-05 2014-06-06           2014-06-18   Recover m         61
    ## 10 1389ca           4 NA             2014-06-05 2014-06-07           2014-06-09   Death   f         27
    ## # ℹ 5,878 more rows
    ## # ℹ 21 more variables: age_unit <chr>, age_years <dbl>, age_cat <fct>, age_cat5 <fct>, hospital <chr>,
    ## #   lon <dbl>, lat <dbl>, infector <chr>, source <chr>, wt_kg <dbl>, ht_cm <dbl>, ct_blood <dbl>,
    ## #   fever <chr>, chills <chr>, cough <chr>, aches <chr>, vomit <chr>, temp <dbl>, time_admission <chr>,
    ## #   bmi <dbl>, days_onset_hosp <dbl>

### count() vs tally()

`tally()` \<= `summarise(n = n())`

``` r
data %>% tally()
```

    ##      n
    ## 1 5888

``` r
data %>% group_by(fever) %>% tally()
```

    ## # A tibble: 3 × 2
    ##   fever     n
    ##   <chr> <int>
    ## 1 no     1090
    ## 2 yes    4549
    ## 3 <NA>    249

``` r
data %>% group_by(fever) %>% tally(sort = TRUE)
```

    ## # A tibble: 3 × 2
    ##   fever     n
    ##   <chr> <int>
    ## 1 yes    4549
    ## 2 no     1090
    ## 3 <NA>    249

`count()` \<= `group_by()` –\> `summarise()` –\> `ungroup()`

``` r
data %>% count(fever)
```

    ##   fever    n
    ## 1    no 1090
    ## 2   yes 4549
    ## 3  <NA>  249

summarize the number of hospitals present for each gender

``` r
data %>% count(hospital, gender) %>%
        count(gender, name = "hospitals per gender")
```

    ##   gender hospitals per gender
    ## 1      f                    6
    ## 2      m                    6
    ## 3   <NA>                    6

`add_count()`: add a new column `n` with the counts of rows per group

``` r
data %>% add_count(hospital) %>% 
        select(hospital, n, everything()) %>%
        tibble()
```

    ## # A tibble: 5,888 × 31
    ##    hospital         n case_id generation date_infection date_onset date_hospitalisation date_outcome outcome
    ##    <chr>        <int> <chr>        <dbl> <date>         <date>     <date>               <date>       <chr>  
    ##  1 Other          885 5fe599           4 2014-05-08     2014-05-13 2014-05-15           NA           <NA>   
    ##  2 Missing       1469 8689b7           4 NA             2014-05-13 2014-05-14           2014-05-18   Recover
    ##  3 St. Mark's …   422 11f8ea           2 NA             2014-05-16 2014-05-18           2014-05-30   Recover
    ##  4 Port Hospit…  1762 b8812a           3 2014-05-04     2014-05-18 2014-05-20           NA           <NA>   
    ##  5 Military Ho…   896 893f25           3 2014-05-18     2014-05-21 2014-05-22           2014-05-29   Recover
    ##  6 Port Hospit…  1762 be99c8           3 2014-05-03     2014-05-22 2014-05-23           2014-05-24   Recover
    ##  7 Missing       1469 07e3e8           4 2014-05-22     2014-05-27 2014-05-29           2014-06-01   Recover
    ##  8 Missing       1469 369449           4 2014-05-28     2014-06-02 2014-06-03           2014-06-07   Death  
    ##  9 Missing       1469 f393b4           4 NA             2014-06-05 2014-06-06           2014-06-18   Recover
    ## 10 Missing       1469 1389ca           4 NA             2014-06-05 2014-06-07           2014-06-09   Death  
    ## # ℹ 5,878 more rows
    ## # ℹ 22 more variables: gender <chr>, age <dbl>, age_unit <chr>, age_years <dbl>, age_cat <fct>,
    ## #   age_cat5 <fct>, lon <dbl>, lat <dbl>, infector <chr>, source <chr>, wt_kg <dbl>, ht_cm <dbl>,
    ## #   ct_blood <dbl>, fever <chr>, chills <chr>, cough <chr>, aches <chr>, vomit <chr>, temp <dbl>,
    ## #   time_admission <chr>, bmi <dbl>, days_onset_hosp <dbl>

`add_total()`: add total sum rows/columns after `tally()` or `count()`

``` r
# cross-tabulate counts of two columns
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

``` r
data %>% janitor::tabyl(age_cat, gender) %>%
        # add total row
        adorn_totals(where = "row")
```

    ##  age_cat    f    m NA_
    ##      0-4  640  416  39
    ##      5-9  641  412  42
    ##    10-14  518  383  40
    ##    15-19  359  364  20
    ##    20-29  468  575  30
    ##    30-49  179  557  18
    ##    50-69    2   91   2
    ##      70+    0    5   1
    ##     <NA>    0    0  86
    ##    Total 2807 2803 278

``` r
data %>% janitor::tabyl(age_cat, gender) %>%
        # add total column
        adorn_totals(where = "col")
```

    ##  age_cat   f   m NA_ Total
    ##      0-4 640 416  39  1095
    ##      5-9 641 412  42  1095
    ##    10-14 518 383  40   941
    ##    15-19 359 364  20   743
    ##    20-29 468 575  30  1073
    ##    30-49 179 557  18   754
    ##    50-69   2  91   2    95
    ##      70+   0   5   1     6
    ##     <NA>   0   0  86    86

``` r
data %>% janitor::tabyl(age_cat, gender) %>%
        adorn_totals(where = "col") %>%
        # convert to proportions with column denominator
        adorn_percentages(denominator = "col")
```

    ##  age_cat            f           m         NA_       Total
    ##      0-4 0.2280014250 0.148412415 0.140287770 0.185971467
    ##      5-9 0.2283576772 0.146985373 0.151079137 0.185971467
    ##    10-14 0.1845386534 0.136639315 0.143884892 0.159816576
    ##    15-19 0.1278945493 0.129860863 0.071942446 0.126188859
    ##    20-29 0.1667260420 0.205137353 0.107913669 0.182235054
    ##    30-49 0.0637691486 0.198715662 0.064748201 0.128057065
    ##    50-69 0.0007125045 0.032465216 0.007194245 0.016134511
    ##      70+ 0.0000000000 0.001783803 0.003597122 0.001019022
    ##     <NA> 0.0000000000 0.000000000 0.309352518 0.014605978

``` r
data %>% janitor::tabyl(age_cat, gender) %>%
        adorn_totals(where = "col") %>%
        adorn_percentages(denominator = "col") %>%
        # convert proportions to percents
        adorn_pct_formatting() 
```

    ##  age_cat     f     m   NA_ Total
    ##      0-4 22.8% 14.8% 14.0% 18.6%
    ##      5-9 22.8% 14.7% 15.1% 18.6%
    ##    10-14 18.5% 13.7% 14.4% 16.0%
    ##    15-19 12.8% 13.0%  7.2% 12.6%
    ##    20-29 16.7% 20.5% 10.8% 18.2%
    ##    30-49  6.4% 19.9%  6.5% 12.8%
    ##    50-69  0.1%  3.2%  0.7%  1.6%
    ##      70+  0.0%  0.2%  0.4%  0.1%
    ##     <NA>  0.0%  0.0% 30.9%  1.5%

``` r
data %>% janitor::tabyl(age_cat, gender) %>%
        adorn_totals(where = "col") %>%
        adorn_percentages(denominator = "col") %>%
        adorn_pct_formatting() %>%
        # display as: "(count) percent"
        adorn_ns(position = "rear") %>%
        # adjust titles
        adorn_title(row_name = "Age Category",
                    col_name = "Gender")
```

    ##                    Gender                                     
    ##  Age Category           f           m        NA_         Total
    ##           0-4 22.8% (640) 14.8% (416) 14.0% (39) 18.6% (1,095)
    ##           5-9 22.8% (641) 14.7% (412) 15.1% (42) 18.6% (1,095)
    ##         10-14 18.5% (518) 13.7% (383) 14.4% (40) 16.0%   (941)
    ##         15-19 12.8% (359) 13.0% (364)  7.2% (20) 12.6%   (743)
    ##         20-29 16.7% (468) 20.5% (575) 10.8% (30) 18.2% (1,073)
    ##         30-49  6.4% (179) 19.9% (557)  6.5% (18) 12.8%   (754)
    ##         50-69  0.1%   (2)  3.2%  (91)  0.7%  (2)  1.6%    (95)
    ##           70+  0.0%   (0)  0.2%   (5)  0.4%  (1)  0.1%     (6)
    ##          <NA>  0.0%   (0)  0.0%   (0) 30.9% (86)  1.5%    (86)

### Filter on grouped data

``` r
data %>% group_by(hospital) %>%
        # arrange data_hospitalisation from latest to earliest within each group
        arrange(hospital, date_hospitalisation) %>% 
        # slice first 5 rows from each hospital
        slice_head(n = 5) %>% 
        arrange(hospital) %>%
        select(case_id, hospital, date_hospitalisation)
```

    ## # A tibble: 30 × 3
    ## # Groups:   hospital [6]
    ##    case_id hospital          date_hospitalisation
    ##    <chr>   <chr>             <date>              
    ##  1 20b688  Central Hospital  2014-05-06          
    ##  2 d58402  Central Hospital  2014-05-10          
    ##  3 b8f2fd  Central Hospital  2014-05-13          
    ##  4 acf422  Central Hospital  2014-05-28          
    ##  5 275cc7  Central Hospital  2014-05-28          
    ##  6 d1fafd  Military Hospital 2014-04-17          
    ##  7 974bc1  Military Hospital 2014-05-13          
    ##  8 6a9004  Military Hospital 2014-05-13          
    ##  9 09e386  Military Hospital 2014-05-14          
    ## 10 865581  Military Hospital 2014-05-15          
    ## # ℹ 20 more rows

``` r
data %>% add_count(hospital) %>% 
        filter(n < 500) %>% 
        select(hospital, n) %>%
        head(15)
```

    ##                                hospital   n
    ## 1  St. Mark's Maternity Hospital (SMMH) 422
    ## 2  St. Mark's Maternity Hospital (SMMH) 422
    ## 3  St. Mark's Maternity Hospital (SMMH) 422
    ## 4                      Central Hospital 454
    ## 5                      Central Hospital 454
    ## 6                      Central Hospital 454
    ## 7  St. Mark's Maternity Hospital (SMMH) 422
    ## 8  St. Mark's Maternity Hospital (SMMH) 422
    ## 9  St. Mark's Maternity Hospital (SMMH) 422
    ## 10                     Central Hospital 454
    ## 11                     Central Hospital 454
    ## 12                     Central Hospital 454
    ## 13                     Central Hospital 454
    ## 14                     Central Hospital 454
    ## 15                     Central Hospital 454

### Mutate on grouped data

``` r
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
```

    ## # A tibble: 5,888 × 5
    ## # Groups:   hospital [6]
    ##    case_id hospital                             days_onset_hosp group_delay_admit diff_to_group
    ##    <chr>   <chr>                                          <dbl>             <dbl>         <dbl>
    ##  1 5fe599  Other                                              2              2.05         -0.05
    ##  2 8689b7  Missing                                            1              2.08         -1.08
    ##  3 11f8ea  St. Mark's Maternity Hospital (SMMH)               2              2.08         -0.08
    ##  4 b8812a  Port Hospital                                      2              2.05         -0.05
    ##  5 893f25  Military Hospital                                  1              2.12         -1.12
    ##  6 be99c8  Port Hospital                                      1              2.05         -1.05
    ##  7 07e3e8  Missing                                            2              2.08         -0.08
    ##  8 369449  Missing                                            1              2.08         -1.08
    ##  9 f393b4  Missing                                            1              2.08         -1.08
    ## 10 1389ca  Missing                                            2              2.08         -0.08
    ## # ℹ 5,878 more rows

``` r
# rmarkdown::render()
```
