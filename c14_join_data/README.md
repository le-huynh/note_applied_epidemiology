Joining Data
================

``` r
pacman::p_load(
        rio,            # import and export
        here,           # locate files 
        tidyverse,      # data management and visualisation
        RecordLinkage,  # probabilistic matches
        fastLink        # probabilistic matches)
)
```

### Import data

``` r
data <- rio::import(here("data/linelist_cleaned.rds"))

# subset of data
(data_mini <- data %>% 
        select(case_id, date_onset, hospital) %>%
        head(10))
```

    ##    case_id date_onset                             hospital
    ## 1   5fe599 2014-05-13                                Other
    ## 2   8689b7 2014-05-13                              Missing
    ## 3   11f8ea 2014-05-16 St. Mark's Maternity Hospital (SMMH)
    ## 4   b8812a 2014-05-18                        Port Hospital
    ## 5   893f25 2014-05-21                    Military Hospital
    ## 6   be99c8 2014-05-22                        Port Hospital
    ## 7   07e3e8 2014-05-27                              Missing
    ## 8   369449 2014-06-02                              Missing
    ## 9   f393b4 2014-06-05                              Missing
    ## 10  1389ca 2014-06-05                              Missing

``` r
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
```

    ##          hosp_name catchment_pop     level
    ## 1 central hospital       1950280  Tertiary
    ## 2         military         40500 Secondary
    ## 3         military         10000   Primary
    ## 4             port         50280 Secondary
    ## 5       St. Mark's         12000 Secondary
    ## 6           ignace          5000   Primary
    ## 7          sisters          4200   Primary

### Pre-cleaning

Match hospital names in 2 dataframes

``` r
data_mini %>% count(hospital)
```

    ##                               hospital n
    ## 1                    Military Hospital 1
    ## 2                              Missing 5
    ## 3                                Other 1
    ## 4                        Port Hospital 2
    ## 5 St. Mark's Maternity Hospital (SMMH) 1

``` r
hosp_info %>% count(hosp_name)
```

    ##          hosp_name n
    ## 1       St. Mark's 1
    ## 2 central hospital 1
    ## 3           ignace 1
    ## 4         military 2
    ## 5             port 1
    ## 6          sisters 1

``` r
hosp_info %>% 
        mutate(hosp_name_new = case_when(
                hosp_name == "military" ~ "Military Hospital",
                hosp_name == "port" ~ "Port Hospital",
                hosp_name == "St. Mark's" ~ "St. Mark's Maternity Hospital (SMMH)",
                hosp_name == "central hospital" ~ "Central Hospital",
                TRUE ~ hosp_name)) %>%
        select(hosp_name, hosp_name_new)
```

    ##          hosp_name                        hosp_name_new
    ## 1 central hospital                     Central Hospital
    ## 2         military                    Military Hospital
    ## 3         military                    Military Hospital
    ## 4             port                        Port Hospital
    ## 5       St. Mark's St. Mark's Maternity Hospital (SMMH)
    ## 6           ignace                               ignace
    ## 7          sisters                              sisters

``` r
(hosp_df <- hosp_info %>% 
        mutate(hosp_name = case_when(
                hosp_name == "military" ~ "Military Hospital",
                hosp_name == "port" ~ "Port Hospital",
                hosp_name == "St. Mark's" ~ "St. Mark's Maternity Hospital (SMMH)",
                hosp_name == "central hospital" ~ "Central Hospital",
                TRUE ~ hosp_name)))
```

    ##                              hosp_name catchment_pop     level
    ## 1                     Central Hospital       1950280  Tertiary
    ## 2                    Military Hospital         40500 Secondary
    ## 3                    Military Hospital         10000   Primary
    ## 4                        Port Hospital         50280 Secondary
    ## 5 St. Mark's Maternity Hospital (SMMH)         12000 Secondary
    ## 6                               ignace          5000   Primary
    ## 7                              sisters          4200   Primary

### `dplyr::*_join()`

