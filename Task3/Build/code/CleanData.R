# Packages
library(dplyr)
library(haven)
library(tidyr)

# Import Data
df_org <- read_dta("../input/WV6.dta")
df_org$country_name <- as_factor(df_org$V2)
df <- df_org %>%
  select(V45:V56,V95:V124,V127:V140, country_name)


# Clean Data
df <- df %>% drop_na()
df %>% summarise(
  across(everything(), ~sum(is.na(.x)))
)

by_country <- df %>%
  group_by(country_name) %>%
  summarise(across(starts_with("V"), mean, na.rm = TRUE))

t_by_country <- by_country %>% 
                  t() %>% 
                  as.data.frame()
colnames(t_by_country) <- t_by_country[1, ]
t_by_country <- t_by_country[-1, ]
t_by_country$Variables <- rownames(t_by_country)

write.csv(by_country, '../output/by_country.csv', row.names = FALSE)
write.csv(by_country, '../../Analysis/input/by_country.csv', row.names = FALSE)
write.csv(t_by_country, '../output/t_by_country.csv', row.names = FALSE)
write.csv(t_by_country, '../../Analysis/input/t_by_country.csv', row.names = FALSE)
