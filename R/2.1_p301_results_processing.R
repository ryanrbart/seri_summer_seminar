# Code for processing the fire seminar runs
# 
# 

source("R/0.1_utilities.R")

#theme_set(theme_bw(base_size = 11))
#theme_set(theme_bw(base_size = 16))


# ---------------------------------------------------------------------
# P301 coupled model data processing
input_files <- c("ws_p301/out/1.1_p301",
                 "ws_p301/out/1.2_p301",
                 "ws_p301/out/1.3_p301",
                 "ws_p301/out/1.4_p301",
                 "ws_p301/out/1.5_p301",
                 "ws_p301/out/1.6_p301")

bd_list <- list()
bdg_list <- list()
pd_list <- list()
pdg_list <- list()
cd_list <- list()
cdg_list <- list()

for (aa in seq_along(input_files)){
  results <- readin_rhessys_output(input_files[aa], b=1, p=0, c=1, g=1)
  bd_list[[aa]] <- results$bd 
  bdg_list[[aa]] <- results$bdg
  pd_list[[aa]] <- results$pd
  pdg_list[[aa]] <- results$pdg
  cd_list[[aa]] <- separate_canopy_output(results$cd, 2)
  cdg_list[[aa]] <- separate_canopy_output(results$cdg, 2)
}

bd <- bind_rows(bd_list, .id="scenario")
bdg <- bind_rows(bdg_list, .id="scenario")
pd <- bind_rows(pd_list, .id="scenario")
pdg <- bind_rows(pdg_list, .id="scenario")
cd <- bind_rows(cd_list, .id="scenario")
cdg <- bind_rows(cdg_list, .id="scenario")

# ---------------------------------------------------------------------
# Select and output variables

bd <- dplyr::mutate(bd, photosyn = psn*1000)
bd <- dplyr::mutate(bd, litter = litrc*1000)
basin_results <- dplyr::select(bd,
                               date,
                               year,
                               month,
                               day,
                               wy,
                               wyd,
                               scenario,
                               precip,
                               tmax,
                               tmin,
                               streamflow,
                               snowpack,
                               pet,
                               et,
                               photosyn,
                               litter)

cd_select <- dplyr::select(cd,
                           date,
                           year,
                           month,
                           day,
                           wy,
                           wyd,
                           scenario,
                           canopy_layer,
                           height)

cdg <- dplyr::mutate(cdg, above_ground_carbon = leafc + live_stemc + dead_stemc)
cdg <- dplyr::mutate(cdg, below_ground_carbon = frootc + live_crootc + dead_crootc)
cdg_select <- dplyr::select(cdg,
                            above_ground_carbon,
                            below_ground_carbon)

canopy_results <- bind_cols(cd_select,cdg_select)

# Remove first 5 years (due to obvious (lack of) spinup errors with streamflow)
basin_results <- dplyr::filter(basin_results, wy>1946)
canopy_results <- dplyr::filter(canopy_results, wy>1946)

write.table(basin_results, "outputs/basin_results.txt", quote=FALSE, row.names = FALSE)
write.table(canopy_results, "outputs/canopy_results.txt", quote=FALSE, row.names = FALSE)

# ---------------------------------------------------------------------

beep(1)

