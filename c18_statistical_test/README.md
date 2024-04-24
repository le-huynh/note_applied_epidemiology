Simple statistical tests
================

``` r
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
```

## Import data

``` r
data <- rio::import(here("data/linelist_cleaned.rds"))
```

## `t-test`

#### Syntax 1: numeric and categorical columns are in the same dataframe

`baseR`

``` r
t.test(age_years ~ gender, data = data)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  age_years by gender
    ## t = -21.344, df = 4902.3, p-value < 2.2e-16
    ## alternative hypothesis: true difference in means between group f and group m is not equal to 0
    ## 95 percent confidence interval:
    ##  -7.571920 -6.297975
    ## sample estimates:
    ## mean in group f mean in group m 
    ##        12.60207        19.53701

`rstatix::`

``` r
data %>% rstatix::t_test(age_years ~ gender)
```

    ## # A tibble: 1 × 10
    ##   .y.       group1 group2    n1    n2 statistic    df        p    p.adj p.adj.signif
    ## * <chr>     <chr>  <chr>  <int> <int>     <dbl> <dbl>    <dbl>    <dbl> <chr>       
    ## 1 age_years f      m       2807  2803     -21.3 4902. 9.89e-97 9.89e-97 ****

`gtsummary::`

``` r
data %>% select(age_years, gender) %>%
        tbl_summary(statistic = age_years ~ "{mean} ({sd})",
                    by = gender) %>%
        add_p(age_years ~ "t.test")
```

    ## 278 observations missing `gender` have been removed. To include these observations, use `forcats::fct_na_value_to_level()` on `gender` column before passing to `tbl_summary()`.

<div id="miasqvnvyh" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;f&lt;/strong&gt;, N = 2,807&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>f</strong>, N = 2,807<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;m&lt;/strong&gt;, N = 2,803&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>m</strong>, N = 2,803<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;p-value&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;2&lt;/sup&gt;&lt;/span&gt;"><strong>p-value</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age_years</td>
<td headers="stat_1" class="gt_row gt_center">13 (10)</td>
<td headers="stat_2" class="gt_row gt_center">20 (14)</td>
<td headers="p.value" class="gt_row gt_center"><0.001</td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> Mean (SD)</td>
    </tr>
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span> Welch Two Sample t-test</td>
    </tr>
  </tfoot>
</table>
</div>

#### Syntax 2: compare two separate numeric vectors from different datasets

``` r
# t.test(df1$col1, df2$col2)
```

#### one-sample t-test

`baseR`

``` r
t.test(data$age_years, mu = 20)
```

    ## 
    ##  One Sample t-test
    ## 
    ## data:  data$age_years
    ## t = -23.989, df = 5801, p-value < 2.2e-16
    ## alternative hypothesis: true mean is not equal to 20
    ## 95 percent confidence interval:
    ##  15.69293 16.34369
    ## sample estimates:
    ## mean of x 
    ##  16.01831

`rstatix::`

``` r
data %>% rstatix::t_test(age_years ~ 1, mu = 20)
```

    ## # A tibble: 1 × 7
    ##   .y.       group1 group2         n statistic    df         p
    ## * <chr>     <chr>  <chr>      <int>     <dbl> <dbl>     <dbl>
    ## 1 age_years 1      null model  5802     -24.0  5801 2.48e-121

``` r
data %>% group_by(gender) %>%
        t_test(age_years ~ 1, mu = 20)
```

    ## # A tibble: 3 × 8
    ##   gender .y.       group1 group2         n statistic    df         p
    ## * <chr>  <chr>     <chr>  <chr>      <int>     <dbl> <dbl>     <dbl>
    ## 1 f      age_years 1      null model  2807    -40.9   2806 1.04e-286
    ## 2 m      age_years 1      null model  2803     -1.72  2802 8.62e-  2
    ## 3 <NA>   age_years 1      null model   192     -6.03   191 8.43e-  9

## `Shapiro-Wilk test`

`baseR`

``` r
# sample size must be between 3 and 5000
df <- data %>% head(1000)
shapiro.test(df$age_years)
```

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  df$age_years
    ## W = 0.90332, p-value < 2.2e-16

`rstatix::`

``` r
# sample size must be between 3 and 5000
data %>% head(1000) %>%
        shapiro_test(age_years)
