library(tm)
library(tidytext)
library(dplyr)
library(stringr)
library(tidyr)

# import txt file
senator_corpus = VCorpus(
  DirSource(
    directory = "../input/105-extracted-date"
    )
  )


# reshape the txt file into dataframe
senators_td2 = senator_corpus %>%
  tidy() %>% 
  select(id,text) %>% 
  mutate(id = str_match(id,"-(.*).txt")[,2]) %>% 
  unnest_tokens(word, text) %>% 
  group_by(id) %>% 
  mutate(row = row_number()) %>% 
  ungroup()

# import senator party labels and make them in lower case 
sen105_party <- read.csv("../input/sen105_party.csv", stringsAsFactors = FALSE)

names = sen105_party %>% 
  mutate(word=tolower(lname)) %>% 
  select(word)

states = as.data.frame(c(tolower(state.abb),tolower(state.name)))
colnames(states) <- "word"

# remove non-alphabetic characters, stopwords, senator and state names
droplist = c("text", "doc", "docno")
dropwords <- read.table("../input/droplist.txt",header=TRUE,sep="\n")
senators_td2 = senators_td2 %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  drop_na(word) %>% 
  filter(!(word %in% droplist)) %>% 
  anti_join(stop_words) %>% 
  anti_join(names) %>% 
  anti_join(states) %>% 
  anti_join(dropwords)

# create df for bigram
senators_bigram = senators_td2 %>% 
  arrange(id,row) %>% 
  group_by(id) %>% 
  mutate(bigram = str_c(lag(word,1),word, sep = " ")) %>% 
  filter(row == lag(row,1) + 1) %>% 
  select(-word) %>% 
  ungroup()

# create df for trigram
senators_trigram = senators_td2 %>% 
  arrange(id,row) %>% 
  group_by(id) %>% 
  mutate(trigram = str_c(lag(word,2),lag(word,1), word, sep = " ")) %>% 
  filter(row == lag(row,1) + 1 & lag(row,1) == lag(row,2) + 1) %>% 
  select(-word) %>% 
  ungroup()

# get new columns by id
split_id <- strsplit(senators_td2$id, "-")
senators_td2$lname <- sapply(split_id, function(x) x[1])
senators_td2$stateab <- sapply(split_id, function(x) x[2])
split_id <- strsplit(senators_bigram$id, "-")
senators_bigram$lname <- sapply(split_id, function(x) x[1])
senators_bigram$stateab <- sapply(split_id, function(x) x[2])
split_id <- strsplit(senators_trigram$id, "-")
senators_trigram$lname <- sapply(split_id, function(x) x[1])
senators_trigram$stateab <- sapply(split_id, function(x) x[2])

# change sen105_party to lowercase
sen105_party$stateab <- tolower(sen105_party$stateab)
sen105_party$lname <- tolower(sen105_party$lname)
sen105_party$id <- paste(sen105_party$lname, sen105_party$stateab, sep = "-")

# save files
write.csv(senators_td2, "../output/senators_td2.csv", row.names = FALSE)
write.csv(sen105_party, "../output/sen105_party.csv", row.names = FALSE)
write.csv(senators_bigram, "../output/senators_bigram.csv", row.names = FALSE)
write.csv(senators_trigram, "../output/senators_trigram.csv", row.names = FALSE)

# also save in Analysis/input folder
write.csv(senators_td2, "../../Analysis/input/senators_td2.csv", row.names = FALSE)
write.csv(sen105_party, "../../Analysis/input/sen105_party.csv", row.names = FALSE)
write.csv(senators_bigram, "../../Analysis/input/senators_bigram.csv", row.names = FALSE)
write.csv(senators_trigram, "../../Analysis/input/senators_trigram.csv", row.names = FALSE)

