De-duplication
================

``` r
pacman::p_load(
        rio,            # import and export
        here,           # locate files 
        tidyverse,      # data management and visualization
        janitor,        # function for reviewing duplicates
        stringr      # for string searches, can be used in "rolling-up" values
)
```

### Create dataframe

``` r
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
```

    ##    recordID personID    name       date  time encounter purpose symptoms_ever
    ## 1         1        1    adam 2020-01-01 09:00         1 contact          <NA>
    ## 2         1        1    adam 2020-01-01 09:00         1 contact          <NA>
    ## 3         2        2  amrish 2020-01-02 14:20         1 contact            No
    ## 4         3        2  amrish 2020-01-02 14:20         1 contact            No
    ## 5         4        3  mariah 2020-01-05 12:00         1    case            No
    ## 6         5        2  amrish 2020-01-05 16:10         3    case           Yes
    ## 7         6        4  nikhil 2020-01-05 13:01         1 contact           Yes
    ## 8         7        5   brian 2020-01-05 15:20         1 contact            No
    ## 9         8        6   smita 2020-01-05 14:20         1 contact           Yes
    ## 10        9        7  raquel 2020-01-05 12:30         1 contact          <NA>
    ## 11       10        2  amrish 2020-01-02 10:24         2 contact           Yes
    ## 12       11        1    adam 2020-01-05 09:40         2    case            No
    ## 13       12        3  mariah 2020-01-06 07:25         2 contact            No
    ## 14       13        3  mariah 2020-01-06 08:32         3 contact            No
    ## 15       14        4  nikhil 2020-01-06 15:36         2 contact           Yes
    ## 16       15        5   brian 2020-01-06 15:31         2 contact           Yes
    ## 17       16        5   brian 2020-01-07 07:59         3    case            No
    ## 18       17        7  raquel 2020-01-07 11:13         2 contact            No
    ## 19       18        8 natalie 2020-01-07 17:12         1    case            No

``` r
obs %>% janitor::tabyl(name, purpose)
```

    ##     name case contact
    ##     adam    1       2
    ##   amrish    1       3
    ##    brian    1       2
    ##   mariah    1       2
    ##  natalie    1       0
    ##   nikhil    0       2
    ##   raquel    0       2
    ##    smita    0       1

### De-duplication

`janitor::get_dupes()`

``` r
# default: 100% duplicates
obs %>% janitor::get_dupes()
```

    ## No variable names specified - using all columns.

    ##   recordID personID name       date  time encounter purpose symptoms_ever dupe_count
    ## 1        1        1 adam 2020-01-01 09:00         1 contact          <NA>          2
    ## 2        1        1 adam 2020-01-01 09:00         1 contact          <NA>          2

``` r
# ignore column recordID, wrap in c() if multiple columns
obs %>% janitor::get_dupes(-recordID)
```

    ##   personID   name       date  time encounter purpose symptoms_ever dupe_count recordID
    ## 1        1   adam 2020-01-01 09:00         1 contact          <NA>          2        1
    ## 2        1   adam 2020-01-01 09:00         1 contact          <NA>          2        1
    ## 3        2 amrish 2020-01-02 14:20         1 contact            No          2        2
    ## 4        2 amrish 2020-01-02 14:20         1 contact            No          2        3