```

    ## # A tibble: 1 × 3
    ##   variable  statistic        p
    ##   <chr>         <dbl>    <dbl>
    ## 1 age_years     0.903 1.66e-24

## `Wilcoxon rank sum test` or `Mann–Whitney U test`

`baseR`

``` r
wilcox.test(age_years ~ outcome, data = data)
```

    ## 
    ##  Wilcoxon rank sum test with continuity correction
    ## 
    ## data:  age_years by outcome
    ## W = 2501868, p-value = 0.8308
    ## alternative hypothesis: true location shift is not equal to 0

`rstatix::`

``` r
data %>% wilcox_test(age_years ~ outcome)
```

    ## # A tibble: 1 × 9
    ##   .y.       group1 group2     n1    n2 statistic     p p.adj p.adj.signif
    ## * <chr>     <chr>  <chr>   <int> <int>     <dbl> <dbl> <dbl> <chr>       
    ## 1 age_years Death  Recover  2550  1955  2501868. 0.831 0.831 ns

`gtsummary::`

``` r
data %>% select(age_years, outcome) %>%
        tbl_summary(statistic = age_years ~ "{median} ({p25}, {p75})",
                    by = outcome) %>%
        add_p(age_years ~ "wilcox.test")
```

    ## 1323 observations missing `outcome` have been removed. To include these observations, use `forcats::fct_na_value_to_level()` on `outcome` column before passing to `tbl_summary()`.

<div id="ijsbyjmnmt" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Death&lt;/strong&gt;, N = 2,582&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Death</strong>, N = 2,582<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Recover&lt;/strong&gt;, N = 1,983&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Recover</strong>, N = 1,983<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;p-value&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;2&lt;/sup&gt;&lt;/span&gt;"><strong>p-value</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age_years</td>
<td headers="stat_1" class="gt_row gt_center">13 (6, 23)</td>
<td headers="stat_2" class="gt_row gt_center">13 (6, 23)</td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_1" class="gt_row gt_center">32</td>
<td headers="stat_2" class="gt_row gt_center">28</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> Median (IQR)</td>
    </tr>
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span> Wilcoxon rank sum test</td>
    </tr>
  </tfoot>
</table>
</div>

## `Kruskal-Wallis test`

`baseR`

``` r
kruskal.test(age_years ~ outcome, data = data)
```

    ## 
    ##  Kruskal-Wallis rank sum test
    ## 
    ## data:  age_years by outcome
    ## Kruskal-Wallis chi-squared = 0.045675, df = 1, p-value = 0.8308

`rstatix::`

``` r
data %>% kruskal_test(age_years ~ outcome)
```

    ## # A tibble: 1 × 6
    ##   .y.           n statistic    df     p method        
    ## * <chr>     <int>     <dbl> <int> <dbl> <chr>         
    ## 1 age_years  5888    0.0457     1 0.831 Kruskal-Wallis

`gtsummary::`

``` r
data %>% select(age_years, outcome) %>%
        tbl_summary(statistic = age_years ~ "{median} ({p25}, {p75})",
                    by = outcome) %>%
        add_p(age_years ~ "kruskal.test")
```

    ## 1323 observations missing `outcome` have been removed. To include these observations, use `forcats::fct_na_value_to_level()` on `outcome` column before passing to `tbl_summary()`.

<div id="jbzufiutiu" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Death&lt;/strong&gt;, N = 2,582&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Death</strong>, N = 2,582<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Recover&lt;/strong&gt;, N = 1,983&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Recover</strong>, N = 1,983<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;p-value&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;2&lt;/sup&gt;&lt;/span&gt;"><strong>p-value</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">age_years</td>
<td headers="stat_1" class="gt_row gt_center">13 (6, 23)</td>
<td headers="stat_2" class="gt_row gt_center">13 (6, 23)</td>
<td headers="p.value" class="gt_row gt_center">0.8</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_1" class="gt_row gt_center">32</td>
<td headers="stat_2" class="gt_row gt_center">28</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> Median (IQR)</td>
    </tr>
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span> Kruskal-Wallis rank sum test</td>
    </tr>
  </tfoot>
</table>
</div>

## `Chi-squared test`

`baseR`

``` r
stats::chisq.test(data$gender, data$outcome)
```

    ## 
    ##  Pearson's Chi-squared test with Yates' continuity correction
    ## 
    ## data:  data$gender and data$outcome
    ## X-squared = 0.0011841, df = 1, p-value = 0.9725

`rstatix::`

``` r
data %>% tabyl(gender, outcome)
```

    ##  gender Death Recover NA_
    ##       f  1227     953 627
    ##       m  1228     950 625
    ##    <NA>   127      80  71

``` r
data %>% tabyl(gender, outcome) %>%
        select(-1)
