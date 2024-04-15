c07_import_export_files.R
================

``` r
library(here)
library(tidyverse)
```

# Import and Export files

### Pasting data from clipboard

As data frame

``` r
clipr::read_clip_tbl() # imports current clipboard as data frame
```

    ##   Year Share
    ## 1 1980 0.21%
    ## 2 1990 0.28%
    ## 3 2000 0.39%
    ## 4 2010 0.52%
    ## 5 2020 0.80%

``` r
read.table(file = "clipboard",  # specify this as "clipboard"
           sep = "t",           # separator could be tab, or commas, etc.
           header=TRUE)         # if there is a header row
```

    ##    Year.Share
    ## 1 1980\t0.21%
    ## 2 1990\t0.28%
    ## 3 2000\t0.39%
    ## 4 2010\t0.52%
    ## 5 2020\t0.80%

As character vector

``` r
clipr::read_clip()
```

    ## [1] "Year\tShare" "1980\t0.21%" "1990\t0.28%" "2000\t0.39%" "2010\t0.52%" "2020\t0.80%"

### APIs

``` r
# load packages
pacman::p_load(httr, jsonlite, tidyverse)

# prepare the request
path <- "http://api.ratings.food.gov.uk/Establishments"
request <- GET(url = path,
               query = list(
                       localAuthorityId = 188,
                       BusinessTypeId = 7844,
                       pageNumber = 1,
                       pageSize = 5000),
               add_headers("x-api-version" = "2"))

# check for any server error ("200" is good!)
request$status_code
```

    ## [1] 200

``` r
# submit the request, parse the response, and convert to a data frame
content(request, as = "text", encoding = "UTF-8") %>%
        fromJSON(flatten = TRUE) %>%
        pluck("establishments") %>%
        tibble()
```

    ## # A tibble: 277 × 28
    ##    AddressLine1    AddressLine2  AddressLine3 AddressLine4 BusinessName BusinessType BusinessTypeID
    ##    <chr>           <chr>         <chr>        <chr>        <chr>        <chr>                 <int>
    ##  1 ""              "18 Northend… "Sale"       ""           Alfresco     Takeaway/sa…           7844
    ##  2 ""              "1 Marsland … "Sale"       ""           Allens Frie… Takeaway/sa…           7844
    ##  3 ""              "42 Greenwoo… "Altrincham" "Cheshire"   Altrincham … Takeaway/sa…           7844
    ##  4 ""              ""            ""           ""           Bakes in th… Takeaway/sa…           7844
    ##  5 ""              "102a Higher… "Urmston"    "Manchester" Banga Curri… Takeaway/sa…           7844
    ##  6 "2 The Orient"  ""            "Trafford P… "Manchester" Barburrito   Takeaway/sa…           7844
    ##  7 "Jackson House" "Sibson Road" "Sale"       ""           Bean Coffee… Takeaway/sa…           7844
    ##  8 ""              "104 Stamfor… "Altrincham" ""           Bebe's Take… Takeaway/sa…           7844
    ##  9 ""              "351 Stockpo… "Timperley"  "Altrincham" Beirut Leba… Takeaway/sa…           7844
    ## 10 ""              "Bens"        "Mall Kiosk… "Peel Avenu… Bens Cookies Takeaway/sa…           7844
    ## # ℹ 267 more rows
    ## # ℹ 21 more variables: ChangesByServerID <int>, Distance <lgl>, FHRSID <int>,
    ## #   LocalAuthorityBusinessID <chr>, LocalAuthorityCode <chr>, LocalAuthorityEmailAddress <chr>,
    ## #   LocalAuthorityName <chr>, LocalAuthorityWebSite <chr>, NewRatingPending <lgl>, Phone <chr>,
    ## #   PostCode <chr>, RatingDate <chr>, RatingKey <chr>, RatingValue <chr>, RightToReply <chr>,
    ## #   SchemeType <chr>, geocode.longitude <chr>, geocode.latitude <chr>, scores.Hygiene <int>,
    ## #   scores.Structural <int>, scores.ConfidenceInManagement <int>
