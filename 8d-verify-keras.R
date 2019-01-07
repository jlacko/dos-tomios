# verifikace modelu - pro zjednodušení předpokládá v paměti načtený model jako objekt model = source 7b-apply-keras-alternative.R

pred_data <- readr::read_csv('./data/new-keras-matrix.csv') %>%
  select(id, name, text)

train_data <- readr::read_csv('./data/new-keras-matrix.csv') %>%
  mutate(pravy_tomio = ifelse(name == 'tomio_cz', 1,0)) %>% # klasifikace = potřebuju binární výstup
  select(-id, -name, -text)

x_pred <- data.matrix(train_data %>% select(-pravy_tomio)) # všechno kromě targetu jako matice

pred <- model %>% # vektor pravděpodobnosti - inverval nula až jedna
  predict_proba(x_pred)

verifikace <- pred_data %>% # doplnit podle pořadi id tweetu, pravděpodobnost + vlastní tweet
  cbind(pred) %>%
  left_join(tweets, by = c('id' = 'id'))

write_csv(verifikace, './data/verifikace.csv') # uložit pro budoucí použití