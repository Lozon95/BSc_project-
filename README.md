# Vendace habitat analysis during summer stratification 

This repository contains code from the programming part of my BSc thesis project in Bioscience at the University of Skövde. The project analysed Vendace habitat during the summer when the habitat volume was at it´s lowest during a five year period.  


## Project Aim

The aim of this project was:

To calculate and visualise Vendace habitat during the most stressed measuring occasion over a five year period.


## Repository Contents

This repository contains the following files:

- `README.md`: This file, which provides an overview of the project.
- `Clean_and_qualitycheck_BCs/`: Contains the code used to qualitycheck and clean the data in R.
- `Functions_BCs/`: Contains the code for the functions that was created and used in R.
- `Analysis_BCs/`: Contains the code for analysis in R.
- `Photoshop_and_QGIS_Workflow_BCs/`: A pdf with the complete workflow with function - input/output in Ps and QGIS
- `QGIS_Reclassify_Görveln_BCs/`: Contains the code for reclassification of the station Görveln in QGIS.
- `QGIS_Reclassify_Skarven_BCS/`: Contains the code for reclassification of the station Skarven in QGIS.

##Clean_and_qualitycheck_BCs
The code contains indexing, NA clearing and error searching for errors and outliers in the dataset from SLU's environmental monitoring. 

##Functions_BCs
The code primarily contains four different functions that are used to split cleaned data from SLU Environmental Monitoring into a list of data frames for each station and date. The list is then used to loop through the data frames and plot oxygen and temperature profiles along with the habitat boundaries for the vendace. The loop also calculates total habitat thickness for each station and date and visualises the upper and lower habitat boundaries.  

##Analysis_BCs
The code only contains input during the use of "Functions_BCs"

##QGIS_Reclassify_Görveln_BCs and QGIS_Reclassify_Skarven_BCS
The code reclassifies an array (raster) in QGIS and assigns each depth value in a depth DEM its corresponding habitat thickness based on the analysis from R.  

## Observe! 

The code in this repository is the basis for the examiner to review my thesis. The R-code is specific to this project but a package will be created for general use this summer (2023). 
