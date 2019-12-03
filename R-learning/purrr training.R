library(purrr)
library(dplyr)
library(tidyverse)

df = data.frame(
    v1 = c(-16, -1, -15, -17.5, -17),
    v2 = c(-17, -14, -13, -17.7, -19),
    v3 = c(-14, -13, -19, -17.4, -20),
    date = as.Date(c("25-4-16", "4-4-16", "3-4-15", "4-9-17", "3-1-2015")
    )
)
df

df_long = pivot_longer(df, -date)

df_long %>% 
    mutate(m = mean(df_long$value))



%>% 
    summarise(mean)


# ------------------------------------------------------------------------------
group_by
summarise(
       