``` r
# duplicates based on name and purpose columns ONLY
obs %>% janitor::get_dupes(name, purpose)
```

    ##      name purpose dupe_count recordID personID       date  time encounter symptoms_ever
    ## 1  amrish contact          3        2        2 2020-01-02 14:20         1            No
    ## 2  amrish contact          3        3        2 2020-01-02 14:20         1            No
    ## 3  amrish contact          3       10        2 2020-01-02 10:24         2           Yes
    ## 4    adam contact          2        1        1 2020-01-01 09:00         1          <NA>
    ## 5    adam contact          2        1        1 2020-01-01 09:00         1          <NA>
    ## 6   brian contact          2        7        5 2020-01-05 15:20         1            No
    ## 7   brian contact          2       15        5 2020-01-06 15:31         2           Yes
    ## 8  mariah contact          2       12        3 2020-01-06 07:25         2            No
    ## 9  mariah contact          2       13        3 2020-01-06 08:32         3            No
    ## 10 nikhil contact          2        6        4 2020-01-05 13:01         1           Yes
    ## 11 nikhil contact          2       14        4 2020-01-06 15:36         2           Yes
    ## 12 raquel contact          2        9        7 2020-01-05 12:30         1          <NA>
    ## 13 raquel contact          2       17        7 2020-01-07 11:13         2            No

keep only unique rows

``` r
obs %>% dplyr::distinct(across(-recordID),
                        .keep_all = TRUE)
```

    ##    recordID personID    name       date  time encounter purpose symptoms_ever
    ## 1         1        1    adam 2020-01-01 09:00         1 contact          <NA>
    ## 2         2        2  amrish 2020-01-02 14:20         1 contact            No
    ## 3         4        3  mariah 2020-01-05 12:00         1    case            No
    ## 4         5        2  amrish 2020-01-05 16:10         3    case           Yes
    ## 5         6        4  nikhil 2020-01-05 13:01         1 contact           Yes
    ## 6         7        5   brian 2020-01-05 15:20         1 contact            No
    ## 7         8        6   smita 2020-01-05 14:20         1 contact           Yes
    ## 8         9        7  raquel 2020-01-05 12:30         1 contact          <NA>
    ## 9        10        2  amrish 2020-01-02 10:24         2 contact           Yes
    ## 10       11        1    adam 2020-01-05 09:40         2    case            No
    ## 11       12        3  mariah 2020-01-06 07:25         2 contact            No
    ## 12       13        3  mariah 2020-01-06 08:32         3 contact            No
    ## 13       14        4  nikhil 2020-01-06 15:36         2 contact           Yes
    ## 14       15        5   brian 2020-01-06 15:31         2 contact           Yes
    ## 15       16        5   brian 2020-01-07 07:59         3    case            No
    ## 16       17        7  raquel 2020-01-07 11:13         2 contact            No
    ## 17       18        8 natalie 2020-01-07 17:12         1    case            No

deduplicate based on specific columns

``` r
obs %>% distinct(name, purpose) %>%
        arrange(name)
```

    ##       name purpose
    ## 1     adam contact
    ## 2     adam    case
    ## 3   amrish contact
    ## 4   amrish    case
    ## 5    brian contact
    ## 6    brian    case
    ## 7   mariah    case
    ## 8   mariah contact
    ## 9  natalie    case
    ## 10  nikhil contact
    ## 11  raquel contact
    ## 12   smita contact

``` r
obs %>% distinct(name, purpose, .keep_all = TRUE) %>%
        arrange(name)
```

    ##    recordID personID    name       date  time encounter purpose symptoms_ever
    ## 1         1        1    adam 2020-01-01 09:00         1 contact          <NA>
    ## 2        11        1    adam 2020-01-05 09:40         2    case            No
    ## 3         2        2  amrish 2020-01-02 14:20         1 contact            No
    ## 4         5        2  amrish 2020-01-05 16:10         3    case           Yes
    ## 5         7        5   brian 2020-01-05 15:20         1 contact            No
    ## 6        16        5   brian 2020-01-07 07:59         3    case            No
    ## 7         4        3  mariah 2020-01-05 12:00         1    case            No
    ## 8        12        3  mariah 2020-01-06 07:25         2 contact            No
    ## 9        18        8 natalie 2020-01-07 17:12         1    case            No
    ## 10        6        4  nikhil 2020-01-05 13:01         1 contact           Yes
    ## 11        9        7  raquel 2020-01-05 12:30         1 contact          <NA>
    ## 12        8        6   smita 2020-01-05 14:20         1 contact           Yes

