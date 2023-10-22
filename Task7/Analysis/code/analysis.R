library(dplyr)
library(ggplot2)
library(tidytext)
library(reshape2)
library(wordcloud)
library(e1071)

set.seed(123456)

senators_td2 <- read.csv("../input/senators_td2.csv", stringsAsFactors = FALSE)
senators_bigram <- read.csv("../input/senators_bigram.csv", stringsAsFactors = FALSE)
senators_trigram <- read.csv("../input/senators_trigram.csv", stringsAsFactors = FALSE)
sen105_party <- read.csv("../input/sen105_party.csv", stringsAsFactors = FALSE)

# word count
wordlist <- senators_td2 %>% 
  count(word, sort = TRUE)

bigramlist <- senators_bigram %>% 
  count(bigram, sort = TRUE)

trigramlist <- senators_trigram %>% 
  count(trigram, sort = TRUE)

# distribution of the top 50 bigrams and 50 trigrams
bigramtop50 <- bigramlist %>% 
  filter(row_number() < 50) %>% 
  mutate(bigram = reorder(bigram,n)) %>% 
  ggplot(aes(bigram,n)) +  
  geom_bar(stat = "identity") + 
  xlab(NULL) +
  coord_flip()
ggsave("../outcome/bigramtop50.png", plot = bigramtop50) # save figure

trigramtop50 <- trigramlist %>% 
  filter(row_number() < 50) %>% 
  mutate(trigram = reorder(trigram,n)) %>% 
  ggplot(aes(trigram,n)) +  
  geom_bar(stat = "identity") + 
  xlab(NULL) +
  coord_flip()
ggsave("../outcome/trigramtop50.png", plot = trigramtop50) # save figure

# Frequencies by party
bigramlist_party <- senators_bigram %>% 
  inner_join(sen105_party) %>% 
  count(party,bigram, sort = TRUE) %>% 
  ungroup() %>% 
  bind_tf_idf(bigram,party,n)

trigramlist_party <- senators_trigram %>% 
  inner_join(sen105_party) %>% 
  count(party,trigram, sort = TRUE) %>% 
  ungroup() %>% 
  bind_tf_idf(trigram,party,n)

# wordcloud 
png("../outcome/wordcloud.png")
bigramlist_party %>% 
  select(bigram,party,n) %>% 
  acast(bigram ~ party, value.var = "n", fill = 0) %>% 
  comparison.cloud(colors = c("#66CCFF", "#EE0000"), max.word = 50)
dev.off()

# Bigram frequency by senator
bigramlist_senator <- senators_bigram %>% 
  inner_join(sen105_party) %>% 
  count(id, party,bigram, sort = TRUE) %>% 
  ungroup()

# Cast text into a Matrix Object
s <- bigramlist_senator %>% 
  cast_sparse(id, bigram, n)
s = s[order(rownames(s)),] # order rows by name to match ordering in y

# generate y
y = sen105_party[order(sen105_party$id),]
y <- as.matrix(y$party)
y <- as.factor(y)

# fit svm
svmfit = svm(s,y, kernel = "linear", cost = .1)
summary(svmfit)

beta <- drop(t(svmfit$coefs)%*%as.matrix(s)[svmfit$index,]) %>% 
  as.data.frame()
write.csv(beta, "../outcome/wordideology.csv", row.names = FALSE)
