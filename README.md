# washdata - Urban Water and Sanitation Survey Dataset

[![GitHub top language](https://img.shields.io/github/languages/top/validmeasures/washdata.svg)]()
[![GitHub release](https://img.shields.io/github/release/validmeasures/washdata.svg)](https://github.com/validmeasures/washdata/blob/master/NEWS.md)
[![Travis](https://img.shields.io/travis/validmeasures/washdata.svg?branch=master)](https://travis-ci.org/validmeasures/washdata)
[![Build status](https://ci.appveyor.com/api/projects/status/outyoi6bw8yqi0p1?svg=true)](https://ci.appveyor.com/project/ernestguevarra/washdata)
[![Github All Releases](https://img.shields.io/github/downloads/validmeasures/washdata/latest/total.svg)](https://github.com/validmeasures/washdata/archive/master.zip)
[![license](https://img.shields.io/github/license/validmeasures/washdata.svg)](https://github.com/validmeasures/washdata/blob/master/LICENSE.md)


This package contains four datasets from an urban water and sanitation survey in Dhaka, Bangladesh conducted by [Water and Sanitation for the Urban Poor](https://www.wsup.com) with technical support from [Valid International](http://www.validinternational.com) in March 2017.

* `popBGD:` Dataset on estimated population of each primary sampling unit (PSU) that were surveyed. This dataset is a mix of data from WorldPop (<http://www.worldpop.org.uk> for the non-slum areas and from the 2014 Bangladesh Census of Slum Areas and Floating Population.

* `ppiMatrixBGD:` Look-up table for calculating the Poverty Probability Index (previously called Progress out of Poverty Index) or PPI from Bangladesh-specific indicators collected from cross-sectional surveys. This look-up table is extracted from documentation of the PPI found at <https://www.povertyindex.org>

* `surveyDataBGD:` Dataset collected through the urban water and sanitation surveys conducted by [Water and Sanitation for the Urban Poor](https://www.wsup.com) in Dhaka, Bangladesh.

* `indicatorsDataBGD:` Dataset produced from `surveyDataBGD` by calculating relevant indicators on water, sanitation and hygiene as specified and defined by [Water and Sanitaiton for the Urban Poor](https://www.wsup.com)

This survey in Dhaka is one of a series of surveys to be conducted by [WSUP](https://www.wsup.com) in various cities in which they operate including Accra, Ghana; Nakuru, Kenya; Antananarivo, Madagascar; Maputo, Mozambique; and, Lusaka, Zambia. This package will be updated once the surveys in other cities are completed and datasets have been made available.

<br/>

## Installation

The package has been submitted for inclusion in the `CRAN` repository and is currently under review. Development version of the package is via GitHub:

```R
# Install the development version from GitHub
devtools::install_github("validmeasures/washdata")
library(washdata)
```