deduplicate elements in vector

``` r
(x <- c(1, 1, 2, NA, NA, 4, 5, 4, 4, 1, 2))
```

    ##  [1]  1  1  2 NA NA  4  5  4  4  1  2

``` r
base::duplicated(x)
```

    ##  [1] FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE

``` r
# return only duplicated elements
x[duplicated(x)]
```

    ## [1]  1 NA  4  4  1  2

``` r
# return only unique elements
x[!duplicated(x)]
```

    ## [1]  1  2 NA  4  5

``` r
base::unique(x)
```

    ## [1]  1  2 NA  4  5

``` r
# remove NAs
unique(na.omit(x))
```

    ## [1] 1 2 4 5

### Slicing

``` r
obs %>% dplyr::slice(c(4, 7))
```

    ##   recordID personID   name       date  time encounter purpose symptoms_ever
    ## 1        3        2 amrish 2020-01-02 14:20         1 contact            No
    ## 2        6        4 nikhil 2020-01-05 13:01         1 contact           Yes

``` r
obs %>% dplyr::slice(-c(4, 7))
```

    ##    recordID personID    name       date  time encounter purpose symptoms_ever
    ## 1         1        1    adam 2020-01-01 09:00         1 contact          <NA>
    ## 2         1        1    adam 2020-01-01 09:00         1 contact          <NA>
    ## 3         2        2  amrish 2020-01-02 14:20         1 contact            No
    ## 4         4        3  mariah 2020-01-05 12:00         1    case            No
    ## 5         5        2  amrish 2020-01-05 16:10         3    case           Yes
    ## 6         7        5   brian 2020-01-05 15:20         1 contact            No
    ## 7         8        6   smita 2020-01-05 14:20         1 contact           Yes
    ## 8         9        7  raquel 2020-01-05 12:30         1 contact          <NA>
    ## 9        10        2  amrish 2020-01-02 10:24         2 contact           Yes
    ## 10       11        1    adam 2020-01-05 09:40         2    case            No
    ## 11       12        3  mariah 2020-01-06 07:25         2 contact            No
    ## 12       13        3  mariah 2020-01-06 08:32         3 contact            No
    ## 13       14        4  nikhil 2020-01-06 15:36         2 contact           Yes
    ## 14       15        5   brian 2020-01-06 15:31         2 contact           Yes
    ## 15       16        5   brian 2020-01-07 07:59         3    case            No
    ## 16       17        7  raquel 2020-01-07 11:13         2 contact            No
    ## 17       18        8 natalie 2020-01-07 17:12         1    case            No

``` r
obs %>% dplyr::slice(c(4:7))
```

    ##   recordID personID   name       date  time encounter purpose symptoms_ever
    ## 1        3        2 amrish 2020-01-02 14:20         1 contact            No
    ## 2        4        3 mariah 2020-01-05 12:00         1    case            No
    ## 3        5        2 amrish 2020-01-05 16:10         3    case           Yes
    ## 4        6        4 nikhil 2020-01-05 13:01         1 contact           Yes

``` r
# return rows with the largest encounter number
obs %>% slice_max(encounter, n = 1)
```

    ##   recordID personID   name       date  time encounter purpose symptoms_ever
    ## 1        5        2 amrish 2020-01-05 16:10         3    case           Yes
    ## 2       13        3 mariah 2020-01-06 08:32         3 contact            No
    ## 3       16        5  brian 2020-01-07 07:59         3    case            No

