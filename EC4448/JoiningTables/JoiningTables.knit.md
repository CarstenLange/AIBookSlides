---
title: "GIS - Spatial Econometrics"
subtitle: "Joining two Tables"
format: 
  revealjs:
    echo: true
    code-fold: true
    incremental: false
    scrollable: true
---




## What Will You Learn {.scrollable}

- Load a csv table to *My Content*
- Add a table from *My Content* to a *Web Map*

- What a relational database is
- Joining two tables into one table based on matching observations
    - Left Join
    - Inner Join
    - Outer or Full Join (rarely used)
- Join a *FeatureLayer*'s table with a *Table* in a *Web Ma*p

## ArcGis Online: 

1.  Load  Web map from `SchoolQualityYourInitial` from *My Content*

**Problem:** No school quality reported

## Adding Table with School Quality to ArcGIS Online

**We start with:** Showing School Quality in R: `Schools.R` (this step is not required)

**Next:** You add CSV file with school quality:<br> `DataEC4448/DataSchoolQuality.csv` to *My Content*:

Content -\> New Item -\> . . . (as feature table)


## ArcGis Online: Add table to Map

1.  Load  Web map from `SchoolQualityYourInitial` from *My Content*
2.  Add Table (table icon on the left)
3.   Choose: `DataSchoolQuality`

**Problem:** One layer has no school quality and the SchoolQuality table has no location information.

**Solution:**  Both have a school identifier (CDS code). So, we can join them.



## Joining two Tables {.smaller .scrollable}

Programs that allow joining two tables are called **relational databases**


::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 10 × 3
      ID Item  Amount
   <dbl> <chr>  <dbl>
 1     1 Shoes    123
 2    22 Shirt     67
 3    22 Shoes     78
 4     3 Shoe     111
 5     5 Shirt     98
 6     3 Shoes     17
 7     5 Jeans     45
 8     5 Jeans     37
 9    27 Shoes     22
10     6 Shirt     11
```
:::
:::

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 6 × 5
     ID First  Last   Street       City  
  <dbl> <chr>  <chr>  <chr>        <chr> 
1     1 John   Doe    649 C Street Pomona
2    22 Joe    Dull   648 A Street Pomona
3     3 Jake   Dune   345 H Street Pomona
4     4 Hans   Meier  118 B Street Pomona
5     5 Anne   Scholz 120 B Street Pomona
6     6 Agatha Smith  876 G Street Pomona
```
:::
:::


## Joining two Tables (Left Join) {.smaller}

::: columns
::: {.column width="40%"}

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 10 × 3
      ID Item  Amount
   <dbl> <chr>  <dbl>
 1     1 Shoes    123
 2    22 Shirt     67
 3    22 Shoes     78
 4     3 Shoe     111
 5     5 Shirt     98
 6     3 Shoes     17
 7     5 Jeans     45
 8     5 Jeans     37
 9    27 Shoes     22
10     6 Shirt     11
```
:::
:::

:::

::: {.column width="60%"}

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 6 × 5
     ID First  Last   Street       City  
  <dbl> <chr>  <chr>  <chr>        <chr> 
1     1 John   Doe    649 C Street Pomona
2    22 Joe    Dull   648 A Street Pomona
3     3 Jake   Dune   345 H Street Pomona
4     4 Hans   Meier  118 B Street Pomona
5     5 Anne   Scholz 120 B Street Pomona
6     6 Agatha Smith  876 G Street Pomona
```
:::
:::

:::
:::

**Left Join**

. . .


::: {.cell}

```{.r .cell-code}
left_join(Orders,NameAdresses, by=join_by(ID==ID))
```

::: {.cell-output .cell-output-stdout}
```
# A tibble: 10 × 7
      ID Item  Amount First  Last   Street       City  
   <dbl> <chr>  <dbl> <chr>  <chr>  <chr>        <chr> 
 1     1 Shoes    123 John   Doe    649 C Street Pomona
 2    22 Shirt     67 Joe    Dull   648 A Street Pomona
 3    22 Shoes     78 Joe    Dull   648 A Street Pomona
 4     3 Shoe     111 Jake   Dune   345 H Street Pomona
 5     5 Shirt     98 Anne   Scholz 120 B Street Pomona
 6     3 Shoes     17 Jake   Dune   345 H Street Pomona
 7     5 Jeans     45 Anne   Scholz 120 B Street Pomona
 8     5 Jeans     37 Anne   Scholz 120 B Street Pomona
 9    27 Shoes     22 <NA>   <NA>   <NA>         <NA>  
10     6 Shirt     11 Agatha Smith  876 G Street Pomona
```
:::
:::


## Joining two Tables (Inner Join) {.smaller}