``` r
data_mini %>% left_join(hosp_df,
                        by = c("hospital" = "hosp_name"))
```

    ## Warning in left_join(., hosp_df, by = c(hospital = "hosp_name")): Detected an unexpected many-to-many relationship between `x` and `y`.
    ## ℹ Row 5 of `x` matches multiple rows in `y`.
    ## ℹ Row 4 of `y` matches multiple rows in `x`.
    ## ℹ If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this
    ##   warning.

    ##    case_id date_onset                             hospital catchment_pop     level
    ## 1   5fe599 2014-05-13                                Other            NA      <NA>
    ## 2   8689b7 2014-05-13                              Missing            NA      <NA>
    ## 3   11f8ea 2014-05-16 St. Mark's Maternity Hospital (SMMH)         12000 Secondary
    ## 4   b8812a 2014-05-18                        Port Hospital         50280 Secondary
    ## 5   893f25 2014-05-21                    Military Hospital         40500 Secondary
    ## 6   893f25 2014-05-21                    Military Hospital         10000   Primary
    ## 7   be99c8 2014-05-22                        Port Hospital         50280 Secondary
    ## 8   07e3e8 2014-05-27                              Missing            NA      <NA>
    ## 9   369449 2014-06-02                              Missing            NA      <NA>
    ## 10  f393b4 2014-06-05                              Missing            NA      <NA>
    ## 11  1389ca 2014-06-05                              Missing            NA      <NA>

``` r
data_mini %>% full_join(hosp_df,
                        by = c("hospital" = "hosp_name"))
```

    ## Warning in full_join(., hosp_df, by = c(hospital = "hosp_name")): Detected an unexpected many-to-many relationship between `x` and `y`.
    ## ℹ Row 5 of `x` matches multiple rows in `y`.
    ## ℹ Row 4 of `y` matches multiple rows in `x`.
    ## ℹ If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this
    ##   warning.

    ##    case_id date_onset                             hospital catchment_pop     level
    ## 1   5fe599 2014-05-13                                Other            NA      <NA>
    ## 2   8689b7 2014-05-13                              Missing            NA      <NA>
    ## 3   11f8ea 2014-05-16 St. Mark's Maternity Hospital (SMMH)         12000 Secondary
    ## 4   b8812a 2014-05-18                        Port Hospital         50280 Secondary
    ## 5   893f25 2014-05-21                    Military Hospital         40500 Secondary
    ## 6   893f25 2014-05-21                    Military Hospital         10000   Primary
    ## 7   be99c8 2014-05-22                        Port Hospital         50280 Secondary
    ## 8   07e3e8 2014-05-27                              Missing            NA      <NA>
    ## 9   369449 2014-06-02                              Missing            NA      <NA>
    ## 10  f393b4 2014-06-05                              Missing            NA      <NA>
    ## 11  1389ca 2014-06-05                              Missing            NA      <NA>
    ## 12    <NA>       <NA>                     Central Hospital       1950280  Tertiary
    ## 13    <NA>       <NA>                               ignace          5000   Primary
    ## 14    <NA>       <NA>                              sisters          4200   Primary

``` r
data_mini %>% inner_join(hosp_df,
                         by = c("hospital" = "hosp_name"))
```

    ## Warning in inner_join(., hosp_df, by = c(hospital = "hosp_name")): Detected an unexpected many-to-many relationship between `x` and `y`.
    ## ℹ Row 5 of `x` matches multiple rows in `y`.
    ## ℹ Row 4 of `y` matches multiple rows in `x`.
    ## ℹ If a many-to-many relationship is expected, set `relationship = "many-to-many"` to silence this
    ##   warning.

    ##   case_id date_onset                             hospital catchment_pop     level
    ## 1  11f8ea 2014-05-16 St. Mark's Maternity Hospital (SMMH)         12000 Secondary
    ## 2  b8812a 2014-05-18                        Port Hospital         50280 Secondary
    ## 3  893f25 2014-05-21                    Military Hospital         40500 Secondary
    ## 4  893f25 2014-05-21                    Military Hospital         10000   Primary
    ## 5  be99c8 2014-05-22                        Port Hospital         50280 Secondary

``` r
data_mini %>% semi_join(hosp_df,
                        by = c("hospital" = "hosp_name"))
```

    ##   case_id date_onset                             hospital
    ## 1  11f8ea 2014-05-16 St. Mark's Maternity Hospital (SMMH)
    ## 2  b8812a 2014-05-18                        Port Hospital
    ## 3  893f25 2014-05-21                    Military Hospital
    ## 4  be99c8 2014-05-22                        Port Hospital