``` r
# keep only the latest encounter per person
obs %>% group_by(name) %>%
        slice_max(date, # keep row per group with maximum date value 
                  n = 1, # keep only the single highest row 
                  with_ties = F) # if there's a tie (of date), take the first row
```

    ## # A tibble: 8 × 8
    ## # Groups:   name [8]
    ##   recordID personID name    date       time  encounter purpose symptoms_ever
    ##      <dbl>    <dbl> <chr>   <date>     <chr>     <dbl> <chr>   <chr>        
    ## 1       11        1 adam    2020-01-05 09:40         2 case    No           
    ## 2        5        2 amrish  2020-01-05 16:10         3 case    Yes          
    ## 3       16        5 brian   2020-01-07 07:59         3 case    No           
    ## 4       12        3 mariah  2020-01-06 07:25         2 contact No           
    ## 5       18        8 natalie 2020-01-07 17:12         1 case    No           
    ## 6       14        4 nikhil  2020-01-06 15:36         2 contact Yes          
    ## 7       17        7 raquel  2020-01-07 11:13         2 contact No           
    ## 8        8        6 smita   2020-01-05 14:20         1 contact Yes

``` r
# Example of multiple slice statements to "break ties"
obs %>% group_by(name) %>%
        # FIRST - slice by latest date
        slice_max(date, n = 1, with_ties = TRUE) %>% 
        # SECOND - if there is a tie, select row with latest time; ties prohibited
        slice_max(lubridate::hm(time), n = 1, with_ties = FALSE)
```

    ## # A tibble: 8 × 8
    ## # Groups:   name [8]
    ##   recordID personID name    date       time  encounter purpose symptoms_ever
    ##      <dbl>    <dbl> <chr>   <date>     <chr>     <dbl> <chr>   <chr>        
    ## 1       11        1 adam    2020-01-05 09:40         2 case    No           
    ## 2        5        2 amrish  2020-01-05 16:10         3 case    Yes          
    ## 3       16        5 brian   2020-01-07 07:59         3 case    No           
    ## 4       13        3 mariah  2020-01-06 08:32         3 contact No           
    ## 5       18        8 natalie 2020-01-07 17:12         1 case    No           
    ## 6       14        4 nikhil  2020-01-06 15:36         2 contact Yes          
    ## 7       17        7 raquel  2020-01-07 11:13         2 contact No           
    ## 8        8        6 smita   2020-01-05 14:20         1 contact Yes

``` r
# 1. Define data frame of rows to keep for analysis
(obs_keep <- obs %>%
        group_by(name) %>%
        # keep only latest encounter per person
        slice_max(encounter, n = 1, with_ties = FALSE))
```

    ## # A tibble: 8 × 8
    ## # Groups:   name [8]
    ##   recordID personID name    date       time  encounter purpose symptoms_ever
    ##      <dbl>    <dbl> <chr>   <date>     <chr>     <dbl> <chr>   <chr>        
    ## 1       11        1 adam    2020-01-05 09:40         2 case    No           
    ## 2        5        2 amrish  2020-01-05 16:10         3 case    Yes          
    ## 3       16        5 brian   2020-01-07 07:59         3 case    No           
    ## 4       13        3 mariah  2020-01-06 08:32         3 contact No           
    ## 5       18        8 natalie 2020-01-07 17:12         1 case    No           
    ## 6       14        4 nikhil  2020-01-06 15:36         2 contact Yes          
    ## 7       17        7 raquel  2020-01-07 11:13         2 contact No           
    ## 8        8        6 smita   2020-01-05 14:20         1 contact Yes

