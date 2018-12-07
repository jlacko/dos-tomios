# prozkoumá a porovná frekvenci slov dle slovníc druhů - obrázky uloží do složky img

library(tidyverse)
library(readr)
library(ggrepel)
library(grid)
library(gridExtra)

tweets <- read_csv('./data/tweety.csv') %>%
  filter(original) # bez retweetů

words <- read_csv('./data/slova.csv') %>%
 mutate(upos = ifelse(lemma %in% c('prostřednictví', 'být'), 'CCONJ', upos)) # ať to neničí osu...


src_raw <- words %>% # syrový zdroj dat
  inner_join(tweets, by = c('id' = 'id'))

terminy <- src_raw %>% # nejčastější slova dle typu
  group_by(upos, lemma) %>%
  summarise(pocet = n()) %>%
  mutate(poradi = rank(desc(pocet), ties.method = "min")) %>%
  ungroup() %>%
  filter(upos %in% c('ADJ', 'NOUN', 'PROPN', 'VERB', 'ADV', 'PRON') & poradi <= 12) %>%
  pull(lemma) %>%
  unique()

frekvence <- src_raw %>%
  group_by(name) %>%
  mutate(tweetu_autora = n_distinct(id)) %>% # pro pronásobení
  ungroup() %>%
  filter(lemma %in% terminy) %>% # jenom ty zajímavé..
  select(id, lemma, upos, name, tweetu_autora) %>%
  group_by(lemma, upos, name, tweetu_autora) %>% # tj. bez IDčka...
  summarise(pocet = n()) %>%
  group_by(name, upos) %>%
  mutate(poradi = rank(desc(pocet), ties.method = "min"), # prostý počet
         frekvence = 1000 * pocet / tweetu_autora) %>% # frekvence na 1000 tweetů
  ungroup()

faceoff <- function(druh_slova, popisek) {
  
  freq_tmp <- frekvence %>%
    filter(upos == druh_slova) %>%
    select(name, lemma, frekvence) 
  
  nejvic <- freq_tmp %>% # nejvyšší z frekvencí = pravý horní roh grafu
    pull(frekvence) %>%
    max()
  
  freq_tmp <- freq_tmp %>%
    spread(key = name, value = frekvence, fill = 0) 
  
  
ggpChart <- ggplot(data = freq_tmp, aes(x = tomio_cz, 
                              y = Tomio_Okamura)) +
    geom_point() +
    geom_text_repel(aes(label = lemma), color = 'gray45') +
    geom_abline(intercept = 0, color = 'red', lty = 5, alpha = .7) +
    xlim(0, nejvic) + ylim (0, nejvic) +
    theme_bw() +
    coord_fixed() +
    theme(plot.title = element_text(hjust = 0.5, face="bold.italic", size = rel(1.7)))

ggpFinal <- grid.arrange(textGrob(paste('Zmínek', popisek, 'na tisíc tweetů'), 
                      gp = gpar(fontsize = 1.6*11, fontface = 'bold.italic')), 
             ggpChart, 
             heights = c(0.13, 1))

ggsave(paste0('./img/', druh_slova, '.png'), 
       plot = ggpFinal,
       width = 6, 
       height = 6, 
       units = "in", dpi = 100) # čiliže 600 × 600 px
  
}

faceoff('PROPN', 'vlastního jména') 
faceoff('NOUN', 'podstatného jména') 
faceoff('VERB', 'slovesa bez "být"') 
faceoff('ADJ', 'přídavného jména')
faceoff('ADV', 'příslovce') 
faceoff('PRON', 'zájména') 
