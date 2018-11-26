library(dplyr)
library(tidytext)
library(gutenbergr)
gutenberg_works(title == "The Wonderful Wizard of Oz")
wizardOfOz <- gutenberg_download(55)
head( wizardOfOz )

tidyWizard <- wizardOfOz %>% unnest_tokens(word, text)
tidyWizard

# Exercise 1
gutenberg_works(title == "Treasure Island")
treasureIsland <- gutenberg_download(120)
tidyTreasureIsland <- unnest_tokens(treasureIsland, word, text)


tidyWizard %>% count(word, sort = TRUE)

tidyWizard <-  tidyWizard  %>% anti_join(stop_words)
tidyWizard %>% count(word, sort = TRUE)

character <- data.frame(word = c("dorothy", "scarecrow", "woodman", "lion", "tin") )
tidyWizard %>% 
  anti_join(character) %>% 
  count(word, sort = TRUE)

# Exercise 2
count(tidyTreasureIsland, word, sort=TRUE)
tidyTreasureIsland %>% 
  anti_join(stop_words) %>% 
  count(word, sort=TRUE)


sentiment <- get_sentiments(lexicon = "bing")
tidyWizard %>% inner_join(sentiment)

# Exercise 3
tidyTreasureIsland %>% 
  anti_join(stop_words) %>% 
  inner_join(sentiment) %>% 
  count(word, sentiment, sort=TRUE)

tidyTreasureIsland %>% 
  anti_join(stop_words) %>% 
  inner_join(sentiment) %>% 
  count(sentiment, sort=TRUE)


tidyWizardNgram <- wizardOfOz %>% unnest_tokens(word, text, token =   "ngrams", n = 2)
tidyWizardNgram  %>% count(word, sort = TRUE)

# Exercise 4
treasureIsland %>% 
  unnest_tokens(word, text, token =   "ngrams", n = 3) -> tidyTreasureTrigram
tidyTreasureTrigram %>% count(word, sort=TRUE)


library(wordcloud)
cloudWizard <-  wizardOfOz %>% unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)
wordcloud(cloudWizard$word,  cloudWizard$n, max.words = 50, colors ="red")

library(tidyr)
compCloud <- wizardOfOz %>% 
  unnest_tokens(word, text)%>%
  anti_join(stop_words) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  spread(sentiment, n, fill = 0) %>%  
  data.frame()

rownames(compCloud) <- compCloud$word
select(compCloud, - word) %>%
  comparison.cloud(colors = c("darkred", "darkgreen"), 
                   max.words = 100)

# Exercise 5
tidyTreasureIsland %>% 
  anti_join(stop_words) %>% 
  inner_join(sentiment) %>% 
  count(word, sentiment, sort=TRUE) -> treasureWordCount

treasureWordCount %>% 
  filter(sentiment=="positive") -> positiveWords

wordcloud(positiveWords$word, positiveWords$n, max.words=50, colors="blue")

treasureWordCount %>% 
  filter(sentiment=="negative") -> negativeWords

wordcloud(negativeWords$word, negativeWords$n, max.words=50, colors="red")

treasureWordCountSpread <- spread(treasureWordCount, sentiment, n, fill=TRUE)
row.names(treasureWordCountSpread) <- treasureWordCountSpread$word
select(treasureWordCountSpread, - word) %>%
   comparison.cloud(colors = c("darkred", "darkgreen"),  max.words = 100)

library(igraph)
library(ggraph)
tidyWizardNgram  <- wizardOfOz %>% 
  unnest_tokens(word, text, token = "ngrams", n = 2) %>%
  count(word, sort = TRUE) %>%
  separate(word, c("firstWord", "secondWord"), sep = " ") %>%
  anti_join(stop_words, by = c("firstWord" = "word")) %>%
  anti_join(stop_words, by = c("secondWord" = "word")) %>%
  filter(firstWord == "woodman")
iGraphObject <- tidyWizardNgram  %>%
  graph_from_data_frame()

ggraph(iGraphObject) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  geom_node_point()+
  geom_edge_link() 

