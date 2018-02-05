sources_altimetry <- function() {
    rbind(
        bb_source(
            name="CMEMS global gridded SSH reprocessed (1993-ongoing)",
            id="SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047",
            description="For the Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. Previously distributed by Aviso+, no change in the scientific content. All the missions are homogenized with respect to a reference mission which is currently OSTM/Jason-2.\nVARIABLES\n- sea_surface_height_above_sea_level (SSH)\n- surface_geostrophic_eastward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- surface_geostrophic_northward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- sea_surface_height_above_geoid (SSH)\n- surface_geostrophic_eastward_sea_water_velocity (UVG)\n- surface_geostrophic_northward_sea_water_velocity (UVG)",
            doc_url="http://cmems-resources.cls.fr/?option=com_csw&view=details&tab=info&product_id=SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047",
            citation="In case of any publication, the Licensee will ensure credit the Copernicus Marine Service in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information\"",
            source_url=c("ftp://ftp.sltac.cls.fr/Core/SEALEVEL_GLO_PHY_L4_REP_OBSERVATIONS_008_047/dataset-duacs-rep-global-merged-allsat-phy-l4-v3/"),
            license="See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
            method=list("bb_handler_wget",level=3), ## --recursive --follow-ftp --no-parent
            postprocess=list("bb_gunzip"),
            authentication_note="Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
            user="",
            password="",
            access_function="readssh",
            collection_size=310,
            data_group="Altimetry",warn_empty_auth=FALSE),
        bb_source(
            name="CMEMS global gridded SSH near-real-time",
            id="SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046",
            description="For the Global Ocean - Multimission altimeter satellite gridded sea surface heights and derived variables computed with respect to a twenty-year mean. Previously distributed by Aviso+, no change in the scientific content. All the missions are homogenized with respect to a reference mission which is currently Jason-3. The acquisition of various altimeter data is a few days at most.\nVARIABLES\n- sea_surface_height_above_sea_level (SSH)\n- surface_geostrophic_eastward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- surface_geostrophic_northward_sea_water_velocity_assuming_sea_level_for_geoid (UVG)\n- sea_surface_height_above_geoid (SSH)\n- surface_geostrophic_eastward_sea_water_velocity (UVG)\n- surface_geostrophic_northward_sea_water_velocity (UVG)",
            doc_url="http://cmems-resources.cls.fr/?option=com_csw&view=details&tab=info&product_id=SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046",
            citation="In case of any publication, the Licensee will ensure credit the Copernicus Marine Service in the following manner: \"This study has been conducted using E.U. Copernicus Marine Service Information\"",
            source_url=c("ftp://ftp.sltac.cls.fr/Core/SEALEVEL_GLO_PHY_L4_NRT_OBSERVATIONS_008_046/dataset-duacs-nrt-global-merged-allsat-phy-l4-v3/"),
            license="See http://marine.copernicus.eu/services-portfolio/service-commitments-and-licence/",
            method=list("bb_handler_wget",level=3), ## --recursive --follow-ftp --no-parent
            postprocess=list("bb_gunzip"),
            authentication_note="Copernicus Marine login required, see http://marine.copernicus.eu/services-portfolio/register-now/",
            user="",
            password="",
            access_function="readssh",
            collection_size=3,
            data_group="Altimetry",warn_empty_auth=FALSE),
        bb_source(
            name="CNES-CLS2013 Mean Dynamic Topography",
            id="CNES-CLS2013 MDT",
            description="CNES-CLS2013 Mean dynamic topography over the 1993-2012 period of the sea surface height above geoid. The MDT_CNES-CLS13 is an estimate of the ocean MDT for the 1993-2012 period. Since April 2014 (Duacs 2014, v15.0 version), the Ssalto/Duacs (M)SLA products are computed relative to 1993-2012 period that is consistent with this new MDT CNES-CLS13. Based on 2 years of GOCE data, 7 years of GRACE data, and 20 years of altimetry and in-situ data (hydrologic and drifters data).",
            doc_url="https://www.aviso.altimetry.fr/en/data/products/auxiliary-products/mdt.html",
            citation="Rio, M-H, P. Schaeffer, G. Moreaux, J-M Lemoine, E. Bronner (2009) : A new Mean Dynamic Topography computed over the global ocean from GRACE data, altimetry and in-situ measurements . Poster communication at OceanObs09 symposium, 21-25 September 2009, Venice.",
            source_url="ftp://ftp.aviso.altimetry.fr/auxiliary/mdt/mdt_cnes_cls2013_global/",
            license="See https://www.aviso.altimetry.fr/en/data/data-access/endatadata-accessregistration-form.html",
            method=list("bb_handler_wget"), ## --recursive --level=1 --no-parent
            postprocess=list("bb_gunzip"),
            authentication_note="AVISO login required, see https://www.aviso.altimetry.fr/en/data/data-access/endatadata-accessregistration-form.html",
            user="",
            password="",
            access_function="raster",
            collection_size=0.1,
            data_group="Altimetry",warn_empty_auth=FALSE)
    )
}
