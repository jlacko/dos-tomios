# načte dataset tweetů a rozbije ho do datasetu slov, který uloží do složky data

library(tidyverse)
library(udpipe)

posledni_udpipe <- 'czech-pdt-ud-2.3-181115.udpipe' # (zatím) poslední verze na netu

if (!file.exists(posledni_udpipe)) udpipe_download_model(language = "czech") # stačí jednou, má to přes 50 mega..

udmodel <- udpipe_load_model(file = posledni_udpipe) # načtení modelu pro udpipe

tweets <- read_csv('./data/tweety.csv') # tweety uložené z prvního kroku

vlastni_jmena <- c('YouTube', 'Tomio', 'Okamura', 'BlanikZ',
                   'PREZIDENTmluvci', 'Zeman', 'Babiš', 'AndrejBabis', 'EU')

words <- udpipe_annotate(udmodel, x = tweets$text, doc_id = tweets$id) %>% # UDPIPE provede svojí magii...
  as.data.frame() %>%
  select(id = doc_id, token, lemma, upos, sentence_id) %>%
  mutate(lemma = ifelse(is.na(lemma), token, lemma)) %>% # když není lemma tak token
  mutate(upos = ifelse(is.na(upos), 'CONJ', upos)) %>% # když není upos tak default
  mutate(upos = ifelse(lemma %in% c('být', 'chtít', 'mít', 'dělat'), 'VERB', upos)) %>%
  mutate(upos = ifelse(lemma %in% c('pan', 'televize'), 'NOUN', upos)) %>% #
  mutate(upos = ifelse(lemma %in% c('s'), 'CONJ', upos)) %>% #
  mutate(upos = ifelse(lemma %in% c('velký', 'český', 'jiný', 'dobrý', 'celý'), 'ADJ', upos)) %>% # 
  mutate(upos = ifelse(lemma %in% c('rád', 'také'), 'ADV', upos)) %>% # 
  mutate(upos = ifelse(lemma %in% c('každý', 'také', 'já','on', 'se', 'ty', 'kdo'), 'PRON', upos)) %>% # 
  mutate(lemma = ifelse(lemma == 'YouTubat', 'YouTube', lemma)) %>% # nejde o oslovení ani volání
  mutate(lemma = ifelse(lemma == 'PREZIDENTmluvec', 'PREZIDENTmluvci', lemma)) %>% # mluvčí, ne množné číslo
  mutate(upos = ifelse(lemma %in% vlastni_jmena, 'PROPN', upos)) # problematická vlastní jména

print(paste('Zpracováno', nrow(words), 'slov, odpovídá', nrow(words)/250, 'normostranám a',
            nrow(words)/(250*70), 'diplomkám na VŠE'))

write_csv(words, './data/slova.csv')