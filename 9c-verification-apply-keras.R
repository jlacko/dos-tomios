# ověřit funkčnost na Keras modelu (opravdické AI :)

library(tidyverse)
library(keras)


# načíst data z csv

pred_data <- readr::read_csv('./data/novy-podklad-modelu.csv') %>%
  select(-id, -source)

x_pred <- data.matrix(pred_data %>% select(-name)) # všechno kromě odpovědi jako matice

# načíst model

model <- load_model_hdf5("./models/5-dense-layers.h5") # načíst...

# uplatnit model

pred <- model %>% # vektor pravděpodobnosti - inverval nula až jedna
  predict_proba(x_pred)

verifikace <- pred_data %>% # doplnit podle pořadi id tweetu, pravděpodobnost + vlastní tweet
  cbind(pred)


verifikace <- verifikace %>%
  mutate(pred_name = ifelse(pred>0.5, 'tomio_cz', 'Tomio_Okamura'))

conf_mtx <- table(verifikace$name, verifikace$pred_name)

print(paste('Správně předpovězeno',sum(diag(conf_mtx)), 'z',sum(conf_mtx), 'tweetů, což představuje', round(100 * sum(diag(conf_mtx))/sum(conf_mtx), 2), 'procent.'))
print(conf_mtx)