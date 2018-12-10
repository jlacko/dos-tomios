# na trénovací dataset uplatní jednoduchý strom; podá zprávu a uloží obrázek do /img

library(tidyverse)
library(rpart)
library(rpart.plot)
library(RColorBrewer)


strom_data <- read_csv('./data/podklad-modelu.csv') %>% # trénovací dataset
  select(-id, -source) # sloupce, které *nemají* být brány v potaz při modelování

parametry_vypoctu <- rpart.control(minbucket = 15, # nejmenší uplatněný škopek (ovlivňuje hodně)
                                   cp = 0.005) # parametr složitosti výpočtu (ovlivňuje spíš míň)

strom <- rpart(data = strom_data, formula = name ~ ., method = "class", 
               control = parametry_vypoctu, maxdepth = 10)

png(filename = "./img/decision-tree.png", width = 1000, height = 600)
rpart.plot(strom, box.palette = "RdYlGn", branch.lty = 2, left = F, extra = 2)
dev.off()

pred <- predict(strom, strom_data, type = "class")

tblStrom <- table(strom_data$name, pred)

print(paste0("Přesnost: ", as.character(formatC(100 * sum(diag(tblStrom))/sum(tblStrom)), digits = 2, format = "f"), "%"))