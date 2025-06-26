# Wave Attenuation in the Marginal Ice Zone

This repository is used to estimate wave attenuation coefficients in the marginal ice zone.  
The resulting paper is: **Wave Attenuation by Sea Ice in the Marginal Ice Zone: Insights from Four Campaigns near Svalbard**  
(URL: [www.temp.com](http://www.temp.com))

---

## OpenMetBuoy datasets

Four datasets collected by OpenMetBuoy are used, including:  
- 202007  
- 202102  
- AWI UTOKYO  
- CHALMERS  

These datasets are available on other GitHub repositories:  
- [[data_release_sea_ice_drift_waves_in_ice_marginal_ice_zone_2022](https://github.com/jerabaul29/data_release_sea_ice_drift_waves_in_ice_marginal_ice_zone_2022)]  
- [[2024_OpenMetBuoy_data_release_MarginalIceZone_SeaIce_OpenOcean](https://github.com/jerabaul29/2024_OpenMetBuoy_data_release_MarginalIceZone_SeaIce_OpenOcean)]

---

## Workflow

*Here attach a figure illustrating the workflow.*

![Workflow Diagram](workflow.png "Workflow Diagram")


---

### Folder Structure  
- `MATLAB/` – Contains code for wave simulation in the outer domain, using the 202007 dataset as an example.  
- `WaveWatch/` – Contains code for wave simulation in the inner domain, using the 202007 dataset as an example.
- `Results/` – A simple WW3 model setup to calculate wave source terms (including Sin, Sds, Snl), using the 202007 dataset as an example.

