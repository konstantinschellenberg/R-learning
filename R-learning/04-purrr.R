library(purrr)
library(magrittr)

my_list = list(
  c(1, 2, 6),
  c(5, 11, 3),
  c(4, 8, 10)
)

# Get the mean of all vectors manually -----------------------------------------

mean(my_list[[1]])
mean(my_list[[2]])
mean(my_list[[3]])

# Get the mean of all vectors using `map()` ------------------------------------

map(my_list, mean)

# Show `function(x)` notation
map(my_list, function(x) mean(x))

# Explain `.x` and tilde notation ----------------------------------------------

map(my_list, ~ mean(.x))

# Show `lapply()` way ----------------------------------------------------------

lapply(my_list, function(x) mean(x))

# Show type-safe returns (map_dbl() and friends) -------------------------------

map_dbl(my_list, mean)

# Show `walk()` for side effects -----------------------------------------------

walk(my_list, mean)

map(my_list, mean)

# Introduce the pipe -----------------------------------------------------------

my_list %>% 
  map(mean) %>% 
  map(exp)

# Show the same using a for loop -----------------------------------------------

for (i in my_list) {
  mean(i)
}

# What if we want to store the values? -----------------------------------------

# don't do this
out = c()

for (i in seq_along(my_list)) {
  out[i] = mean(my_list[[i]])
}
