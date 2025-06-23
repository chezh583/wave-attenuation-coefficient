This folder contains code for use with the Wavewatch III model.

1) Purpose:
To extract the directional distribution of the wave spectrum at the locations where buoys recorded wave data.

2) Model setting:
Wave simulations were conducted using the WAVEWATCH III (WW3) model, version 6.07. he model configuration employs a one-way nesting approach, consisting of an outer and an inner computational domain. The outer domain utilizes a half polar stereographic projection grid with a spatial resolution of 10 km, encompassing the majority of the North Atlantic Ocean. The inner domain, with a finer resolution of 2 km, focuses on the seas surrounding the Svalbard archipelago, where the OMBs were deployed. 

3) Folder structre:
outer_domain (FOLDER): include code for wave simulation in the outer domain, using the 202007 dataset as an example
inner_domain (FOLDER): include code for wave simulation in the inner domain, using the 202007 dataset as an example
switch (FILE): files to select model options, which is used in the bin directory of Wavewatch III
