# Population Data for Dhaka, Bangladesh

Grid-based population of Dhaka, Bangladesh

## Usage

``` r
popBGD
```

## Format

A data frame with four variables:

- `psu`:

  primary sampling unit (PSU) ID

- `zone`:

  survey enumeration area

- `type`:

  slum (1) or non-slum (2)

- `pop`:

  population

## Examples

``` r
popBGD
#> # A tibble: 641 × 4
#>      psu  zone  type   pop
#>    <int> <int> <int> <dbl>
#>  1  1101     1     1   167
#>  2  1102     1     1    39
#>  3  1103     1     1    39
#>  4  1104     1     1   142
#>  5  1105     1     1    18
#>  6  1106     1     1    55
#>  7  1107     1     1    44
#>  8  1108     1     1    65
#>  9  1109     1     1    65
#> 10  1110     1     1   131
#> # ℹ 631 more rows
```