``` r
hosp_df %>% semi_join(data_mini,
                      by = c("hosp_name" = "hospital"))
```

    ##                              hosp_name catchment_pop     level
    ## 1                    Military Hospital         40500 Secondary
    ## 2                    Military Hospital         10000   Primary
    ## 3                        Port Hospital         50280 Secondary
    ## 4 St. Mark's Maternity Hospital (SMMH)         12000 Secondary

``` r
hosp_df %>% anti_join(data_mini,
                        by = c("hosp_name" = "hospital"))
```

    ##          hosp_name catchment_pop    level
    ## 1 Central Hospital       1950280 Tertiary
    ## 2           ignace          5000  Primary
    ## 3          sisters          4200  Primary

### Probabilistic matching

Example datasets

``` r
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
```

    ## # A tibble: 9 × 8
    ##   gender first     middle    last          yr   mon   day district
    ##   <chr>  <chr>     <chr>     <chr>      <dbl> <dbl> <dbl> <chr>   
    ## 1 M      Amir      <NA>      Khan        1989    11    22 River   
    ## 2 M      Anthony   B.        Smith       1970     9    19 River   
    ## 3 F      Marialisa Contreras Rodrigues   1972     4    15 River   
    ## 4 F      Elizabeth Casteel   Chase       1954     3     3 City    
    ## 5 M      Jose      Sanchez   Lopez       1996     1     6 City    
    ## 6 F      Cassidy   Jones     Davis       1980     7    20 City    
    ## 7 M      Michael   Murphy    O'Calaghan  1969     4    12 Rural   
    ## 8 M      Oliver    Laurent   De Bordow   1971     2     4 River   
    ## 9 F      Blessing  <NA>      Adebayo     1955     2    14 Rural

``` r
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
```

    ## # A tibble: 14 × 9
    ##    gender first    middle    last           yr   mon   day district result  
    ##    <chr>  <chr>    <chr>     <chr>       <dbl> <dbl> <dbl> <chr>    <chr>   
    ##  1 M      Amir     <NA>      Khan         1989    11    22 River    positive
    ##  2 M      Tony     B         Smith        1970     9    19 River    positive
    ##  3 F      Maria    Contreras Rodriguez    1972     4    15 Cty      negative
    ##  4 F      Betty    Castel    Chase        1954     3    30 City     positive
    ##  5 F      Andrea   <NA>      Kumaraswamy  2001     1     5 Rural    positive
    ##  6 F      Caroline <NA>      Wang         1988    12    11 Rural    negative
    ##  7 F      Trang    <NA>      Nguyen       1981     6    10 Rural    positive
    ##  8 M      Olivier  Laurent   De Bordeaux    NA    NA    NA River    positive
    ##  9 M      Mike     Murphy    O'Callaghan  1969     4    12 Rural    negative
    ## 10 F      Cassidy  Jones     Davis        1980     7     2 City     positive
    ## 11 M      Mohammad <NA>      Ali          1942     1    17 City     negative
    ## 12 <NA>   Jose     Sanchez   Lopez        1995     1     6 City     negative
    ## 13 M      Abubakar <NA>      Abullahi     1960     1     1 River    positive
    ## 14 F      Maria    Salinas   Contreras    1955     3     3 River    positive

Match the data on string distance across the name and district columns,
and on numeric distance for year, month, and day of birth. Match
threshold of 95% probability.

``` r
fl_output <- fastLink::fastLink(
        dfA = cases,
        dfB = results,
        varnames = c("gender", "first", "middle", "last", "yr", "mon", "day", "district"),
        stringdist.match = c("first", "middle", "last", "district"),
        numeric.match = c("yr", "mon", "day"),
        threshold.match = 0.95)
```

    ## 
    ## ==================== 
    ## fastLink(): Fast Probabilistic Record Linkage
    ## ==================== 
    ## 
    ## If you set return.all to FALSE, you will not be able to calculate a confusion table as a summary statistic.
    ## Calculating matches for each variable.
    ## Getting counts for parameter estimation.
    ##     Parallelizing calculation using OpenMP. 1 threads out of 8 are used.
    ## Running the EM algorithm.
    ## Getting the indices of estimated matches.
    ##     Parallelizing calculation using OpenMP. 1 threads out of 8 are used.
    ## Deduping the estimated matches.
    ## Getting the match patterns for each estimated match.