```

    ##  Death Recover NA_
    ##   1227     953 627
    ##   1228     950 625
    ##    127      80  71

``` r
data %>% tabyl(gender, outcome) %>%
        select(-1) %>%
        chisq_test()
```

    ## # A tibble: 1 × 6
    ##       n statistic     p    df method          p.signif
    ## * <dbl>     <dbl> <dbl> <int> <chr>           <chr>   
    ## 1  5888      3.53 0.473     4 Chi-square test ns

`gtsummary::`

``` r
data %>% select(gender, outcome) %>%
        tbl_summary(by = outcome) %>%
        add_p()
```

    ## 1323 observations missing `outcome` have been removed. To include these observations, use `forcats::fct_na_value_to_level()` on `outcome` column before passing to `tbl_summary()`.

<div id="lpznuqgfpv" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Characteristic&lt;/strong&gt;"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Death&lt;/strong&gt;, N = 2,582&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Death</strong>, N = 2,582<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;Recover&lt;/strong&gt;, N = 1,983&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;1&lt;/sup&gt;&lt;/span&gt;"><strong>Recover</strong>, N = 1,983<span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="&lt;strong&gt;p-value&lt;/strong&gt;&lt;span class=&quot;gt_footnote_marks&quot; style=&quot;white-space:nowrap;font-style:italic;font-weight:normal;&quot;&gt;&lt;sup&gt;2&lt;/sup&gt;&lt;/span&gt;"><strong>p-value</strong><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="label" class="gt_row gt_left">gender</td>
<td headers="stat_1" class="gt_row gt_center"><br /></td>
<td headers="stat_2" class="gt_row gt_center"><br /></td>
<td headers="p.value" class="gt_row gt_center">>0.9</td></tr>
    <tr><td headers="label" class="gt_row gt_left">    f</td>
<td headers="stat_1" class="gt_row gt_center">1,227 (50%)</td>
<td headers="stat_2" class="gt_row gt_center">953 (50%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    m</td>
<td headers="stat_1" class="gt_row gt_center">1,228 (50%)</td>
<td headers="stat_2" class="gt_row gt_center">950 (50%)</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
    <tr><td headers="label" class="gt_row gt_left">    Unknown</td>
<td headers="stat_1" class="gt_row gt_center">127</td>
<td headers="stat_2" class="gt_row gt_center">80</td>
<td headers="p.value" class="gt_row gt_center"><br /></td></tr>
  </tbody>
  &#10;  <tfoot class="gt_footnotes">
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>1</sup></span> n (%)</td>
    </tr>
    <tr>
      <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;"><sup>2</sup></span> Pearson’s Chi-squared test</td>
    </tr>
  </tfoot>
</table>
</div>

## Correlation

`corrr::correlate()`: computing Pearson, Kendall tau or Spearman rho
correlation

``` r
data %>% select(generation, age, ct_blood) %>%
        corrr::correlate()
```

    ## Correlation computed with
    ## • Method: 'pearson'
    ## • Missing treated using: 'pairwise.complete.obs'

    ## # A tibble: 3 × 4
    ##   term       generation      age ct_blood
    ##   <chr>           <dbl>    <dbl>    <dbl>
    ## 1 generation    NA      -0.0222   0.179  
    ## 2 age           -0.0222 NA        0.00849
    ## 3 ct_blood       0.179   0.00849 NA

``` r
# remove duplicate entries
data %>% select(generation, age, ct_blood) %>%
        corrr::correlate() %>%
        shave()
```

    ## Correlation computed with
    ## • Method: 'pearson'
    ## • Missing treated using: 'pairwise.complete.obs'

    ## # A tibble: 3 × 4
    ##   term       generation      age ct_blood
    ##   <chr>           <dbl>    <dbl>    <dbl>
    ## 1 generation    NA      NA             NA
    ## 2 age           -0.0222 NA             NA
    ## 3 ct_blood       0.179   0.00849       NA

``` r
# rmarkdown::render()
```
