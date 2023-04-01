
sort_station <- function(df, station) {
  """ Sorts all unique stations in one dataframe. 
      Used in the plot_habitat function.
  Args: 
       df (str): Dataframe holding unsorted data
       station (str): Name of one unique station """ 
  df_new <- df[df$station == station,] 
  return(df_new)
}


sort_date <- function(df, date) {
  """ Sorts all unique dates to the corresponding station in unique dataframe.
      Used in the plot_habitat function.
  Args:
       df (str): Dataframe that holds data sorted by station
       date (str): String holding date of data collection """
  df_new <- df[df$datum == date,]
  return(df_new)
}

 
calc_delta <- function(interpol_2, interpol_1, df) {
  """ Calculates delta between two x-values from approx() and is used for 
      printing delta-value in the caption of the plot_habitat() function 
  Args:
       interpol_2 (num): Interpolated depthvalue for oxygen limit
       interpol_1 (num): Interpolated depthvalue for temperature limit
       df (str): Dataframe ordered by parameter"""
  # x2_tail gives the last value in the column syre  
  x2_tail <- tail(df$syre, n=1)
  # If there is no temp-value for temp_lim, set temp_lim to 0
  if (is.na(interpol_1$y)) {
    interpol_1$y <- 0
    # If there is no oxygen-value for oxygen_lim, use the last oxygen value
    # (x2_tail) as xout value in the approx() function 
  } else if (is.na(interpol_2$y)) {
    last_x2_val <- approx(df$syre, df$djup, xout = x2_tail, method = "linear")
    interpol_2$y <- last_x2_val$y
  }
  # Calculate delta
  delta <- interpol_2$y - interpol_1$y
  return(round(delta, 1))
}

  
plot_habitat <- function(df, temp_lim, oxygen_lim, station_number) {
""" Plots oxygen and temperature data for uniqe date in the dataframe of the 
   input station. Interpolates depth for input temperature limit and input 
   oxygen limit. Calculates delta value between depthvalues of the parameter 
   limits.
   
  Args: 
       df (str): Dataframe that holds parameter data for station and date
       temp_lim (num): Temperature limit for fish specie
       oxygen_lim (num): Oxygen limit for fish specie
       station_number (num): Index for a given station in df """ 
  
  # Split parameter to two unique dataframes
  split_parameter <- split(df, df$parameter)
  df_temp <- split_parameter$Vattentemperatur
  df_oxygen <- split_parameter$Syrgashalt
  
  # Create empty list to store data to be included in analysis
  list_removed <- list()
  list_saved <- list()
  
  # Loop station name index for every unique station
  for (station in unique(df$station)[station_number]) {
    station_sorted <- sort_station(df_oxygen, station) 
    
    # Loop date index for every uniqe date
    for (date in unique(station_sorted$datum)) {
      date_sorted <- sort_date(station_sorted, date)
      # All values in column 12 in df_comp, 
      # station == stat & datum == dat & parameter == "vattentemp"
      date_sorted$temp <- df[df$station == station &
                               df$datum == date &
                               df$parameter == "Vattentemperatur", 12]
      # Orders colnames
      date_sorted <- date_sorted[, c("station", "x_koordinat", "y_koordinat",
                                     "id", "datum", "djup",
                                     "varde",
                                     "temp")]
      # Changes colname "varde" to "syre".
      colnames(date_sorted)[7] <- "syre"
      # If a dataframe have less than 5 rows. Append to list_all_removed
      if (nrow(date_sorted) < 5){
        list_removed[[paste(station,"_",date,sep="")]] <- date_sorted
      # Else, append to list_saved
      }else {
        list_saved[[paste(station,"_",date,sep="")]] <- date_sorted
      }
    }
  }
  
  # Coeff = 1 to be used when formating second y-axis
  coeff = 1
  # Iterate trough the list of saved values 
  for (data in list_saved){
    
    # Interpolate the temp and oxygen curve at the input value. 
    # Ties is set to "max" and "min" since the "roof" is the temp and the 
    # "floor" is the oxygen limit for habitat. The approx() function only takes 
    # xout = () and not yout(). To interpolate the depth at a certain 
    # temperature or oxygen level use temp and oxygen as x-value in the function. 
    interpol_temp <- approx(data$temp, data$djup, xout = temp_lim,
                            method = "linear",
                            ties = "max")
    interpol_oxygen <- approx(data$syre, data$djup, xout = oxygen_lim,
                              method = "linear",
                              ties = "min")
    
    # To avoid large decimal output in the labels in the "geom_vline 
    # (annontate) for temp, round the value and use the rounded value to label 
    # the temperature. 
    temp_labels <- round(interpol_temp$x, 1)
    
    # Use ggplot to plot oxygen and temperature in the same plot
    plots <- ggplot(data, aes(x = djup))+
      geom_point(aes(y = syre, color = "grey"))+
      geom_point(aes(y = temp, color = "blue"))+
      
      # Use the y-value from the interpolation to place the line on the right
      # x-value on the graph. temp_labels is used to label the line. Use the
      # paste() function to combine strings and integers in the label.
      geom_vline(xintercept = interpol_temp$y, color = "red1")+
      annotate("text", x = interpol_temp$y-0.5, y = 23, angle = 90,
               label = paste(temp_labels, "C°"))+
      geom_vline(xintercept = interpol_oxygen$y, color = "blue")+
      annotate("text", x = interpol_oxygen$y+0.5, y = 23, angle = 90,
               label = paste(oxygen_lim, "mg/L"))+
      
      # Edit legend text and colour
      scale_color_manual(labels = c("Temperature", "Dissolved oxygen"),
                         values = c("red1", "blue"))+
      
      # Scale the y-axis and state inputs for second y-axis
      scale_y_continuous(limits = c(0, 25), breaks = c(6,10,14,18,22),
                         name = "Temperature C°",
                         sec.axis = sec_axis(~./coeff, name = "DO (mg/L)",
                                             breaks = c(2,6,10,14)))+
      
      # Edit labels in the plot 
      labs(title = data$station, subtitle = data$datum, x = "Depth (m)",
           col = "Parameter", tag = "DO limit - Temperature limit (m)",
           # Use the calc_delta() function to calculate the delta-value from
           # interpolation of oxygen and temperature limits. 
           caption = calc_delta(interpol_oxygen, interpol_temp, data))+
      
      # Format labels in the plot
      theme(plot.title = element_text(size = 20), plot.caption = element_text(
        size = 10, hjust = 0, colour ="green4", margin = margin(t=10)),
        axis.title.y.left = element_text(color = "red"),
        axis.title.y.right = element_text(color = "blue"),
        plot.tag.position = c(0.12, 0.03)
        
      )
    # Print outputs
    print(plots)
    print(data$station[1])
    print(data$datum[1])
    print(interpol_temp$y)
    print(interpol_oxygen$y)
    print("----------")
  }
}