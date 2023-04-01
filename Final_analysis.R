source("Funktioner.R")
library("tidyverse")
library("rLakeAnalyzer")

# 1 - Ekoln
# 2 - Skarven
# 3 - Görväln S
# 4 - S. Björkfjärden SO
# 5 - Granfj. Djurgårds Udde
# 6 - Galten 
# 7 - Västeråsfjärden N
# 8 - Svinnegarnsviken
# 9 - Ulvhällsfjärden
# 10 - Blacken
# 11 - Prästfjärden
plot_habitat(df_comp,
             temp_lim = 18,
             oxygen_lim = 2,
             station_number = 2)


