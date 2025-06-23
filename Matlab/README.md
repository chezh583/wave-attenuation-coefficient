This folder contains code for use in MATLAB. All data processing steps for the 202007 dataset are included. Processing other datasets follows the same approach. 

### Purpose  
Estimate the attenuation coefficient in three ways: the full method, the simple method, and the apparent attenuation.

### Folder Structure  
- `step0_create_pointlist.m`: Get buoy locations on the Wavewatch III model.  
- `step1_getfrombuoy.m`: Get longitude, latitude, time, and wave spectrum from OpenMetBuoy NetCDF dataset.  
- `step2_matchtwo.m`: Find simultaneous buoy pairs.  
- `step3_buildlist.m`: Build a matrix containing all wave properties, environmental forcings, time, and locations.  
- `step4_wvprofile.m`: Convert the one-dimensional wave spectrum to two-dimensional by combining buoy data and Wavewatch III simulation.  
- `step5_position.m`: Get a position matrix describing upstream/downstream in buoy pairs.  
- `step6_exp_preparation.m`: Prepare a simple Wavewatch III experiment to calculate wave source terms.  
- `step7_compute_Sice.m`: Compute the attenuation coefficients \( k_{I,Full} \), \( k_{I,Simple} \), and \(\alpha\).  
- `step8_icethickness.m`: Get ice thickness data.  
- `step9_traveldistance.m`: Calculate the distance between the buoy and the ice edge.  
- `step10_properties.m`: Calculate the significant wave height and the mean wave period.  
- `step10_waveage.m`: Calculate the spectral wave age for each attenuation profile.  
- `step11_final_results.m`: Plot attenuation profiles and filter out noisy data.  
- `step12_plot_figure.m`: Plot the final results: attenuation profiles as functions of frequency and spectral wave age.  

