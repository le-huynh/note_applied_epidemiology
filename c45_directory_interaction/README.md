Directory interaction
================

``` r
library(here)
library(tidyverse)
```

### List files in directory

file name only

``` r
base::dir(here("data")) %>% head()
```

    ## [1] "20201007linelist.csv"         "africa_countries.geo.json"    "campylobacter_germany.xlsx"  
    ## [4] "case_linelist_2020-10-02.csv" "case_linelist_2020-10-03.csv" "case_linelist_2020-10-04.csv"

file path

``` r
base::list.files(here("data")) %>% head()
```

    ## [1] "20201007linelist.csv"         "africa_countries.geo.json"    "campylobacter_germany.xlsx"  
    ## [4] "case_linelist_2020-10-02.csv" "case_linelist_2020-10-03.csv" "case_linelist_2020-10-04.csv"

``` r
fs::dir_ls(here("data")) %>% head()
```

    ## G:/My Drive/git/note_applied_epidemiology/data/estimate_samples.rds
    ## G:/My Drive/git/note_applied_epidemiology/data/estimated_reported_cases_samples.rds
    ## G:/My Drive/git/note_applied_epidemiology/data/latest_date.rds
    ## G:/My Drive/git/note_applied_epidemiology/data/reported_cases.rds
    ## G:/My Drive/git/note_applied_epidemiology/data/summarised_estimated_reported_cases.rds
    ## G:/My Drive/git/note_applied_epidemiology/data/summarised_estimates.rds

all meta info

``` r
fs::dir_info(here("data"))
```

    ## # A tibble: 77 × 18
    ##    path            type     size permissions modification_time   user  group device_id hard_links special_device_id inode
    ##    <fs::path>      <fct> <fs::b> <fs::perms> <dttm>              <chr> <chr>     <dbl>      <dbl>             <dbl> <dbl>
    ##  1 …te_samples.rds file    7.15M rw-         2024-04-03 15:44:29 <NA>  <NA>  428019990          0                 0   683
    ##  2 …es_samples.rds file  358.23K rw-         2024-04-03 15:44:29 <NA>  <NA>  428019990          0                 0   684
    ##  3 …atest_date.rds file       80 rw-         2024-04-03 15:44:29 <NA>  <NA>  428019990          0                 0   685
    ##  4 …rted_cases.rds file    1.29K rw-         2024-04-03 15:44:29 <NA>  <NA>  428019990          0                 0   686
    ##  5 …rted_cases.rds file    8.06K rw-         2024-04-03 15:44:29 <NA>  <NA>  428019990          0                 0   687
    ##  6 …_estimates.rds file   92.13K rw-         2024-04-03 15:44:31 <NA>  <NA>  428019990          0                 0   688
    ##  7 …ta/summary.rds file      686 rw-         2024-04-03 15:44:32 <NA>  <NA>  428019990          0                 0   689
    ##  8 …_res_small.rds file  262.11K rw-         2024-04-03 15:44:33 <NA>  <NA>  428019990          0                 0   690
    ##  9 …epinow_res.rds file   10.13M rw-         2024-04-03 15:44:34 <NA>  <NA>  428019990          0                 0   691
    ## 10 …ation_time.rds file      144 rw-         2024-04-03 15:44:35 <NA>  <NA>  428019990          0                 0   692
    ## # ℹ 67 more rows
    ## # ℹ 7 more variables: block_size <dbl>, blocks <dbl>, flags <int>, generation <dbl>, access_time <dttm>,
    ## #   change_time <dttm>, birth_time <dttm>

### File information

``` r
base::file.info(here("data/20201007linelist.csv"))
```

    ##                                                                     size isdir mode               mtime
    ## G:/My Drive/git/note_applied_epidemiology/data/20201007linelist.csv    0 FALSE  666 2024-04-03 15:44:49
    ##                                                                                   ctime               atime exe
    ## G:/My Drive/git/note_applied_epidemiology/data/20201007linelist.csv 2024-04-03 15:44:49 2024-04-03 15:44:49  no

``` r
fs::file_info(here("data/20201007linelist.csv"))
```

    ## # A tibble: 1 × 18
    ##   path               type   size permissions modification_time   user  group device_id hard_links special_device_id inode
    ##   <fs::path>         <fct> <fs:> <fs::perms> <dttm>              <chr> <chr>     <dbl>      <dbl>             <dbl> <dbl>
    ## 1 …01007linelist.csv file      0 rw-         2024-04-03 15:44:49 <NA>  <NA>  428019990          0                 0   703
    ## # ℹ 7 more variables: block_size <dbl>, blocks <dbl>, flags <int>, generation <dbl>, access_time <dttm>,
    ## #   change_time <dttm>, birth_time <dttm>

### Check if exists

R object

``` r
#base::exists("object_name")
```

directory

``` r
base::file.exists(here("data"))
```

    ## [1] TRUE

``` r
fs::is_dir(here("data"))
```

    ## G:/My Drive/git/note_applied_epidemiology/data 
    ##                                           TRUE

file

``` r
base::file.exists(here("data/20201007linelist.csv"))
```

    ## [1] TRUE

``` r
fs::is_file(here("data/20201007linelist.csv"))
```

    ## G:/My Drive/git/note_applied_epidemiology/data/20201007linelist.csv 
    ##                                                                TRUE

### Create

directory

``` r
# existed dir
base::dir.create(here("data"))
```

    ## Warning in base::dir.create(here("data")): 'G:\My Drive\git\note_applied_epidemiology\data' already exists

``` r
# non-existed dir
base::dir.create(here("my_dir"))

fs::dir_create(here("my_dir"))
```

file

``` r
base::file.create(here("test.rds"))
```

    ## [1] TRUE

``` r
fs::file_create(here("test.rds"))
```

### Delete

``` r
# R object
rm()

# directory
fs::dir_delete(here("my_dir"))

# file
fs::file_delete(here("test.rds"))


# rmarkdown::render()
```
