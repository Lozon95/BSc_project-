from osgeo import gdal 
import numpy as np

#Set input raster file name
raster_file = "TIN_Skarven_PT1.tif"

#Open raster dataset and read data as array to access Numpy functions
ds = gdal.Open(raster_file)
data = ds.GetRasterBand(1).ReadAsArray()
print(data.shape) 

print("Open raster dataset")

#Create a new GeoTIFF driver
driver_gtiff = gdal.GetDriverByName('GTiff')

print("Driver has been opened")

#Set output raster file name
fn_copy = "C:/Users/ander/Documents/Tin_Skarven_PT1_copy2.tif"

#To access unedited data, create a copy of the input raster to overwrite with new data
ds_copy = driver_gtiff.CreateCopy(fn_copy, ds)

print("Copy has been created")

#Create reclassification function
def reclass(array):
    new_array = np.zeros(array.shape, dtype=np.float32)
    new_array[array == -9999] = np.nan
    new_array[array >= -9.4] = 0
    new_array[array <= -11.9] = 2.5
    new_array[(array > -11.9) & (array < -9.4)] = abs(array[(array > -11.9) & (array < -9.4)] + 9.4)
    return new_array

print("Starting reclass")

#Reclassify the input data
new_raster = reclass(data)
print("Reclass finished")
print("Starting to write reclassified data")

#Write the reclassified data to the output raster
ds_copy.GetRasterBand(1).WriteArray(np.array(new_raster))
ds_copy.FlushCache()
print("data written, closing")

# Close the raster datasets
ds = None
ds_copy = None
print("closed")
