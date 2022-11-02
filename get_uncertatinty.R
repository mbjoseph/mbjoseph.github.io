library(dplyr)
library(readr)

d <- read_csv("~/Downloads/22a_10mo_uncertainty.csv")
d
plot(sort(d$uncertainty))

d |>
  slice_max(uncertainty, n = 100) |>
  pull(file) |>
  paste(collapse="', '")
