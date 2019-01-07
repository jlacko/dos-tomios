# stahne tweety mladší, než datum stažení trénovacího setu,
# ukáže počty a uloží dataset do složky data

library(tidyverse)
library(rtweet)

# soubor je gitignorován coby nerelevantní; postup získání a uložení tokenu
# je popsán na dokumentaci package rtweet: https://rtweet.info/#create-an-app
twitter_token <- readRDS("token.rds")

posledni <- read_csv('./data/tweety.csv') %>%
  select(name, id) %>%
  group_by(name) %>%
  transmute(id = max(id)) %>%
  unique()

pravy <- get_timeline("tomio_cz", # dosud neznámé tweety Okamury s vlaječkou
                      n = 10000, 
                      since_id = posledni[posledni$name == "tomio_cz",2]$id,
                      token = twitter_token) 

falesny <- get_timeline("Tomio_Okamura", # dosud neznámé tweety Okamury s obrázkem
                      n = 10000, 
                      since_id = posledni[posledni$name == "Tomio_Okamura",2]$id,
                      token = twitter_token) 

tweets <- pravy %>%
  rbind(falesny) %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", "")) %>% # neužitečné znaky
  mutate(original = !is_retweet) %>% # originál = není retweet
  select(id = status_id, 
         name = screen_name, 
         created = created_at,
         text, 
         source,
         lajku = favorite_count,
         retweetu = retweet_count,
         original)

print(table(tweets$original, tweets$name)) # kolik se chytilo textu? a kolik z toho originálního?

write_csv(tweets, './data/nove-tweeety.csv')