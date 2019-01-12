# spustí verifikační sekvenci

# získat data
source('8a-verification-scrape-new-tweets.R') # stahnout tweety

# zpracovat data
source('8b-verification-extract-new-words.R') # rozbít na slova
source('9a-verification-prepare-for-rpart.R') # podklad pro rpart a 'malý' keras
source('8c-verification-prepare-keras-alternative.R') # matice pro 'velký' slovníkový keras

# provézd modely
source('9b-verification-apply-rpart.R') # strom
source('9c-verification-apply-keras.R') # malý keras nad daty stromu
source('8d-verification-apply-keras-alternative.R') # velký keras nad slovy
