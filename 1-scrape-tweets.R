# stahne tweety, ukáže počty a uloží dataset do složky data

library(tidyverse)
library(rtweet)

# soubor je gitignorován coby nerelevantní; postup získání a uložení tokenu
# je popsán na dokumentaci package rtweet: https://rtweet.info/#create-an-app
twitter_token <- readRDS("token.rds")

tweets <- get_timelines(c("tomio_cz", "Tomio_Okamura"), # tomio_cz = pravý, Tomio_Okamura = falešný
                        n = 10000, 
                        token = twitter_token) %>% 
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

write_csv(tweets, './data/tweety.csv')