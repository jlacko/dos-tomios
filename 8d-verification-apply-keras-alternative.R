# verifikace modelu - načte Keras model z adresáře keras a uplatní ho na data o nově stažených tweetech

library(tidyverse)
library(keras)

model <- load_model_hdf5("./models/bi-ltsm.h5") # načíst...

summary(model) # vytisknout shrnutí

pred_data <- readr::read_csv('./data/new-keras-matrix.csv') %>%
  select(id, name, text)

train_data <- readr::read_csv('./data/new-keras-matrix.csv') %>%
  mutate(pravy_tomio = ifelse(name == 'tomio_cz', 1,0)) %>% # klasifikace = potřebuju binární výstup
  select(-id, -name, -text)

x_pred <- data.matrix(train_data %>% select(-pravy_tomio)) # všechno kromě targetu jako matice

pred <- model %>% # vektor pravděpodobnosti - inverval nula až jedna
  predict_proba(x_pred)

verifikace <- pred_data %>% # doplnit podle pořadi id tweetu, pravděpodobnost + vlastní tweet
  cbind(pred)

write_csv(verifikace, './data/verifikace.csv') # uložit pro budoucí použití

print(paste('Do /data/verifikace.csv uloženo', nrow(x_pred), 'namodelovaných řádků.'))

verifikace <- verifikace %>%
  mutate(name_pred = ifelse(pred>0.5, 'tomio_cz', 'Tomio_Okamura'))

conf_mtx <- table(verifikace$name, verifikace$name_pred)

print(paste('Správně předpovězeno',sum(diag(conf_mtx)), 'z',sum(conf_mtx), 'tweetů, což představuje', round(100 * sum(diag(conf_mtx))/sum(conf_mtx), 2), 'procent.'))
print(conf_mtx)