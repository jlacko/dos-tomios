# na testovací dataset uplatní uložený strom o výsledku podá zprávu

library(tidyverse)
library(rpart)
library(rpart.plot)
library(RColorBrewer)


strom_data <- read_csv('./data/novy-podklad-modelu.csv') %>% # testovací dataset
  select(-id, -source) # sloupce, které *nemají* být brány v potaz při modelování

strom <- readRDS('./models/strom.rds')

pred <- predict(strom, strom_data, type = "class")

conf_mtx <- table(strom_data$name, pred)

print(paste('Správně předpovězeno',sum(diag(conf_mtx)), 'z',sum(conf_mtx), 'tweetů, což představuje', round(100 * sum(diag(conf_mtx))/sum(conf_mtx), 2), 'procent.'))
print(conf_mtx)