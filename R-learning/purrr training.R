# library(purrr)
library(dplyr)
library(tidyverse)
library(tidyr)
library(readr)

# vignette to pivot
relig_income

length(names(relig_income))

x = pivot_longer(relig_income, -religion, names_to = "income", values_to = "however")

relig_income %>% 
    pivot_longer(-religion, names_to = "income", values_to = "value") %>% 
    View()

billboard

billboard %>% 
    pivot_longer(
        cols = starts_with("wk"), 
        names_to = "week", 
        names_prefix = "wk",
        names_ptypes = list(week = integer()),
        values_to = "rank",
        values_drop_na = TRUE,
    ) %>% 
    View()



df

# transform to long table, required by serveral dplyr applications
df_long = pivot_longer(df, -date)

df_long

df_long %>% 
    mutate(m = mean(df_long$value))



%>% 
    summarise(mean)


# ------------------------------------------------------------------------------
group_by
summarise(
       