`matches` df: most likely matches across `cases` and `results` (row
index)

``` r
(my_matches <- fl_output$matches)
```

    ##   inds.a inds.b
    ## 1      1      1
    ## 2      2      2
    ## 3      3      3
    ## 4      4      4
    ## 5      8      8
    ## 6      7      9
    ## 7      6     10
    ## 8      5     12

Clean data prior to joining

``` r
# convert cases rownames to a column 
(cases_clean <- cases %>% rownames_to_column())
```

    ## # A tibble: 9 × 9
    ##   rowname gender first     middle    last          yr   mon   day district
    ##   <chr>   <chr>  <chr>     <chr>     <chr>      <dbl> <dbl> <dbl> <chr>   
    ## 1 1       M      Amir      <NA>      Khan        1989    11    22 River   
    ## 2 2       M      Anthony   B.        Smith       1970     9    19 River   
    ## 3 3       F      Marialisa Contreras Rodrigues   1972     4    15 River   
    ## 4 4       F      Elizabeth Casteel   Chase       1954     3     3 City    
    ## 5 5       M      Jose      Sanchez   Lopez       1996     1     6 City    
    ## 6 6       F      Cassidy   Jones     Davis       1980     7    20 City    
    ## 7 7       M      Michael   Murphy    O'Calaghan  1969     4    12 Rural   
    ## 8 8       M      Oliver    Laurent   De Bordow   1971     2     4 River   
    ## 9 9       F      Blessing  <NA>      Adebayo     1955     2    14 Rural

``` r
# convert test_results rownames to a column
(results_clean <- results %>% rownames_to_column())
```

    ## # A tibble: 14 × 10
    ##    rowname gender first    middle    last           yr   mon   day district result  
    ##    <chr>   <chr>  <chr>    <chr>     <chr>       <dbl> <dbl> <dbl> <chr>    <chr>   
    ##  1 1       M      Amir     <NA>      Khan         1989    11    22 River    positive
    ##  2 2       M      Tony     B         Smith        1970     9    19 River    positive
    ##  3 3       F      Maria    Contreras Rodriguez    1972     4    15 Cty      negative
    ##  4 4       F      Betty    Castel    Chase        1954     3    30 City     positive
    ##  5 5       F      Andrea   <NA>      Kumaraswamy  2001     1     5 Rural    positive
    ##  6 6       F      Caroline <NA>      Wang         1988    12    11 Rural    negative
    ##  7 7       F      Trang    <NA>      Nguyen       1981     6    10 Rural    positive
    ##  8 8       M      Olivier  Laurent   De Bordeaux    NA    NA    NA River    positive
    ##  9 9       M      Mike     Murphy    O'Callaghan  1969     4    12 Rural    negative
    ## 10 10      F      Cassidy  Jones     Davis        1980     7     2 City     positive
    ## 11 11      M      Mohammad <NA>      Ali          1942     1    17 City     negative
    ## 12 12      <NA>   Jose     Sanchez   Lopez        1995     1     6 City     negative
    ## 13 13      M      Abubakar <NA>      Abullahi     1960     1     1 River    positive
    ## 14 14      F      Maria    Salinas   Contreras    1955     3     3 River    positive

``` r
# convert all columns in matches dataset to character, so they can be joined to the rownames
(matches_clean <- my_matches %>%
        mutate(across(everything(), as.character)))
```

    ##   inds.a inds.b
    ## 1      1      1
    ## 2      2      2
    ## 3      3      3
    ## 4      4      4
    ## 5      8      8
    ## 6      7      9
    ## 7      6     10
    ## 8      5     12

Join matches to dfA, then add dfB

