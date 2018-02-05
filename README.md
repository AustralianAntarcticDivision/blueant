
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/AustralianAntarcticDivision/blueant.svg?branch=master)](https://travis-ci.org/AustralianAntarcticDivision/blueant) [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/5idrimyx0uuv6liu?svg=true)](https://ci.appveyor.com/project/raymondben/blueant) [![codecov](https://codecov.io/gh/AustralianAntarcticDivision/blueant/branch/master/graph/badge.svg)](https://codecov.io/gh/AustralianAntarcticDivision/blueant)

Blueant
=======

Blueant provides a set of data source configurations to use with the [bowerbird](https://github.com/AustralianAntarcticDivision/bowerbird) package. These data sources are themed around Antarctic and Southern Ocean data, and include a range of oceanographic, meteorological, topographic, and other environmental data sets. Blueant will allow you to download data from these external data providers to your local file system, and to keep that data collection up to date.

Installing
----------

``` r
install.packages("devtools")
library(devtools)
install_github("AustralianAntarcticDivision/blueant",build_vignettes=TRUE)
```

Bowerbird (and by extension, blueant) use the third-party utility `wget` to do the heavy lifting of recursively downloading files from data providers. `wget` is typically installed by default on Linux. On Windows you can use the `bb_install_wget()` function to install it. Otherwise download `wget` yourself (e.g. from <https://eternallybored.org/misc/wget/current/wget.exe>) and make sure it is on your path.

Usage
-----

### Configuration

Build up a configuration by first defining global options such as the destination on your local file system:

``` r
cf <- bb_config(local_file_root="~/your/data/directory")
```

Add data sources from those provided by blueant. A summary of these sources is given at the end of this document.

``` r
cf <- cf %>% bb_add(blueant_sources("CERSAT SSM/I sea ice concentration"))
```

### Synchronisation

Once the configuration has been defined, run the sync process:

``` r
bb_sync(cf)
```

Congratulations! You now have your own local copy of your chosen data sets.

The pre-packaged environmental data sources can be read, manipulated, and plotted using a range of other R packages, including [RAADTools](https://github.com/AustralianAntarcticDivision/raadtools) and [raster](https://cran.r-project.org/package=raster).

Nuances
-------

### Choosing a data directory

It's up to you where you want your data collection kept, and to provide that location to bowerbird. A common use case for bowerbird is maintaining a central data collection for multiple users, in which case that location is likely to be some sort of networked file share. However, if you are keeping a collection for your own use, you might like to look at <https://github.com/r-lib/rappdirs> to help find a suitable directory location.

### Modifying data sources

#### Authentication

Some data providers require users to log in. These are indicated by the `authentication_note` column in the configuration table. For these sources, you will need to provide your user name and password, e.g.:

``` r
src <- blueant_sources(name="CMEMS global gridded SSH reprocessed (1993-ongoing)")
src$user <- "yourusername"
src$password <- "yourpassword"
cf <- bb_add(cf,src)

## or, using dplyr
cf <- cf %>% bb_add(blueant_sources(name="CMEMS global gridded SSH reprocessed (1993-ongoing)") %>%
                 mutate(user="yourusername",password="yourpassword"))
```

#### Reducing download sizes

Sometimes you might only want part of a pre-configured data source. If the data source uses the `bb_handler_wget` method, you can restrict what is downloaded by modifying the data source's `method_flags`, particularly the `--accept`, `--reject`, `--accept-regex`, and `--reject-regex` options. Be sure to leave the original method flags in place, unless you know what you are doing.

For example, the CERSAT SSM/I sea ice concentration data are arranged in yearly directories, so it is fairly easy to restrict ourselves to, say, only the 2017 data:

``` r
cf <- cf %>% bb_add(blueant_sources("CERSAT SSM/I sea ice concentration") %>%
                 mutate(method_flags=paste(method_flags,"--accept-regex=\"/2017/\"")))
```

See the bowerbird documentation for further guidances on the accept/reject flags.

Alternatively, for data sources that are divided into subdirectories, one could replace the whole-data-source `source_url` with one or more that point to specific yearly (or other) subdirectories. For example, the default `source_url` for the CERSAT sea ice data above is "<ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/*>" (with yearly subdirectories). So e.g. for 2016 and 2017 data we could do:

``` r
cf <- cf %>% bb_add(blueant_sources("CERSAT SSM/I sea ice concentration") %>%
    mutate(source_url=c("ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/2016/*",
                        "ftp://ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/2017/*")))
```

### Defining new data sources

If the pre-packages data sources don't cover your needs, you can define your own using the `bb_source` function. See the bowerbird documentation.

Data source summary
-------------------

These are the data source definitions that are provided as part of the blueant package.

### Data group: Altimetry

#### CMEMS global gridded SSH reprocessed (1993-ongoing)

For the Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. Previously distributed by Aviso+, no change in the scientific content. All the missions are homogenized with respect to a reference mission which is currently OSTM/Jason-2. VARIABLES

-   sea\_surface\_height\_above\_sea\_level (SSH)

-   surface\_geostrophic\_eastward\_sea\_water\_velocity\_assuming\_sea\_level\_for\_geoid (UVG)

-   surface\_geostrophic\_northward\_sea\_water\_velocity\_assuming\_sea\_level\_for\_geoid (UVG)

-   sea\_surface\_height\_above\_geoid (SSH)

-   surface\_geostrophic\_eastward\_sea\_water\_velocity (UVG)

-   surface\_geostrophic\_northward\_sea\_water\_velocity (UVG)

Authentication note: Copernicus Marine login required, see <http://marine.copernicus.eu/services-portfolio/register-now/>

Approximate size: 310 GB

Reference: <http://cmems-resources.cls.fr/?option=com_csw&view=details&tab=info&product_id=SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047>

#### CMEMS global gridded SSH near-real-time

For the Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. Previously distributed by Aviso+, no change in the scientific content. All the missions are homogenized with respect to a reference mission which is currently Jason-3. The acquisition of various altimeter data is a few days at most. VARIABLES

-   sea\_surface\_height\_above\_sea\_level (SSH)

-   surface\_geostrophic\_eastward\_sea\_water\_velocity\_assuming\_sea\_level\_for\_geoid (UVG)

-   surface\_geostrophic\_northward\_sea\_water\_velocity\_assuming\_sea\_level\_for\_geoid (UVG)

-   sea\_surface\_height\_above\_geoid (SSH)

-   surface\_geostrophic\_eastward\_sea\_water\_velocity (UVG)

-   surface\_geostrophic\_northward\_sea\_water\_velocity (UVG)

Authentication note: Copernicus Marine login required, see <http://marine.copernicus.eu/services-portfolio/register-now/>

Approximate size: 3 GB

Reference: <http://cmems-resources.cls.fr/?option=com_csw&view=details&tab=info&product_id=SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046>

#### CNES-CLS09 Mean Dynamic Topography

CNES-CLS09 Mean Dynamic Topography (v1.1 release)

Authentication note: AVISO login required, see <https://www.aviso.altimetry.fr/en/data/data-access/endatadata-accessregistration-form.html>

Approximate size: 0.1 GB

Reference: <http://www.aviso.altimetry.fr/en/data/products/auxiliary-products/mdt.html>

### Data group: Meteorological

#### Antarctic Mesoscale Prediction System grib files

The Antarctic Mesoscale Prediction System - AMPS - is an experimental, real-time numerical weather prediction capability that provides support for the United States Antarctic Program, Antarctic science, and international Antarctic efforts.

Approximate size: not specified

Reference: <http://www2.mmm.ucar.edu/rt/amps/>

### Data group: Ocean colour

#### Oceandata SeaWiFS Level-3 mapped monthly 9km chl-a

Monthly remote-sensing chlorophyll-a from the SeaWiFS satellite at 9km spatial resolution

Approximate size: 7.2 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata MODIS Aqua Level-3 mapped daily 4km chl-a

Daily remote-sensing chlorophyll-a from the MODIS Aqua satellite at 4km spatial resolution

Approximate size: 40 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata MODIS Aqua Level-3 mapped monthly 9km chl-a

Monthly remote-sensing chlorophyll-a from the MODIS Aqua satellite at 9km spatial resolution

Approximate size: 8 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata VIIRS Level-3 mapped daily 4km chl-a

Daily remote-sensing chlorophyll-a from the VIIRS satellite at 4km spatial resolution

Approximate size: 1 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata VIIRS Level-3 mapped monthly 9km chl-a

Monthly remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution

Approximate size: 1 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata VIIRS Level-3 mapped seasonal 9km chl-a

Seasonal remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution

Approximate size: 0.5 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata VIIRS Level-3 binned daily RRS

Daily remote-sensing reflectance from VIIRS. RRS is used to produce standard ocean colour products such as chlorophyll concentration

Approximate size: 180 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata MODIS Aqua Level-3 binned daily RRS

Daily remote-sensing reflectance from MODIS Aqua. RRS is used to produce standard ocean colour products such as chlorophyll concentration

Approximate size: 800 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata SeaWiFS Level-3 binned daily RRS

Daily remote-sensing reflectance from SeaWiFS. RRS is used to produce standard ocean colour products such as chlorophyll concentration

Approximate size: 130 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata VIIRS Level-3 mapped 32-day 9km chl-a

Rolling 32-day composite remote-sensing chlorophyll-a from the VIIRS satellite at 9km spatial resolution

Approximate size: 4 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

### Data group: Oceanographic

#### CSIRO Atlas of Regional Seas 2009

CARS is a digital climatology, or atlas of seasonal ocean water properties.

Approximate size: 2.8 GB

Reference: <http://www.marine.csiro.au/~dunn/cars2009/>

#### World Ocean Atlas 2009

World Ocean Atlas 2009 (WOA09) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on both 1 degree and 5 degree grids

Approximate size: 6 GB

Reference: <http://www.nodc.noaa.gov/OC5/WOA09/pr_woa09.html>

#### World Ocean Atlas 2013 V2

World Ocean Atlas 2013 version 2 (WOA13 V2) is a set of objectively analyzed (1 degree grid) climatological fields of in situ temperature, salinity, dissolved oxygen, Apparent Oxygen Utilization (AOU), percent oxygen saturation, phosphate, silicate, and nitrate at standard depth levels for annual, seasonal, and monthly compositing periods for the World Ocean. It also includes associated statistical fields of observed oceanographic profile data interpolated to standard depth levels on 5 degree, 1 degree, and 0.25 degree grids

Approximate size: 57 GB

Reference: <https://www.nodc.noaa.gov/OC5/woa13/>

### Data group: Reanalysis

#### NCEP-DOE Reanalysis 2 6-hourly data

NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. The 6-hourly data is the original output time resolution.

Approximate size: not specified

Reference: <http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html>

#### NCEP-DOE Reanalysis 2 daily averages

NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Daily averages are calculated from the 6-hourly model output.

Approximate size: 50 GB

Reference: <http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html>

#### NCEP-DOE Reanalysis 2 monthly averages

NCEP-DOE Reanalysis 2 is an improved version of the NCEP Reanalysis I model that fixed errors and updated paramterizations of of physical processes. Monthly averages are calculated from the 6-hourly model output.

Approximate size: 2 GB

Reference: <http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html>

### Data group: Satellite imagery

#### NASA MODIS Rapid Response Antarctic Mosaic

Daily Antarctic MODIS mosaic images at 4km resolution

Approximate size: 14 GB

Reference: <https://earthdata.nasa.gov/data/near-real-time-data/rapid-response>

### Data group: Sea ice

#### NSIDC SMMR-SSM/I Nasateam sea ice concentration

Passive microwave estimates of sea ice concentration at 25km spatial resolution. Daily and monthly resolution, available from 1-Oct-1978 to present.

Approximate size: 10 GB

Reference: <http://nsidc.org/data/nsidc-0051.html>

#### NSIDC SMMR-SSM/I Nasateam near-real-time sea ice concentration

Passive microwave estimates of sea ice concentration at 25km, daily, near-real-time resolution.

Approximate size: 0.6 GB

Reference: <http://nsidc.org/data/nsidc-0081.html>

#### NSIDC passive microwave supporting files

Grids and other support files for NSIDC passive microwave sea ice data.

Approximate size: 0.1 GB

Reference: <http://nsidc.org/data/nsidc-0051.html>

#### Nimbus Ice Edge Points from Nimbus Visible Imagery

This data set (NmIcEdg2) estimates the location of the North and South Pole sea ice edges at various times during the mid to late 1960s, based on recovered Nimbus 1 (1964), Nimbus 2 (1966), and Nimbus 3 (1969) visible imagery.

Authentication note: Requires Earthdata login, see <https://urs.earthdata.nasa.gov/>

Approximate size: 0.1 GB

Reference: <http://nsidc.org/data/nmicedg2/>

#### Artist AMSR-E sea ice concentration

Passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 19-Jun-2002 to 2-Oct-2011.

Approximate size: 25 GB

Reference: <http://icdc.zmaw.de/1/daten/cryosphere/seaiceconcentration-asi-amsre.html>

#### Artist AMSR-E supporting files

Grids and other support files for Artist AMSR-E passive microwave sea ice data.

Approximate size: 0.01 GB

Reference: <http://icdc.zmaw.de/1/daten/cryosphere/seaiceconcentration-asi-amsre.html>

#### Artist AMSR2 near-real-time sea ice concentration

Near-real-time passive microwave estimates of daily sea ice concentration at 6.25km spatial resolution, from 24-July-2012 to present.

Approximate size: 11 GB

Reference: <http://www.iup.uni-bremen.de:8084/amsr2/>

#### Artist AMSR2 regional sea ice concentration

Passive microwave estimates of daily sea ice concentration at 3.125km spatial resolution in selected regions, from 24-July-2012 to present.

Approximate size: not specified

Reference: <http://www.iup.uni-bremen.de:8084/amsr2/regions-amsr2.php>

#### Artist AMSR2 supporting files

Grids for Artist AMSR2 passive microwave sea ice data.

Approximate size: 0.02 GB

Reference: <http://www.iup.uni-bremen.de:8084/amsr2/>

#### CERSAT SSM/I sea ice concentration

Passive microwave sea ice concentration data at 12.5km resolution, 3-Dec-1991 to present

Approximate size: 2.5 GB

Reference: <http://cersat.ifremer.fr/data/tools-and-services/quicklooks/sea-ice/ssm-i-sea-ice-concentration-maps>

#### MODIS Composite Based Maps of East Antarctic Fast Ice Coverage

Maps of East Antarctic landfast sea-ice extent, generated from approx. 250,000 1 km visible/thermal infrared cloud-free MODIS composite imagery (augmented with AMSR-E 6.25-km sea-ice concentration composite imagery when required). Coverage from 2000-03-01 to 2008-12-31

Approximate size: 0.4 GB

Reference: <https://data.aad.gov.au/metadata/records/modis_20day_fast_ice>

#### National Ice Center Antarctic daily sea ice charts

The USNIC Daily Ice Edge product depicts the daily sea ice pack in red (8-10/10ths or greater of sea ice), and the Marginal Ice Zone (MIZ) in yellow. The marginal ice zone is the transition between the open ocean (ice free) and pack ice. The MIZ is very dynamic and affects the air-ocean heat transport, as well as being a significant factor in navigational safety. The daily ice edge is analyzed by sea ice experts using multiple sources of near real time satellite data, derived satellite products, buoy data, weather, and analyst interpretation of current sea ice conditions. The product is a current depiction of the location of the ice edge vice a satellite derived ice edge product.

Approximate size: not specified

Reference: <http://www.natice.noaa.gov/Main_Products.htm>

### Data group: Sea surface temperature

#### NOAA OI 1/4 Degree Daily SST AVHRR

Sea surface temperature at 0.25 degree daily resolution, from 1-Sep-1981 to present

Approximate size: 140 GB

Reference: <http://www.ngdc.noaa.gov/docucomp/page?xml=NOAA/NESDIS/NCDC/Geoportal/iso/xml/C00844.xml&view=getDataView&header=none>

#### NOAA OI SST V2

Weekly and monthly mean and long-term monthly mean SST data, 1-degree resolution, 1981 to present. Ice concentration data are also included, which are the ice concentration values input to the SST analysis

Approximate size: 0.9 GB

Reference: <http://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.html>

#### NOAA Extended Reconstructed SST V3b

A global monthly SST analysis from 1854 to the present derived from ICOADS data with missing data filled in by statistical methods

Approximate size: 0.3 GB

Reference: <http://www.esrl.noaa.gov/psd/data/gridded/data.noaa.ersst.html>

#### Oceandata MODIS Terra Level-3 mapped monthly 9km SST

Monthly remote-sensing sea surface temperature from the MODIS Terra satellite at 9km spatial resolution

Approximate size: 7 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### Oceandata MODIS Aqua Level-3 mapped monthly 9km SST

Monthly remote-sensing SST from the MODIS Aqua satellite at 9km spatial resolution

Approximate size: 7 GB

Reference: <http://oceancolor.gsfc.nasa.gov/>

#### GHRSST Level 4 MUR Global Foundation SST v4.1

A Group for High Resolution Sea Surface Temperature (GHRSST) Level 4 sea surface temperature analysis produced as a retrospective dataset (four day latency) at the JPL Physical Oceanography DAAC using wavelets as basis functions in an optimal interpolation approach on a global 0.011 degree grid. The version 4 Multiscale Ultrahigh Resolution (MUR) L4 analysis is based upon nighttime GHRSST L2P skin and subskin SST observations from several instruments including the NASA Advanced Microwave Scanning Radiometer-EOS (AMSRE), the Moderate Resolution Imaging Spectroradiometer (MODIS) on the NASA Aqua and Terra platforms, the US Navy microwave WindSat radiometer and in situ SST observations from the NOAA iQuam project. The ice concentration data are from the archives at the EUMETSAT Ocean and Sea Ice Satellite Application Facility (OSI SAF) High Latitude Processing Center and are also used for an improved SST parameterization for the high-latitudes. This data set is funded by the NASA MEaSUREs program (<http://earthdata.nasa.gov/our-community/community-data-system-programs/measures-projects>), and created by a team led by Dr. Toshio Chin from JPL.

Approximate size: 2000 GB

Reference: <https://podaac.jpl.nasa.gov/Multi-scale_Ultra-high_Resolution_MUR-SST>

### Data group: Topography

#### Smith and Sandwell bathymetry

Global seafloor topography from satellite altimetry and ship depth soundings

Approximate size: 1.4 GB

Reference: <http://topex.ucsd.edu/WWW_html/mar_topo.html>

#### ETOPO1 bathymetry

ETOPO1 is a 1 arc-minute global relief model of Earth's surface that integrates land topography and ocean bathymetry.

Approximate size: 1.3 GB

Reference: <http://www.ngdc.noaa.gov/mgg/global/global.html>

#### ETOPO2 bathymetry

2-Minute Gridded Global Relief Data (ETOPO2v2c)

Approximate size: 0.3 GB

Reference: <http://www.ngdc.noaa.gov/mgg/global/etopo2.html>

#### Bedmap2

Bedmap2 is a suite of gridded products describing surface elevation, ice-thickness and the sea floor and subglacial bed elevation of the Antarctic south of 60S.

Approximate size: 3.3 GB

Reference: <http://www.antarctica.ac.uk/bas_research/our_research/az/bedmap2/>

#### Kerguelen Plateau bathymetric grid 2010

This data replaces the digital elevation model (DEM) for the Kerguelen Plateau region produced in 2005 (Sexton 2005). The revised grid has been gridded at a grid pixel resolution of 0.001-arc degree (about 100 m). The new grid utilised the latest data sourced from ship-based multibeam and singlebeam echosounder surveys, and satellite remotely-sensed data. Report Reference: Beaman, R.J. and O'Brien, P.E., 2011. Kerguelen Plateau bathymetric grid, November 2010. Geoscience Australia, Record, 2011/22, 18 pages.

Approximate size: 0.7 GB

Reference: <http://www.ga.gov.au/metadata-gateway/metadata/record/gcat_71552>

#### George V bathymetry

This dataset comprises Digital Elevation Models (DEMs) of varying resolutions for the George V and Terre Adelie continental margin, derived by incorporating all available singlebeam and multibeam point depth data.

Approximate size: 0.2 GB

Reference: <https://data.aad.gov.au/metadata/records/GVdem_2008>

#### Geoscience Australia multibeam bathymetric grids of the Macquarie Ridge

This is a compilation of all the processed multibeam bathymetry data that are publicly available in Geoscience Australia's data holding for the Macquarie Ridge.

Approximate size: 0.4 GB

Reference: <http://www.ga.gov.au/metadata-gateway/metadata/record/gcat_b9224f95-a416-07f8-e044-00144fdd4fa6/XYZ+multibeam+bathymetric+grids+of+the+Macquarie+Ridge>

#### IBCSO bathymetry

The International Bathymetric Chart of the Southern Ocean (IBCSO) Version 1.0 is a new digital bathymetric model (DBM) portraying the seafloor of the circum-Antarctic waters south of 60S. IBCSO is a regional mapping project of the General Bathymetric Chart of the Oceans (GEBCO). The IBCSO Version 1.0 DBM has been compiled from all available bathymetric data collectively gathered by more than 30 institutions from 15 countries. These data include multibeam and single-beam echo soundings, digitized depths from nautical charts, regional bathymetric gridded compilations, and predicted bathymetry. Specific gridding techniques were applied to compile the DBM from the bathymetric data of different origin, spatial distribution, resolution, and quality. The IBCSO Version 1.0 DBM has a resolution of 500 x 500 m, based on a polar stereographic projection, and is publicly available together with a digital chart for printing from the project website (www.ibcso.org) and at <http://dx.doi.org/10.1594/PANGAEA.805736>.

Approximate size: 4.1 GB

Reference: <http://www.ibcso.org/>

#### IBCSO chart for printing

The IBCSO Poster, 2013, is a polar stereographic view of the Southern Ocean displaying bathymetric contours south of 60S at a scale of 1:7,000,000. The poster size is 39.25 x 47.125 inches.

Approximate size: 0.2 GB

Reference: <http://www.ibcso.org/>

#### RTOPO-1 Antarctic ice shelf topography

Sub-ice shelf circulation and freezing/melting rates in ocean general circulation models depend critically on an accurate and consistent representation of cavity geometry. The goal of this work is to compile independent regional fields into a global data set. We use the S-2004 global 1-minute bathymetry as the backbone and add an improved version of the BEDMAP topography for an area that roughly coincides with the Antarctic continental shelf. Locations of the merging line have been carefully adjusted in order to get the best out of each data set. High-resolution gridded data for upper and lower ice surface topography and cavity geometry of the Amery, Fimbul, Filchner-Ronne, Larsen C and George VI Ice Shelves, and for Pine Island Glacier have been carefully merged into the ambient ice and ocean topographies. Multibeam survey data for bathymetry in the former Larsen B cavity and the southeastern Bellingshausen Sea have been obtained from the data centers of Alfred Wegener Institute (AWI), British Antarctic Survey (BAS) and Lamont-Doherty Earth Observatory (LDEO), gridded, and again carefully merged into the existing bathymetry map.

Approximate size: 4.1 GB

Reference: <http://epic.awi.de/30738/>

#### Radarsat Antarctic digital elevation model V2

The high-resolution Radarsat Antarctic Mapping Project (RAMP) digital elevation model (DEM) combines topographic data from a variety of sources to provide consistent coverage of all of Antarctica. Version 2 improves upon the original version by incorporating new topographic data, error corrections, extended coverage, and other modifications.

Approximate size: 3.3 GB

Reference: <http://nsidc.org/data/nsidc-0082>

#### New Zealand Regional Bathymetry 2016

The NZ 250m gridded bathymetric data set and imagery, Mitchell et al. 2012, released 2016.

Approximate size: 1.3 GB

Reference: <https://www.niwa.co.nz/our-science/oceans/bathymetry/further-information>

#### Cryosat-2 digital elevation model

A New Digital Elevation Model of Antarctica derived from 6 years of continuous CryoSat-2 measurements

Approximate size: 0.6 GB

Reference: <http://homepages.see.leeds.ac.uk/~py10ts/cpom_cryosat2_antarctic_dem/>

#### Natural Earth 10m physical vector data

Natural Earth is a public domain map dataset available at 1:10m, 1:50m, and 1:110 million scales.

Approximate size: 0.2 GB

Reference: <http://www.naturalearthdata.com/downloads/10m-physical-vectors/>

#### GSHHG coastline data

A Global Self-consistent, Hierarchical, High-resolution Geography Database

Approximate size: 0.6 GB

Reference: <http://www.soest.hawaii.edu/pwessel/gshhg>

#### Shuttle Radar Topography Mission elevation data SRTMGL1 V3

Global 1-arc-second topographic data generated from NASA's Shuttle Radar Topography Mission. Version 3.0 (aka SRTM Plus or Void Filled) removes all of the void areas by incorporating data from other sources such as the ASTER GDEM.

Authentication note: Requires Earthdata login, see <https://urs.earthdata.nasa.gov/>

Approximate size: 620 GB

Reference: <https://lpdaac.usgs.gov/dataset_discovery/measures/measures_products_table/srtmgl1_v003>
