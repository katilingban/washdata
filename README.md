# washdata: Urban Water and Sanitation Survey Dataset <img src="man/figures/washdata.png" width="200" align="right" />

[![CRAN](https://img.shields.io/cran/v/washdata.svg)](https://CRAN.R-project.org/package=washdata)
[![CRAN](https://img.shields.io/cran/l/washdata.svg)](https://github.com/katilingban/washdata/blob/master/LICENSE.md)
[![CRAN](http://cranlogs.r-pkg.org/badges/washdata)](http://cran.rstudio.com/web/packages/washdata/index.html)
[![CRAN](http://cranlogs.r-pkg.org/badges/grand-total/washdata)](http://cran.rstudio.com/web/packages/washdata/index.html)
[![Travis](https://img.shields.io/travis/katilingban/washdata.svg?branch=master)](https://travis-ci.org/katilingban/washdata)
[![Build status](https://ci.appveyor.com/api/projects/status/outyoi6bw8yqi0p1?svg=true)](https://ci.appveyor.com/project/katilingban/washdata)


This package contains four datasets from an urban water and sanitation survey in Dhaka, Bangladesh conducted by [Water and Sanitation for the Urban Poor](https://www.wsup.com) with technical support from [Valid International](http://www.validinternational.com) in March 2017.

* `popBGD`: Dataset on estimated population of each primary sampling unit (PSU) that were surveyed. This dataset is a mix of data from [WorldPop](http://www.worldpop.org.uk) for the non-slum areas and from the [2014 Bangladesh Census of Slum Areas and Floating Population](<http://203.112.218.65:8008/PageWebMenuContent.aspx?MenuKey=423>).

* `ppiMatrixBGD`: Look-up table for calculating the `Poverty Probability Index` (previously called `Progress out of Poverty Index`) or `PPI` from Bangladesh-specific indicators collected from cross-sectional surveys. This look-up table is extracted from documentation of the `PPI` found at <https://www.povertyindex.org>

* `surveyDataBGD`: Dataset collected through the urban water and sanitation surveys conducted by [WSUP](https://www.wsup.com) in Dhaka, Bangladesh.

* `indicatorsDataBGD`: Dataset produced from `surveyDataBGD` by calculating relevant indicators on water, sanitation and hygiene as specified and defined by [WSUP](https://www.wsup.com)

This survey in Dhaka is one of a series of surveys to be conducted by [WSUP](https://www.wsup.com) in various cities in which they operate including Accra, Ghana; Nakuru, Kenya; Antananarivo, Madagascar; Maputo, Mozambique; and, Lusaka, Zambia. This package will be updated once the surveys in other cities are completed and datasets have been made available.

<br/>

## Installation

To install the package, type the following in R:

```R
install.packages("washdata")
library(washdata)
```

Install development version of the package via GitHub:

```R
remotes::install_github("katilingban/washdata")
library(washdata)
```
