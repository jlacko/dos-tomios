# z dat v /data zpracuje testovací dataset jako vstup pro model

library(tidyverse)
library(readr)
library(rpart)

tweets <- read_csv('./data/nove-tweety.csv') %>%
  select(id, name, original, source) # jenom relevantní sloupce

words <- read_csv('./data/nova-slova.csv') %>%
  group_by(id) %>%
  summarise(# ignorované položky - youtube a vlasní jméno
            zminuje_youtube = sum(lemma == "YouTube"),
            zminuje_tomio = sum(lemma == "Tomio"),
            zminuje_okamura = sum(lemma == "Okamura"),
            # 6 vlastních jmen
            zminuje_ab_handle = sum(lemma == "AndrejBabis"),
            zminuje_babis = sum(lemma == "Babiš"),
            zminuje_cr = sum(lemma == "ČR"),
            zminuje_ovce_handle = sum(lemma == "PREZIDENTmluvci"),
            zminuje_spd = sum(lemma == "SPD"),
            zminuje_zeman = sum(lemma == "Zeman"),
            # 6 podstatných jmen
            zminuje_clovek = sum(lemma == "člověk"),
            zminuje_migrant = sum(lemma == "migrant"),
            zminuje_prezident = sum(lemma == "prezident"),
            zminuje_rok = sum(lemma == "rok"),
            zminuje_vlada = sum(lemma == "vláda"),
            zminuje_volba = sum(lemma == "volba"),
            # 6 přídavných jmen
            zminuje_cesky = sum(lemma == "český"),
            zminuje_dalsi = sum(lemma == "další"),
            zminuje_dobry = sum(lemma == "dobrý"),
            zminuje_islamsky = sum(lemma == "islámský"),
            zminuje_jiny = sum(lemma == "jiný"),
            zminuje_velky = sum(lemma == "velký"),
            # 3 zájména
            zminuje_ja = sum(lemma == "já"),
            zminuje_on = sum(lemma == "on"),
            zminuje_se = sum(lemma == "se"),
            
            sloves = sum(upos == 'VERB'), # počet sloves
            prislovci = sum(upos == 'ADV'), # počet příslovcí
            zajmen = sum(upos == 'PRON'), # počet zájmen
            vet = max(sentence_id) # celkem vět
            )

src_model <- words %>% 
  inner_join(tweets, by = c('id' = 'id'))

write_csv(src_model, './data/novy-podklad-modelu.csv')