``` r
# column "inds.b" is added to dfA
(complete <- left_join(cases_clean,
                      matches_clean,
                      by = c("rowname" = "inds.a")))
```

    ## # A tibble: 9 × 10
    ##   rowname gender first     middle    last          yr   mon   day district inds.b
    ##   <chr>   <chr>  <chr>     <chr>     <chr>      <dbl> <dbl> <dbl> <chr>    <chr> 
    ## 1 1       M      Amir      <NA>      Khan        1989    11    22 River    1     
    ## 2 2       M      Anthony   B.        Smith       1970     9    19 River    2     
    ## 3 3       F      Marialisa Contreras Rodrigues   1972     4    15 River    3     
    ## 4 4       F      Elizabeth Casteel   Chase       1954     3     3 City     4     
    ## 5 5       M      Jose      Sanchez   Lopez       1996     1     6 City     12    
    ## 6 6       F      Cassidy   Jones     Davis       1980     7    20 City     10    
    ## 7 7       M      Michael   Murphy    O'Calaghan  1969     4    12 Rural    9     
    ## 8 8       M      Oliver    Laurent   De Bordow   1971     2     4 River    8     
    ## 9 9       F      Blessing  <NA>      Adebayo     1955     2    14 Rural    <NA>

``` r
# column(s) from dfB are added 
(complete <- left_join(complete,
                      results_clean,
                      by = c("inds.b" = "rowname")))
```

    ## # A tibble: 9 × 19
    ##   rowname gender.x first.x   middle.x  last.x    yr.x mon.x day.x district.x inds.b gender.y first.y
    ##   <chr>   <chr>    <chr>     <chr>     <chr>    <dbl> <dbl> <dbl> <chr>      <chr>  <chr>    <chr>  
    ## 1 1       M        Amir      <NA>      Khan      1989    11    22 River      1      M        Amir   
    ## 2 2       M        Anthony   B.        Smith     1970     9    19 River      2      M        Tony   
    ## 3 3       F        Marialisa Contreras Rodrigu…  1972     4    15 River      3      F        Maria  
    ## 4 4       F        Elizabeth Casteel   Chase     1954     3     3 City       4      F        Betty  
    ## 5 5       M        Jose      Sanchez   Lopez     1996     1     6 City       12     <NA>     Jose   
    ## 6 6       F        Cassidy   Jones     Davis     1980     7    20 City       10     F        Cassidy
    ## 7 7       M        Michael   Murphy    O'Calag…  1969     4    12 Rural      9      M        Mike   
    ## 8 8       M        Oliver    Laurent   De Bord…  1971     2     4 River      8      M        Olivier
    ## 9 9       F        Blessing  <NA>      Adebayo   1955     2    14 Rural      <NA>   <NA>     <NA>   
    ## # ℹ 7 more variables: middle.y <chr>, last.y <chr>, yr.y <dbl>, mon.y <dbl>, day.y <dbl>,
    ## #   district.y <chr>, result <chr>

De-duplicate rows

``` r
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
```

    ## # A tibble: 11 × 8
    ##    gender first     middle    last          yr   mon   day district
    ##    <chr>  <chr>     <chr>     <chr>      <dbl> <dbl> <dbl> <chr>   
    ##  1 M      Amir      <NA>      Khan        1989    11    22 River   
    ##  2 M      Anthony   B.        Smith       1970     9    19 River   
    ##  3 F      Marialisa Contreras Rodrigues   1972     4    15 River   
    ##  4 F      Elizabeth Casteel   Chase       1954     3     3 City    
    ##  5 M      Jose      Sanchez   Lopez       1996     1     6 City    
    ##  6 F      Cassidy   Jones     Davis       1980     7    20 City    
    ##  7 M      Michael   Murphy    O'Calaghan  1969     4    12 Rural   
    ##  8 M      Oliver    Laurent   De Bordow   1971     2     4 River   
    ##  9 F      Blessing  <NA>      Adebayo     1955     2    14 Rural   
    ## 10 M      Tony      B.        Smith       1970     9    19 River   
    ## 11 F      Maria     Contreras Rodrigues   1972     4    15 River

