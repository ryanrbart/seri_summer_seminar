# Utilities for coupled ecohydrofire model analysis
# Includes files/directories and functions


# ---------------------------------------------------------------------
# Libraries
library(RHESSysIOinR)
library(ggplot2)
library(tidyr)
library(dplyr)
library(lubridate)
library(sensitivity)
library(beepr)


# ---------------------------------------------------------------------
# Files and Directories



# ---------------------------------------------------------------------
# Functions

biomass_removal_by_canopy <- function(world_name_in, world_name_out, canopy_default_ID, reduction_percent){
  
  # Read in worldfile
  worldfile <- read.table(world_name_in, header = FALSE, stringsAsFactors = FALSE)
  
  change_flag <- 0
  reduction_mult <- 1 - (reduction_percent/100)
  for (aa in seq_len(nrow(worldfile))){
    if (aa%%1000 == 0 ){print(paste("Worldfile line", aa, "of", nrow(worldfile)))} # Counter

    if (worldfile[aa,2] == "canopy_strata_ID" && worldfile[aa+1,1] == canopy_default_ID){
      change_flag <- 1
    }
    if (worldfile[aa,2] == "canopy_strata_ID" && worldfile[aa+1,1] != canopy_default_ID){
      change_flag <- 0
    }
    
    if (change_flag == 1){
      if (worldfile[aa,2] == "cs_cpool" || worldfile[aa,2] == "cs.cpool"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_leafc" || worldfile[aa,2] == "cs.leafc"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_dead_leafc" || worldfile[aa,2] == "cs.dead_leafc"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_leafc_store" || worldfile[aa,2] == "cs.leafc_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_leafc_transfer" || worldfile[aa,2] == "cs.leafc_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_live_stemc" || worldfile[aa,2] == "cs.live_stemc"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_livestemc_store" || worldfile[aa,2] == "cs.livestemc_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_livestemc_transfer" || worldfile[aa,2] == "cs.livestemc_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_dead_stemc" || worldfile[aa,2] == "cs.dead_stemc"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_deadstemc_store" || worldfile[aa,2] == "cs.deadstemc_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_deadstemc_transfer" || worldfile[aa,2] == "cs.deadstemc_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_live_crootc" || worldfile[aa,2] == "cs.live_crootc"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_livecrootc_store" || worldfile[aa,2] == "cs.livecrootc_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_livecrootc_transfer" || worldfile[aa,2] == "cs.livecrootc_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_dead_crootc" || worldfile[aa,2] == "cs.dead_crootc"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_deadcrootc_store" || worldfile[aa,2] == "cs.deadcrootc_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_deadcrootc_transfer" || worldfile[aa,2] == "cs.deadcrootc_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_frootc" || worldfile[aa,2] == "cs.frootc"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_frootc_store" || worldfile[aa,2] == "cs.frootc_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "cs_frootc_transfer" || worldfile[aa,2] == "cs.frootc_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_npool" || worldfile[aa,2] == "ns.npool"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_leafn" || worldfile[aa,2] == "ns.leafn"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_dead_leafn" || worldfile[aa,2] == "ns.dead_leafn"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_leafn_store" || worldfile[aa,2] == "ns.leafn_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_leafn_transfer" || worldfile[aa,2] == "ns.leafn_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_live_stemn" || worldfile[aa,2] == "ns.live_stemn"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_livestemn_store" || worldfile[aa,2] == "ns.livestemn_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_livestemn_transfer" || worldfile[aa,2] == "ns.livestemn_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_dead_stemn" || worldfile[aa,2] == "ns.dead_stemn"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_deadstemn_store" || worldfile[aa,2] == "ns.deadstemn_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_deadstemn_transfer" || worldfile[aa,2] == "ns.deadstemn_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_live_crootn" || worldfile[aa,2] == "ns.live_crootn"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_livecrootn_store" || worldfile[aa,2] == "ns.livecrootn_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_livecrootn_transfer" || worldfile[aa,2] == "ns.livecrootn_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_dead_crootn" || worldfile[aa,2] == "ns.dead_crootn"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_deadcrootn_store" || worldfile[aa,2] == "ns.deadcrootn_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_deadcrootn_transfer" || worldfile[aa,2] == "ns.deadcrootn_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_frootn" || worldfile[aa,2] == "ns.frootn"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_frootn_store" || worldfile[aa,2] == "ns.frootn_store"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
      if (worldfile[aa,2] == "ns_frootn_transfer" || worldfile[aa,2] == "ns.frootn_transfer"){worldfile[aa,1] = worldfile[aa,1]*reduction_mult}
    }
  }
  # Write new file
  worldfile$V1 <- format(worldfile$V1, scientific = FALSE)
  write.table(worldfile, file = world_name_out, row.names = FALSE, col.names = FALSE, quote=FALSE, sep="  ")
}