``` r
# 2. Mark original data frame
(obs_marked <- obs %>%
        # make new dup_record column
        mutate(dup_record = case_when(
                # if record is in obs_keep data frame
                recordID %in% obs_keep$recordID ~ "For analysis", 
                # all else marked as "Ignore" for analysis purposes
                TRUE                            ~ "Ignore")))
```

    ##    recordID personID    name       date  time encounter purpose symptoms_ever   dup_record
    ## 1         1        1    adam 2020-01-01 09:00         1 contact          <NA>       Ignore
    ## 2         1        1    adam 2020-01-01 09:00         1 contact          <NA>       Ignore
    ## 3         2        2  amrish 2020-01-02 14:20         1 contact            No       Ignore
    ## 4         3        2  amrish 2020-01-02 14:20         1 contact            No       Ignore
    ## 5         4        3  mariah 2020-01-05 12:00         1    case            No       Ignore
    ## 6         5        2  amrish 2020-01-05 16:10         3    case           Yes For analysis
    ## 7         6        4  nikhil 2020-01-05 13:01         1 contact           Yes       Ignore
    ## 8         7        5   brian 2020-01-05 15:20         1 contact            No       Ignore
    ## 9         8        6   smita 2020-01-05 14:20         1 contact           Yes For analysis
    ## 10        9        7  raquel 2020-01-05 12:30         1 contact          <NA>       Ignore
    ## 11       10        2  amrish 2020-01-02 10:24         2 contact           Yes       Ignore
    ## 12       11        1    adam 2020-01-05 09:40         2    case            No For analysis
    ## 13       12        3  mariah 2020-01-06 07:25         2 contact            No       Ignore
    ## 14       13        3  mariah 2020-01-06 08:32         3 contact            No For analysis
    ## 15       14        4  nikhil 2020-01-06 15:36         2 contact           Yes For analysis
    ## 16       15        5   brian 2020-01-06 15:31         2 contact           Yes       Ignore
    ## 17       16        5   brian 2020-01-07 07:59         3    case            No For analysis
    ## 18       17        7  raquel 2020-01-07 11:13         2 contact            No For analysis
    ## 19       18        8 natalie 2020-01-07 17:12         1    case            No For analysis

Calculate row completeness

``` r
# create a "key variable completeness" column
# this is a *proportion* of the columns designated as "key_cols" that have non-missing values

key_cols = c("personID", "name", "symptoms_ever")

obs %>% 
        mutate(key_completeness = rowSums(!is.na(.[,key_cols]))/length(key_cols)) 
```

    ##    recordID personID    name       date  time encounter purpose symptoms_ever key_completeness
    ## 1         1        1    adam 2020-01-01 09:00         1 contact          <NA>        0.6666667
    ## 2         1        1    adam 2020-01-01 09:00         1 contact          <NA>        0.6666667
    ## 3         2        2  amrish 2020-01-02 14:20         1 contact            No        1.0000000
    ## 4         3        2  amrish 2020-01-02 14:20         1 contact            No        1.0000000
    ## 5         4        3  mariah 2020-01-05 12:00         1    case            No        1.0000000
    ## 6         5        2  amrish 2020-01-05 16:10         3    case           Yes        1.0000000
    ## 7         6        4  nikhil 2020-01-05 13:01         1 contact           Yes        1.0000000
    ## 8         7        5   brian 2020-01-05 15:20         1 contact            No        1.0000000
    ## 9         8        6   smita 2020-01-05 14:20         1 contact           Yes        1.0000000
    ## 10        9        7  raquel 2020-01-05 12:30         1 contact          <NA>        0.6666667
    ## 11       10        2  amrish 2020-01-02 10:24         2 contact           Yes        1.0000000
    ## 12       11        1    adam 2020-01-05 09:40         2    case            No        1.0000000
    ## 13       12        3  mariah 2020-01-06 07:25         2 contact            No        1.0000000
    ## 14       13        3  mariah 2020-01-06 08:32         3 contact            No        1.0000000
    ## 15       14        4  nikhil 2020-01-06 15:36         2 contact           Yes        1.0000000
    ## 16       15        5   brian 2020-01-06 15:31         2 contact           Yes        1.0000000
    ## 17       16        5   brian 2020-01-07 07:59         3    case            No        1.0000000
    ## 18       17        7  raquel 2020-01-07 11:13         2 contact            No        1.0000000
    ## 19       18        8 natalie 2020-01-07 17:12         1    case            No        1.0000000

### Roll-up values

Roll-up values into one row

