
# Imports data 
station_data<-read.table(file.choose(),header=T,sep=";")

# Find names of the colums and the corresponding index
colnames(station_data)
# index: 1(Station), 5(X-kordinat), 6(Y-koordinat), 20(ProvId), 22(år), 
# 23(Månad), 24(Dag), 25(Djup), 29(Parameter), 30(Enhet), 31(Värde), 
# 35(Analysmetod) 

# Creates dataframe with only the parameters stated above
column_selection <- data.frame(
  station_data[1], 
  station_data[5], 
  station_data[6],  
  station_data[20],
  station_data[21], 
  station_data[22], 
  station_data[23],
  station_data[24], 
  station_data[25], 
  station_data[29], 
  station_data[30], 
  station_data[31], 
  station_data[35])

# Clean the dataframe from N/A values (Rows with empty cells)
clean_data <- na.omit(column_selection)

# In the excel-file i found a value not applicable with R (<7)
# The value have the "ProvId" - 942222
# Find the index of the row in colum "ProvId"([4]) with the which() function
# Temp and Syrgas is reported with the same "ProvId" 
# They have index 3239 and 6919 in the dataframe. Remove both. 
which(column_selection[4] == 942222)

# Indexing out "ProvId" - 942222 by creating a new dataframe
# "!=" and "," states that all values except 942222 shall be included
# "ProvId 747970 and 708939 lacks values for oxygen concentration. Remove. 
df_comp <- clean_data[clean_data$ProvId!="942222",]
df_comp <- df_comp[df_comp$ProvId!="747970",]
df_comp <- df_comp[df_comp$ProvId!="708939",] 



# Change all columnnames in df_comp to logical and easy access ones
colnames(df_comp) <- c("station", "x_koordinat", "y_koordinat", "id", "datum",
                       "ar", "manad", "dag", "djup", "parameter", "enhet",
                       "varde", "ISO")

# The column "varde" is a character vector, change to numeric 
df_comp$varde <- as.numeric(df_comp$varde) 