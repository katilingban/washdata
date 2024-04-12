
<!-- README.md is generated from README.Rmd. Please edit that file -->

# washdata: Urban Water and Sanitation Survey Dataset <img src="man/figures/logo.png" width="200" align="right" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/micronutr)](https://CRAN.R-project.org/package=micronutr)
[![CRAN](https://img.shields.io/cran/l/washdata.svg)](https://github.com/katilingban/washdata/blob/master/LICENSE.md)
[![CRAN](http://cranlogs.r-pkg.org/badges/washdata)](https://cran.r-project.org/package=washdata)
[![CRAN](http://cranlogs.r-pkg.org/badges/grand-total/washdata)](https://cran.r-project.org/package=washdata)
[![R-CMD-check](https://github.com/katilingban/washdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/katilingban/washdata/actions/workflows/R-CMD-check.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/katilingban/washdata/badge)](https://www.codefactor.io/repository/github/katilingban/washdata)
[![DOI](https://zenodo.org/badge/115544360.svg)](https://zenodo.org/doi/10.5281/zenodo.4058889)
<!-- badges: end -->

This package contains four datasets from an urban water and sanitation
survey in Dhaka, Bangladesh conducted by [Water and Sanitation for the
Urban Poor](https://wsup.com) with technical support from [Valid
International](http://www.validinternational.org) in March 2017.

- `popBGD`: Dataset on estimated population of each primary sampling
  unit (PSU) that were surveyed. This dataset is a mix of data from
  [WorldPop](https://www.worldpop.org) for the non-slum areas and from
  the [2014 Bangladesh Census of Slum Areas and Floating
  Population](https://dataspace.princeton.edu/handle/88435/dsp01wm117r42q).

- `ppiMatrixBGD`: Look-up table for calculating the
  `Poverty Probability Index` (previously called
  `Progress out of Poverty Index`) or `PPI` from Bangladesh-specific
  indicators collected from cross-sectional surveys. This look-up table
  is extracted from documentation of the `PPI` found at
  <https://www.povertyindex.org>

- `surveyDataBGD`: Dataset collected through the urban water and
  sanitation surveys conducted by WSUP in Dhaka, Bangladesh.

- `indicatorsDataBGD`: Dataset produced from `surveyDataBGD` by
  calculating relevant indicators on water, sanitation and hygiene as
  specified and defined by WSUP

This survey in Dhaka is one of a series of surveys to be conducted by
WSUP in various cities in which they operate including Accra, Ghana;
Nakuru, Kenya; Antananarivo, Madagascar; Maputo, Mozambique; and,
Lusaka, Zambia. This package will be updated once the surveys in other
cities are completed and datasets have been made available.

## Installation

To install the package, issue the following commands in R:

``` r
install.packages("washdata")
```

Install development version of the package via GitHub:

``` r
# if (!require) remotes install.packages("remotes")
remotes::install_github("katilingban/washdata")
```

## Citation

If you find the `washdata` package useful please cite using the
suggested citation provided by a call to the `citation()` function as
follows:

``` r
citation("washdata")
#> To cite washdata in publications use:
#> 
#>   Ernest Guevarra (2024). _washdata: Urban Water and Sanitation Survey
#>   Dataset_. doi:10.5281/zenodo.4058890
#>   <https://doi.org/10.5281/zenodo.4058890>, R package version 0.1.4,
#>   <https://katilingban.io/washdata/>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {washdata: Urban Water and Sanitation Survey Dataset},
#>     author = {{Ernest Guevarra}},
#>     year = {2024},
#>     note = {R package version 0.1.4},
#>     url = {https://katilingban.io/washdata/},
#>     doi = {10.5281/zenodo.4058890},
#>   }
```

## Community guidelines

Feedback, bug reports and feature requests are welcome; file issues or
seek support [here](https://github.com/katilingban/washdata/issues). If
you would like to contribute to the package, please see our
[contributing
guidelines](https://katilingban.io/washdata/CONTRIBUTING.html).

This project is released with a [Contributor Code of
Conduct](https://katilingban.io/washdata/CODE_OF_CONDUCT.html). By
participating in this project you agree to abide by its terms.