``` r
# "Roll-up" values into one row per group (per "personID") 
(cases_rolled <- 
        obs %>% 
        group_by(personID) %>% 
        # order the rows within each group (e.g. by date)
        arrange(date, .by_group = TRUE))
```

    ## # A tibble: 19 × 8
    ## # Groups:   personID [8]
    ##    recordID personID name    date       time  encounter purpose symptoms_ever
    ##       <dbl>    <dbl> <chr>   <date>     <chr>     <dbl> <chr>   <chr>        
    ##  1        1        1 adam    2020-01-01 09:00         1 contact <NA>         
    ##  2        1        1 adam    2020-01-01 09:00         1 contact <NA>         
    ##  3       11        1 adam    2020-01-05 09:40         2 case    No           
    ##  4        2        2 amrish  2020-01-02 14:20         1 contact No           
    ##  5        3        2 amrish  2020-01-02 14:20         1 contact No           
    ##  6       10        2 amrish  2020-01-02 10:24         2 contact Yes          
    ##  7        5        2 amrish  2020-01-05 16:10         3 case    Yes          
    ##  8        4        3 mariah  2020-01-05 12:00         1 case    No           
    ##  9       12        3 mariah  2020-01-06 07:25         2 contact No           
    ## 10       13        3 mariah  2020-01-06 08:32         3 contact No           
    ## 11        6        4 nikhil  2020-01-05 13:01         1 contact Yes          
    ## 12       14        4 nikhil  2020-01-06 15:36         2 contact Yes          
    ## 13        7        5 brian   2020-01-05 15:20         1 contact No           
    ## 14       15        5 brian   2020-01-06 15:31         2 contact Yes          
    ## 15       16        5 brian   2020-01-07 07:59         3 case    No           
    ## 16        8        6 smita   2020-01-05 14:20         1 contact Yes          
    ## 17        9        7 raquel  2020-01-05 12:30         1 contact <NA>         
    ## 18       17        7 raquel  2020-01-07 11:13         2 contact No           
    ## 19       18        8 natalie 2020-01-07 17:12         1 case    No

``` r
# for each column, paste together all values within the grouped rows, separated by ";"
cases_rolled %>%
        summarise(across(everything(),      # apply to all columns
                         # function is defined which combines non-NA values
                       ~paste0(na.omit(.x),
                               collapse = "; "))) 
```

    ## # A tibble: 8 × 8
    ##   personID recordID    name                           date                 time  encounter purpose symptoms_ever
    ##      <dbl> <chr>       <chr>                          <chr>                <chr> <chr>     <chr>   <chr>        
    ## 1        1 1; 1; 11    adam; adam; adam               2020-01-01; 2020-01… 09:0… 1; 1; 2   contac… No           
    ## 2        2 2; 3; 10; 5 amrish; amrish; amrish; amrish 2020-01-02; 2020-01… 14:2… 1; 1; 2;… contac… No; No; Yes;…
    ## 3        3 4; 12; 13   mariah; mariah; mariah         2020-01-05; 2020-01… 12:0… 1; 2; 3   case; … No; No; No   
    ## 4        4 6; 14       nikhil; nikhil                 2020-01-05; 2020-01… 13:0… 1; 2      contac… Yes; Yes     
    ## 5        5 7; 15; 16   brian; brian; brian            2020-01-05; 2020-01… 15:2… 1; 2; 3   contac… No; Yes; No  
    ## 6        6 8           smita                          2020-01-05           14:20 1         contact Yes          
    ## 7        7 9; 17       raquel; raquel                 2020-01-05; 2020-01… 12:3… 1; 2      contac… No           
    ## 8        8 18          natalie                        2020-01-07           17:12 1         case    No