::: columns
::: {.column width="40%"}

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 10 × 3
      ID Item  Amount
   <dbl> <chr>  <dbl>
 1     1 Shoes    123
 2    22 Shirt     67
 3    22 Shoes     78
 4     3 Shoe     111
 5     5 Shirt     98
 6     3 Shoes     17
 7     5 Jeans     45
 8     5 Jeans     37
 9    27 Shoes     22
10     6 Shirt     11
```
:::
:::

:::

::: {.column width="60%"}

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 6 × 5
     ID First  Last   Street       City  
  <dbl> <chr>  <chr>  <chr>        <chr> 
1     1 John   Doe    649 C Street Pomona
2    22 Joe    Dull   648 A Street Pomona
3     3 Jake   Dune   345 H Street Pomona
4     4 Hans   Meier  118 B Street Pomona
5     5 Anne   Scholz 120 B Street Pomona
6     6 Agatha Smith  876 G Street Pomona
```
:::
:::

:::
:::

**Inner Join**

. . .


::: {.cell}

```{.r .cell-code}
inner_join(Orders,NameAdresses, by=join_by(ID==ID))
```

::: {.cell-output .cell-output-stdout}
```
# A tibble: 9 × 7
     ID Item  Amount First  Last   Street       City  
  <dbl> <chr>  <dbl> <chr>  <chr>  <chr>        <chr> 
1     1 Shoes    123 John   Doe    649 C Street Pomona
2    22 Shirt     67 Joe    Dull   648 A Street Pomona
3    22 Shoes     78 Joe    Dull   648 A Street Pomona
4     3 Shoe     111 Jake   Dune   345 H Street Pomona
5     5 Shirt     98 Anne   Scholz 120 B Street Pomona
6     3 Shoes     17 Jake   Dune   345 H Street Pomona
7     5 Jeans     45 Anne   Scholz 120 B Street Pomona
8     5 Jeans     37 Anne   Scholz 120 B Street Pomona
9     6 Shirt     11 Agatha Smith  876 G Street Pomona
```
:::
:::


## Joining two Tables (Outer Join)

::: columns
::: {.column width="40%"}

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 10 × 3
      ID Item  Amount
   <dbl> <chr>  <dbl>
 1     1 Shoes    123
 2    22 Shirt     67
 3    22 Shoes     78
 4     3 Shoe     111
 5     5 Shirt     98
 6     3 Shoes     17
 7     5 Jeans     45
 8     5 Jeans     37
 9    27 Shoes     22
10     6 Shirt     11
```
:::
:::

:::

::: {.column width="60%"}

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
# A tibble: 6 × 5
     ID First  Last   Street       City  
  <dbl> <chr>  <chr>  <chr>        <chr> 
1     1 John   Doe    649 C Street Pomona
2    22 Joe    Dull   648 A Street Pomona
3     3 Jake   Dune   345 H Street Pomona
4     4 Hans   Meier  118 B Street Pomona
5     5 Anne   Scholz 120 B Street Pomona
6     6 Agatha Smith  876 G Street Pomona
```
:::
:::

:::
:::

**Outer Join**

. . .


::: {.cell}

```{.r .cell-code}
full_join(Orders,NameAdresses, by=join_by(ID==ID))
```

::: {.cell-output .cell-output-stdout}
```
# A tibble: 11 × 7
      ID Item  Amount First  Last   Street       City  
   <dbl> <chr>  <dbl> <chr>  <chr>  <chr>        <chr> 
 1     1 Shoes    123 John   Doe    649 C Street Pomona
 2    22 Shirt     67 Joe    Dull   648 A Street Pomona
 3    22 Shoes     78 Joe    Dull   648 A Street Pomona
 4     3 Shoe     111 Jake   Dune   345 H Street Pomona
 5     5 Shirt     98 Anne   Scholz 120 B Street Pomona
 6     3 Shoes     17 Jake   Dune   345 H Street Pomona
 7     5 Jeans     45 Anne   Scholz 120 B Street Pomona
 8     5 Jeans     37 Anne   Scholz 120 B Street Pomona
 9    27 Shoes     22 <NA>   <NA>   <NA>         <NA>  
10     6 Shirt     11 Agatha Smith  876 G Street Pomona
11     4 <NA>      NA Hans   Meier  118 B Street Pomona
```
:::
:::




## Joining two Tables in ArcGis Online

1.  Back to the web map `SchoolQualityYourInitial`

If you have not done it already: 

2.  Add Table (table icon on the left)
3.   Choose: `DataSchoolQuality`
4.  both have a school identifier (CDS code)

Joining based on attributes/features:

5.  **Joining:** Analysis -\> Summarize Data -\> Join Features
Result Layer: `SchoolQualityWithAdrYourInitial` Folder: `EC4448Schools` 

**Save Web map!!!**

