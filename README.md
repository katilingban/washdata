# washdata - Urban Water and Sanitation Survey Dataset

[![Travis](https://img.shields.io/travis/validmeasures/washdata.svg)](https://travis-ci.org/validmeasures/washdata)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/validmeasures/washdata?branch=master&svg=true)](https://ci.appveyor.com/project/validmeasures/washdata)
[![codecov](https://codecov.io/gh/validmeasures/washdata/branch/master/graph/badge.svg)](https://codecov.io/gh/validmeasures/washdata)
[![GitHub top language](https://img.shields.io/github/languages/top/validmeasures/washdata.svg)]()
[![GitHub release](https://img.shields.io/github/release/validmeasures/washdata.svg)](https://github.com/validmeasures/washdata/blob/master/NEWS.md)
[![license](https://img.shields.io/github/license/validmeasures/washdata.svg)](https://github.com/validmeasures/washdata/blob/master/LICENSE.md)
[![Github All Releases](https://img.shields.io/github/downloads/validmeasures/washdata/latest/total.svg)](https://github.com/validmeasures/washdata/archive/master.zip)

This package contains four datasets from an urban water and sanitation survey in Dhaka Bangladesh conducted by [Water and Sanitation for the Urban Poor](https://www.wsup.com)

* `popBGD :` Dataset on estimated population of each primary sampling unit (PSU) that were surveyed. This dataset is a mix of data from WorldPop ([http://www.worldpop.org.uk](http://www.worldpop.org.uk)) for the non-slum areas and from the 2014 Bangladesh Census of Slum Areas and Floating Population ([http://arks.princeton.edu/ark:/88435/dsp01wm117r42q](http://arks.princeton.edu/ark:/88435/dsp01wm117r42q))

* `ppiMatrixBGD :` Look-up table for calculating the Poverty Probability Index (previously called Progress out of Poverty Index) or PPI from Bangladesh-specific indicators collected from cross-sectional surveys. This look-up table is extracted from documentation of the PPI found at [https://www.povertyindex.org](https://www.povertyindex.org)

* `surveyDataBGD :` Dataset collected through the urban water and sanitation surveys conducted by [Water and Sanitation for the Urban Poor](https://www.wsup.com) in Dhaka, Bangladesh.

* `indicatorsDataBGD :` Dataset produced from `surveyDataBGD` by calculating relevant indicators on water, sanitation and hygiene as specified and defined by [Water and Sanitaiton for the Urban Poor](https://www.wsup.com)

<br/>

## Installation

```R
# Install the development version from GitHub
devtools::install_github("validmeasures/washdata")
```

<br/>
<br/>