``` r
# shows unique values only
cases_rolled %>%
        summarise(across(everything(),
                         ~paste0(unique(na.omit(.x)),
                                 collapse = "; ")))
```

    ## # A tibble: 8 × 8
    ##   personID recordID    name    date                               time           encounter purpose symptoms_ever
    ##      <dbl> <chr>       <chr>   <chr>                              <chr>          <chr>     <chr>   <chr>        
    ## 1        1 1; 11       adam    2020-01-01; 2020-01-05             09:00; 09:40   1; 2      contac… No           
    ## 2        2 2; 3; 10; 5 amrish  2020-01-02; 2020-01-05             14:20; 10:24;… 1; 2; 3   contac… No; Yes      
    ## 3        3 4; 12; 13   mariah  2020-01-05; 2020-01-06             12:00; 07:25;… 1; 2; 3   case; … No           
    ## 4        4 6; 14       nikhil  2020-01-05; 2020-01-06             13:01; 15:36   1; 2      contact Yes          
    ## 5        5 7; 15; 16   brian   2020-01-05; 2020-01-06; 2020-01-07 15:20; 15:31;… 1; 2; 3   contac… No; Yes      
    ## 6        6 8           smita   2020-01-05                         14:20          1         contact Yes          
    ## 7        7 9; 17       raquel  2020-01-05; 2020-01-07             12:30; 11:13   1; 2      contact No           
    ## 8        8 18          natalie 2020-01-07                         17:12          1         case    No

``` r
cases_rolled %>%
        summarise(across(everything(),
                         list(roll = ~paste0(na.omit(.x),
                                             collapse = "; "))))
```

    ## # A tibble: 8 × 8
    ##   personID recordID_roll name_roll            date_roll time_roll encounter_roll purpose_roll symptoms_ever_roll
    ##      <dbl> <chr>         <chr>                <chr>     <chr>     <chr>          <chr>        <chr>             
    ## 1        1 1; 1; 11      adam; adam; adam     2020-01-… 09:00; 0… 1; 1; 2        contact; co… No                
    ## 2        2 2; 3; 10; 5   amrish; amrish; amr… 2020-01-… 14:20; 1… 1; 1; 2; 3     contact; co… No; No; Yes; Yes  
    ## 3        3 4; 12; 13     mariah; mariah; mar… 2020-01-… 12:00; 0… 1; 2; 3        case; conta… No; No; No        
    ## 4        4 6; 14         nikhil; nikhil       2020-01-… 13:01; 1… 1; 2           contact; co… Yes; Yes          
    ## 5        5 7; 15; 16     brian; brian; brian  2020-01-… 15:20; 1… 1; 2; 3        contact; co… No; Yes; No       
    ## 6        6 8             smita                2020-01-… 14:20     1              contact      Yes               
    ## 7        7 9; 17         raquel; raquel       2020-01-… 12:30; 1… 1; 2           contact; co… No                
    ## 8        8 18            natalie              2020-01-… 17:12     1              case         No

Overwrite values

``` r
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
```

    ## # A tibble: 8 × 8
    ##   personID recordID    name                           date             time  encounter purpose symptoms_ever_mod
    ##      <dbl> <chr>       <chr>                          <chr>            <chr> <chr>     <chr>   <chr>            
    ## 1        1 1; 1; 11    adam; adam; adam               2020-01-01; 202… 09:0… 1; 1; 2   contac… No               
    ## 2        2 2; 3; 10; 5 amrish; amrish; amrish; amrish 2020-01-02; 202… 14:2… 1; 1; 2;… contac… Yes              
    ## 3        3 4; 12; 13   mariah; mariah; mariah         2020-01-05; 202… 12:0… 1; 2; 3   case; … No               
    ## 4        4 6; 14       nikhil; nikhil                 2020-01-05; 202… 13:0… 1; 2      contac… Yes              
    ## 5        5 7; 15; 16   brian; brian; brian            2020-01-05; 202… 15:2… 1; 2; 3   contac… Yes              
    ## 6        6 8           smita                          2020-01-05       14:20 1         contact Yes              
    ## 7        7 9; 17       raquel; raquel                 2020-01-05; 202… 12:3… 1; 2      contac… No               
    ## 8        8 18          natalie                        2020-01-07       17:12 1         case    No

``` r
#rmarkdown::render()
```
