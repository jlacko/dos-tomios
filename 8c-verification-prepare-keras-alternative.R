# ověřit funkčnost na Kerasu s větší parádou: připravit slovník a matici 150 × počet tweetů

library(tidyverse)

# nový slovník nevytvářím, použiju původní

slovnik <- readr::read_csv('./data/slovnik.csv')

# nejvíce "slov" na tweet - ověření počtu sloupců matice

nejvic_slov <- readr::read_csv('./data/nova-slova.csv') %>%
  count(id) %>%
  pull(n) %>%
  max()

print(paste('Nejvíc bylo', nejvic_slov, 'slov, vstup o 150 sloupcích je', ifelse(nejvic_slov<150,'cajk','málo')))

# pomocný data frame - pro doplnění slov na 150 sloupců

vata <- expand.grid(id = unique(readr::read_csv('./data/nova-slova.csv')$id),
                    no_slovo = 1:150,
                    id_slovo = 0)

# data frame, co bude vstupní maticí
  
word_matrix <- readr::read_csv('./data/nova-slova.csv') %>% # slova z nových tweetů
  inner_join(slovnik, by = c('lemma' = 'lemma')) %>% # filtrovací join = slova, co nejsou ve slovníku vypadnou
  select(id, lemma, id_slovo) %>%
  group_by(id) %>%
  mutate(no_slovo = row_number()) %>% # pořadí slova ve větě - bude sloupec matice
  ungroup() %>%
  select(id, no_slovo, id_slovo) %>% # relevantní sloupce
  rbind(vata) %>% # připravená vata
  group_by(id,no_slovo) %>%
  mutate(id_slovo = max(id_slovo)) %>% # vytvoří duplicity; potřeba unique()
  ungroup() %>%
  unique() %>% # protože v mutate byly duplicity...
  spread(no_slovo, id_slovo) # do široka...

keras_input <- readr::read_csv('./data/nove-tweety.csv') %>%
  select(id, name, text) %>%
  inner_join(word_matrix, by = c('id' = 'id'))

write_csv(keras_input, './data/new-keras-matrix.csv')
  