``` r
# run fastLink on the same dataset
dedupe_output <- fastLink(
        dfA = cases_dup,
        dfB = cases_dup,
        varnames = c("gender", "first", "middle", "last", "yr", "mon", "day", "district")
)
```

    ## 
    ## ==================== 
    ## fastLink(): Fast Probabilistic Record Linkage
    ## ==================== 
    ## 
    ## If you set return.all to FALSE, you will not be able to calculate a confusion table as a summary statistic.
    ## dfA and dfB are identical, assuming deduplication of a single data set.
    ## Setting return.all to FALSE.
    ## 
    ## Calculating matches for each variable.
    ## Getting counts for parameter estimation.
    ##     Parallelizing calculation using OpenMP. 1 threads out of 8 are used.
    ## Running the EM algorithm.
    ## Getting the indices of estimated matches.
    ##     Parallelizing calculation using OpenMP. 1 threads out of 8 are used.
    ## Calculating the posterior for each pair of matched observations.
    ## Getting the match patterns for each estimated match.

``` r
# run `getMatches()`: review the potential duplicates
(cases_dedupe <- getMatches(
        dfA = cases_dup,
        dfB = cases_dup,
        fl.out = dedupe_output))
```

    ##    gender     first    middle       last   yr mon day district dedupe.ids
    ## 1       M      Amir      <NA>       Khan 1989  11  22    River          1
    ## 2       M   Anthony        B.      Smith 1970   9  19    River          2
    ## 3       F Marialisa Contreras  Rodrigues 1972   4  15    River          3
    ## 4       F Elizabeth   Casteel      Chase 1954   3   3     City          4
    ## 5       M      Jose   Sanchez      Lopez 1996   1   6     City          5
    ## 6       F   Cassidy     Jones      Davis 1980   7  20     City          6
    ## 7       M   Michael    Murphy O'Calaghan 1969   4  12    Rural          7
    ## 8       M    Oliver   Laurent  De Bordow 1971   2   4    River          8
    ## 9       F  Blessing      <NA>    Adebayo 1955   2  14    Rural          9
    ## 10      M      Tony        B.      Smith 1970   9  19    River          2
    ## 11      F     Maria Contreras  Rodrigues 1972   4  15    River          3

``` r
cases_dedupe %>% 
        count(dedupe.ids) %>% 
        filter(n > 1)
```

    ##   dedupe.ids n
    ## 1          2 2
    ## 2          3 2

``` r
# displays duplicates
cases_dedupe %>% filter(dedupe.ids %in% c(2, 3))
```

    ##   gender     first    middle      last   yr mon day district dedupe.ids
    ## 1      M   Anthony        B.     Smith 1970   9  19    River          2
    ## 2      F Marialisa Contreras Rodrigues 1972   4  15    River          3
    ## 3      M      Tony        B.     Smith 1970   9  19    River          2
    ## 4      F     Maria Contreras Rodrigues 1972   4  15    River          3

### Bind rows

``` r
# create core table
(hosp_summary <- data %>% 
        group_by(hospital) %>%
        summarise(# number of rows per hospital-outcome group
                  cases = n(),
                  # median CT value per group
                  ct_value_med = median(ct_blood, na.rm=T)))
```

    ## # A tibble: 6 × 3
    ##   hospital                             cases ct_value_med
    ##   <chr>                                <int>        <dbl>
    ## 1 Central Hospital                       454           22
    ## 2 Military Hospital                      896           21
    ## 3 Missing                               1469           21
    ## 4 Other                                  885           22
    ## 5 Port Hospital                         1762           22
    ## 6 St. Mark's Maternity Hospital (SMMH)   422           22

``` r
# create totals
(totals <- data %>% 
        summarise(cases = n(),
                  ct_value_med = median(ct_blood, na.rm=T)))
```

    ##   cases ct_value_med
    ## 1  5888           22

``` r
# bind dataframes together
bind_rows(hosp_summary, totals) %>%
        mutate(hospital = replace_na(hospital, "Totals"))
```

    ## # A tibble: 7 × 3
    ##   hospital                             cases ct_value_med
    ##   <chr>                                <int>        <dbl>
    ## 1 Central Hospital                       454           22
    ## 2 Military Hospital                      896           21
    ## 3 Missing                               1469           21
    ## 4 Other                                  885           22
    ## 5 Port Hospital                         1762           22
    ## 6 St. Mark's Maternity Hospital (SMMH)   422           22
    ## 7 Totals                                5888           22

``` r
#rmarkdown::render()
```
