# ověřit funkčnost na Keras modelu (opravdické AI :)

library(tidyverse)
library(keras)


# načíst data z csv

train_data <- readr::read_csv('./data/podklad-modelu.csv') %>%
  mutate(pravy_tomio = ifelse(name == 'tomio_cz', 1,0)) %>% # klasifikace = potřebuju binární výstup
  select(-id, -name, -source)

x_train <- data.matrix(train_data %>% select(-pravy_tomio)) # všechno kromě targetu jako matice
y_train <- data.matrix(train_data %>% select(pravy_tomio)) # jenom target

# deklarovat model

model <- keras_model_sequential() 

model %>% 
  layer_dense(units = 50, activation = 'relu', input_shape = c(ncol(x_train))) %>% # tolik vstupů, kolik má input matrix sloupců
  layer_dense(units = 40, activation = 'relu') %>%
  layer_dense(units = 30, activation = 'relu') %>%
  layer_dense(units = 20, activation = 'relu') %>%
  layer_dense(units = 1, activation = 'sigmoid') # jeden výstup (pravděpodobnost, že Tomio je pravý)

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics = c("accuracy")
)


# natrénovat model
history <- model %>% 
  fit(
    x_train, y_train, 
    epochs = 50, batch_size = 750, # ale i tisíc může být...
    validation_split = 0.15
  )

png(filename = "./img/keras.png", width = 800, height = 600)
plot(history)
dev.off()

print(paste0("Přesnost: ", as.character(formatC(100 * last(history$metrics$acc), digits = 2, format = "f")), "%"))

model %>% 
  save_model_hdf5("./models/5-dense-layers.h5")