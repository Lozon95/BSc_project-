from osgeo import gdal 
import numpy as np

#Set input raster file name
raster_file = "TIN_Görveln_PT1.tif"

#Open raster dataset and read data as array to access Numpy functions
ds = gdal.Open(raster_file)
data = ds.GetRasterBand(1).ReadAsArray()
print(data.shape) 

print("Open raster dataset")

#Create a new GeoTIFF driver
driver_gtiff = gdal.GetDriverByName('GTiff')

print("Driver has been opened")

#Set output raster file name
fn_copy = "/mnt/c/Users/andbo/Desktop/Tin_Görveln_PT1_copy2.tif"

#To be able to access unedited data, create a copy of the input raster to overwrite with new data
ds_copy = driver_gtiff.CreateCopy(fn_copy, ds)

print("Copy has been created")

#Create reclassification function
def reclass(array):
    new_array = np.zeros(array.shape, dtype=np.float32)
    new_array[array == -9999] = np.nan
    new_array[array >= -11.5] = 0
    new_array[array <= -40] = 28.5
    new_array[(array > -40) & (array < -11.5)] = abs(array[(array > -40) & (array < -11.5)] + 11.5)
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

#Close the raster datasets
ds = None
ds_copy = None
print("closed")

#Add the new layer to QGIS canvas 
iface.addRasterLayer(ds_copy, "Görveln_omklassificerad")
