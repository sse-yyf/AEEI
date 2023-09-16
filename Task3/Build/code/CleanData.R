# Packages
library(dplyr)
library(haven)
library(tidyr)

# Import Data
df <- read_dta("../input/WV6.dta")

df <- df %>%
  select(V2, V3, V130, V127, V45, V51, V52, V53)
df$country_name <- as_factor(df$V2)

# Clean Data
df <- df %>% drop_na()
df %>% summarise(
  across(everything(), ~sum(is.na(.x)))
)

df <- df %>%
  mutate(V130 = case_when(
    V130 == 1 ~ 4,
    V130 == 2 ~ 3,
    V130 == 3 ~ 2,
    V130 == 4 ~ 1,
    TRUE ~ V130 
  ))

#by_country_kmeans <- df %>%
#  group_by(country_name) %>%
#  summarize(Job = mean(V45, na.rm = TRUE),
#            Democracy = mean(V130, na.rm = TRUE)
#            ) 


by_country_pca <- df %>%
  group_by(country_name) %>%
  summarize(Job = mean(V45, na.rm = TRUE),
            Democracy = mean(V130, na.rm = TRUE),
            Strong_Leader = mean(V127,na.rm = TRUE),
            Poli_Leader = mean(V51,na.rm = TRUE),
            University = mean(V52,na.rm = TRUE),
            Business = mean(V53,na.rm = TRUE)
  ) 


#(by_country_kmeans, '../output/job_democracy.csv', row.names = FALSE)
#write.csv(by_country_kmeans, '../../Analysis/input/job_democracy.csv', row.names = FALSE)
write.csv(by_country_pca, '../output/selected_WV6.csv', row.names = FALSE)
write.csv(by_country_pca, '../../Analysis/input/selected_WV6.csv', row.names = FALSE)
