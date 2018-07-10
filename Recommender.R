library(tidyverse)
load("amazon_grocery_sample.rda")
meta = meta_sample %>% as_tibble %>% select(asin, text)
View(head(meta))

install.packages("quanteda")
library(quanteda)
c = corpus(meta, docid_field = "asin", text_field = "text")
dfm = dfm(c, tolower = T, remove = stopwords("english"), remove_punct=T, remove_symbols=T, remove_numbers=T) %>% 
  dfm_trim(min_docfreq = .001, max_docfreq=.7, docfreq_type="prop")
textplot_wordcloud(dfm, max_words = 100)

simil = as.matrix(textstat_simil(dfm, method = "cosine"))
View(head(sort(simil[3,], decreasing = T)))

meta %>% filter(asin == "B009WNO6YC")


library(tidyverse)
reviews = reviews_sample %>% as_tibble %>% select(asin, reviewerID, overall) 
reviews = reviews %>% group_by(reviewerID) %>% mutate(score=overall-mean(overall)) %>% arrange(reviewerID) %>% ungroup()

head(sort(table(reviews$reviewerID), decreasing = T))

combined = reviews %>% filter(reviewerID == "A3OXHLG6DIBRW8") %>% select(asin, score) %>% left_join(meta)
combined

ranked = simil[, combined$asin]
predictions = ranked %*% combined$score
predictions = as.tibble(predictions, rownames = "asin") %>% rename(prediction=V1) %>% arrange(desc(prediction)) 

predictions = predictions %>% left_join(combined %>% select(asin, score)) %>% left_join(meta)
predictions


cor.test(predictions$prediction, predictions$score)
