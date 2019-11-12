library(purrr) # most functions called in this exercise are from this lib
library(magrittr)

my_list = list(
  c(1, 2, 3),
  c(2, 5, 8),
  c(12, 45, 102)
)

mean(my_list[[1]])
mean(my_list[[2]])
sum(my_list[[3]])


# They do all the same
map(my_list, mean)
map(my_list, function(x) mean(x))
lapply(my_list, mean)
a = map(my_list, ~ mean(.x))

View(a) # information about the object
class(a)
length(a)

# not to return list, there are 'friends' of map

map_dbl(my_list, mean) # input, output doubles
map_int(my_list, mean) # input, output integers, not working here, naturally

# walk over with no output

walk(my_list, mean)

# apply mean & median

b = map_dbl(my_list, ~{
  .x = .x * 3
  median(.x)
})

# pipe: Concept. Avoiding many assignments of objects. Invisibly apply object to the next function, without being stored as an object

a = my_list %>%       # my_list applied to the map-function
  map_dbl(mean) %>%
  map_dbl(~ .x * 3)

a = my_list %<>%       # assign the output in the input object
  map_dbl(mean) %>%
  map_dbl(~ .x * 3)

# how it was in the for-loop 

for (i in my_list) {
  mean(i)
}

# R

#applied to all objects in the vectors
# vectors, the same class insied
# all data types possible
# dataframe

data.frame(a = c(5, 2, 3), b = c(10, 2, 3))
