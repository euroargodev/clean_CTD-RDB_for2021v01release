## Contents

This repository stores the matlab scripts used to prepare the release of the CTD reference database (CTD-RDB) for Argo DMQC. 
The main objectives were:
- To remove invalid profiles and samples (ex. profiles assigned to the wrong box and samples with missing temperature or salinity)
- Remove duplicated profiles (by checking for exact metadata duplicates, aproximate metadata duplicates and content duplicates)

## Requirements

- Ingrid Angel's utility functions
  https://github.com/imab4bsh/imab
- check CTD-RDB
  https://github.com/euroargodev/check_CTD-RDB
- m_map
	https://www.eoas.ubc.ca/~rich/map.html
- export_fig to save figures
	https://github.com/altmany/export_fig
	https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig

## Funding

This work is part of the following projects: MOCCA received funding from the European Maritime and Fisheries Fund (EMFF) under grant agreement No.
EASME/EMFF/2015/1.2.1.1/SI2.709624. EA-RISE is funded by the European Union’s Horizon 2020 research and innovation programme under grant agreement No. 824131

<img src="https://www.euro-argo.eu/var/storage/images/_aliases/fullsize/medias-ifremer/medias-euro_argo/eu-project-contribution/mocca/logo_mocca_4-3/1537744-1-eng-GB/Logo_MOCCA_4-3.jpg" width="100" /> <img src="https://www.euro-argo.eu/var/storage/images/_aliases/fullsize/medias-ifremer/medias-euro_argo/logos/euro-argo-rise-logo/1688041-1-eng-GB/Euro-argo-RISE-logo.png" width="100" />

and is developed at the Federal Maritime and Hydrographic Agency (Bundesamt für Seeschifffahrt und Hydrographie, BSH) 

<img src="https://www.bsh.de/SiteGlobals/Frontend/Images/logo.png?__blob=normal&v=9" width="50" />

