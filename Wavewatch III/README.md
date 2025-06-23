This folder contains code for use with the WAVEWATCH III (WW3) model.

### Purpose  
To extract the directional distribution of the wave spectrum at the locations where buoys recorded wave data.

### Model Setting  
Wave simulations were conducted using the WAVEWATCH III (WW3) model, version 6.07.  
The model configuration employs a one-way nesting approach, consisting of an outer and an inner computational domain:

- The **outer domain** uses a half polar stereographic projection grid with a spatial resolution of 10 km, covering the majority of the North Atlantic Ocean.  
- The **inner domain**, with a finer resolution of 2 km, focuses on the seas surrounding Svalbard, where the OMBs were deployed.

### Folder Structure  
- `outer_domain/` – Contains code for wave simulation in the outer domain, using the 202007 dataset as an example.  
- `inner_domain/` – Contains code for wave simulation in the inner domain, using the 202007 dataset as an example.
- `source_term/` – A simple WW3 model setup to calculate wave source terms (including Sin, Sds, Snl), using the 202007 dataset as an example.
- `switch` – A file specifying model options, used in the `bin/` directory of WAVEWATCH III.
