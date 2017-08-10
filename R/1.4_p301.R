# Watershed Simulation for P301
# 
# This script is used to simulate vegetation at the watershed level, beginning
# with no vegetation.

source("R/0.1_utilities.R")

# ---------------------------------------------------------------------
# Model inputs

# Processing options
parameter_method <- "all_combinations"


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "1941 10 1 1"
input_rhessys$end_date <- "1955 8 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_1"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


# HDR (header) file
input_hdr_list <- list()
input_hdr_list$basin_def <- c("ws_p301/defs/basin_p301.def")
input_hdr_list$hillslope_def <- c("ws_p301/defs/hill_p301.def")
input_hdr_list$zone_def <- c("ws_p301/defs/zone_p301.def")
input_hdr_list$soil_def <- c("ws_p301/defs/patch_p301.def")
input_hdr_list$landuse_def <- c("ws_p301/defs/lu_p301.def")
input_hdr_list$stratum_def <- c("ws_p301/defs/veg_p301_conifer.def", "ws_p301/defs/veg_p301_shrub.def")
input_hdr_list$base_stations <- c("ws_p301/clim/Grove_lowprov_clim_1942_2453.base")


# Define path to a pre-selected df containing parameter sets
input_preexisting_table <- NULL


# Def file parameter changes
# List of lists containing def_file, parameter and parameters values
#input_def_list <- NULL
input_def_list <- list(
  # Lower canopy parameters
  list(input_hdr_list$stratum_def[2], "epc.leaf_turnover", c(0.4)),
  list(input_hdr_list$stratum_def[2], "epc.livewood_turnover", c(0.1)),
  list(input_hdr_list$stratum_def[2], "epc.alloc_frootc_leafc", c(1.4)),
  list(input_hdr_list$stratum_def[2], "epc.alloc_crootc_stemc", c(0.4)),
  list(input_hdr_list$stratum_def[2], "epc.alloc_stemc_leafc", c(0.2)),
  list(input_hdr_list$stratum_def[2], "epc.alloc_livewoodc_woodc", c(0.9)),
  list(input_hdr_list$stratum_def[2], "epc.branch_turnover", c(0.02)),
  list(input_hdr_list$stratum_def[2], "epc.height_to_stem_exp", c(0.57)),
  list(input_hdr_list$stratum_def[2], "epc.height_to_stem_coef", c(4.0)),
  # Lower canopy fire parameters
  list(input_hdr_list$stratum_def[2], "overstory_height_thresh", c(7)),
  list(input_hdr_list$stratum_def[2], "understory_height_thresh", c(4)),
  list(input_hdr_list$stratum_def[2], "pspread_loss_rel", c(1)),
  list(input_hdr_list$stratum_def[2], "vapor_loss_rel", c(1)),
  list(input_hdr_list$stratum_def[2], "biomass_loss_rel_k1", c(-10)),
  list(input_hdr_list$stratum_def[2], "biomass_loss_rel_k2", c(1)),
  # -----
  # Upper canopy parameters
  list(input_hdr_list$stratum_def[1], "epc.height_to_stem_exp", c(0.57)),
  list(input_hdr_list$stratum_def[1], "epc.height_to_stem_coef", c(11.39)),
  # Upper canopy fire parameters
  list(input_hdr_list$stratum_def[1], "overstory_height_thresh", c(7)),
  list(input_hdr_list$stratum_def[1], "understory_height_thresh", c(4)),
  list(input_hdr_list$stratum_def[1], "pspread_loss_rel", c(1)),
  list(input_hdr_list$stratum_def[1], "vapor_loss_rel", c(1)),
  list(input_hdr_list$stratum_def[1], "biomass_loss_rel_k1", c(-10)),
  list(input_hdr_list$stratum_def[1], "biomass_loss_rel_k2", c(1))
  # -----
  # Fire spread parameters
  
)


# Make a list of dated sequence data.frames (year, month, day, hour, value)
input_dated_seq_file <- NULL
input_dated_seq_list <- NULL

# Standard sub-surface parameters
# input_standard_par_list <- NULL
input_standard_par_list <- list(
  m = c(1.792761),
  k = c(1.566492),
  m_v = c(1.792761),
  k_v = c(1.566492),
  pa = c(7.896941),
  po = c(1.179359),
  gw1 = c(0.1668035),
  gw2 = c(0.178753)
)


# Make tec-file
#input_tec_data <- NULL
input_tec_data <- data.frame(year=integer(),month=integer(),day=integer(),hour=integer(),name=character(),stringsAsFactors=FALSE)
input_tec_data[1,] <- data.frame(1941, 10, 1, 1, "print_daily_on", stringsAsFactors=FALSE)
input_tec_data[2,] <- data.frame(1941, 10, 1, 2, "print_daily_growth_on", stringsAsFactors=FALSE)
input_tec_data[3,] <- data.frame(1955, 7, 31, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[4,] <- data.frame(1965, 7, 31, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[5,] <- data.frame(1975, 7, 31, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[6,] <- data.frame(1985, 7, 31, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[7,] <- data.frame(1995, 7, 31, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[8,] <- data.frame(2005, 7, 31, 1, "output_current_state", stringsAsFactors=FALSE)
input_tec_data[9,] <- data.frame(2015, 7, 31, 1, "output_current_state", stringsAsFactors=FALSE)

# List of lists containing variable of interest, location/name of awk file (relative to output
# file location), and the location/name of rhessys output file with variable of interest.
output_variables <- NULL
# output_variables <- list()

# ---------------------------------------------------------------------

system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

# ---------------------------------------------------------------------
# Apply a fuels treatment (1955)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy.world.Y1955M7D31H1.state"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment1a.world"
canopy_default_ID <- 7
reduction_percent <- 10

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment1a.world"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment1b.world"
canopy_default_ID <- 50
reduction_percent <- 100

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

# ---------------------------------------------------------------------
# Run RHESSys after fuels treatment


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment1b.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "1955 8 1 1"
input_rhessys$end_date <- "1965 8 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_2"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

# ---------------------------------------------------------------------
# Apply a fuels treatment (1965)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment1b.world.Y1965M7D31H1.state"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment2a.world"
canopy_default_ID <- 7
reduction_percent <- 10

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment2a.world"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment2b.world"
canopy_default_ID <- 50
reduction_percent <- 100

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

# ---------------------------------------------------------------------
# Run RHESSys after fuels treatment


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment2b.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "1965 8 1 1"
input_rhessys$end_date <- "1975 8 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_3"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)


# ---------------------------------------------------------------------
# Apply a fuels treatment (1975)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment2b.world.Y1975M7D31H1.state"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment3a.world"
canopy_default_ID <- 7
reduction_percent <- 10

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment3a.world"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment3b.world"
canopy_default_ID <- 50
reduction_percent <- 100

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

# ---------------------------------------------------------------------
# Run RHESSys after fuels treatment


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment3b.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "1975 8 1 1"
input_rhessys$end_date <- "1985 8 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_4"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

# ---------------------------------------------------------------------
# Apply a fuels treatment (1985)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment3b.world.Y1985M7D31H1.state"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment4a.world"
canopy_default_ID <- 7
reduction_percent <- 10

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment4a.world"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment4b.world"
canopy_default_ID <- 50
reduction_percent <- 100

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

# ---------------------------------------------------------------------
# Run RHESSys after fuels treatment


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment4b.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "1985 8 1 1"
input_rhessys$end_date <- "1995 8 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_5"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

# ---------------------------------------------------------------------
# Apply a fuels treatment (1995)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment4b.world.Y1995M7D31H1.state"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment5a.world"
canopy_default_ID <- 7
reduction_percent <- 10

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment5a.world"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment5b.world"
canopy_default_ID <- 50
reduction_percent <- 100

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

# ---------------------------------------------------------------------
# Run RHESSys after fuels treatment


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment5b.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "1995 8 1 1"
input_rhessys$end_date <- "2005 8 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_6"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

# ---------------------------------------------------------------------
# Apply a fuels treatment (2005)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment5b.world.Y2005M7D31H1.state"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment6a.world"
canopy_default_ID <- 7
reduction_percent <- 10

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment6a.world"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment6b.world"
canopy_default_ID <- 50
reduction_percent <- 100

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

# ---------------------------------------------------------------------
# Run RHESSys after fuels treatment


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment6b.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "2005 8 1 1"
input_rhessys$end_date <- "2015 8 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_7"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

# ---------------------------------------------------------------------
# Apply a fuels treatment (2015)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment6b.world.Y2015M7D31H1.state"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment7a.world"
canopy_default_ID <- 7
reduction_percent <- 10

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

world_name_in <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment7a.world"
world_name_out <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment7b.world"
canopy_default_ID <- 50
reduction_percent <- 100

biomass_removal_by_canopy(world_name_in=world_name_in,
                          world_name_out=world_name_out,
                          canopy_default_ID=canopy_default_ID,
                          reduction_percent=reduction_percent)

# ---------------------------------------------------------------------
# Run RHESSys after fuels treatment


# RHESSys Inputs
input_rhessys <- list()
input_rhessys$rhessys_version <- "bin/rhessys5.20.1"
input_rhessys$tec_file <- "ws_p301/tecfiles/p301_fire.tec"
input_rhessys$world_file <- "ws_p301/worldfiles/p301_30m_2canopy_scenario4_treatment7b.world"
input_rhessys$world_hdr_prefix <- "p301_30m"
input_rhessys$flow_file <- "ws_p301/flowtables/p301_30m.flow"
input_rhessys$start_date <- "2015 8 1 1"
input_rhessys$end_date <- "2021 10 1 1"
input_rhessys$output_folder <- "ws_p301/out"
input_rhessys$output_filename <- "1.4_p301_8"
input_rhessys$command_options <- c("-b -g -c 1 189 8081 8081")


system.time(
  run_rhessys(parameter_method = parameter_method,
              input_rhessys = input_rhessys,
              input_hdr_list = input_hdr_list,
              input_preexisting_table = input_preexisting_table,
              input_def_list = input_def_list,
              input_standard_par_list = input_standard_par_list,
              input_dated_seq_file = input_dated_seq_file,
              input_tec_data = input_tec_data,
              output_variables = output_variables)
)

# ---------------------------------------------------------------------
# Reassemble RHESSys output

pre <- c("ws_p301/out/1.4_p301_1",
         "ws_p301/out/1.4_p301_2",
         "ws_p301/out/1.4_p301_3",
         "ws_p301/out/1.4_p301_4",
         "ws_p301/out/1.4_p301_5",
         "ws_p301/out/1.4_p301_6",
         "ws_p301/out/1.4_p301_7",
         "ws_p301/out/1.4_p301_8")

# Basin
tmp1 <- lapply(pre, function(x) sprintf("%s_basin.daily", x))
tmp2 <- lapply(tmp1, function(x) read.table(x, header = T))
bd <- do.call(rbind, tmp2)

# Basin grow
tmp1 <- lapply(pre, function(x) sprintf("%s_grow_basin.daily", x))
tmp2 <- lapply(tmp1, function(x) read.table(x, header = T))
bdg <- do.call(rbind, tmp2)

# Patch
# tmp1 <- lapply(pre, function(x) sprintf("%s_patch.daily", x))
# tmp2 <- lapply(tmp1, function(x) read.table(x, header = T))
# pd <- do.call(rbind, tmp2)
# 
# Patch grow
# tmp1 <- lapply(pre, function(x) sprintf("%s_grow_patch.daily", x))
# tmp2 <- lapply(tmp1, function(x) read.table(x, header = T))
# pdg <- do.call(rbind, tmp2)

# Canopy stratum
tmp1 <- lapply(pre, function(x) sprintf("%s_stratum.daily", x))
tmp2 <- lapply(tmp1, function(x) read.table(x, header = T))
cd <- do.call(rbind, tmp2)

# Canopy stratum grow
tmp1 <- lapply(pre, function(x) sprintf("%s_grow_stratum.daily", x))
tmp2 <- lapply(tmp1, function(x) read.table(x, header = T))
cdg <- do.call(rbind, tmp2)

# Re-export
bd_path <- c("ws_p301/out/1.4_p301_basin.daily")
bdg_path <- c("ws_p301/out/1.4_p301_grow_basin.daily")
cd_path <- c("ws_p301/out/1.4_p301_stratum.daily")
cdg_path <- c("ws_p301/out/1.4_p301_grow_stratum.daily")

write.table(bd, file = bd_path, row.names = FALSE, col.names = TRUE, quote=FALSE, sep="  ")
write.table(bdg, file = bdg_path, row.names = FALSE, col.names = TRUE, quote=FALSE, sep="  ")
write.table(cd, file = cd_path, row.names = FALSE, col.names = TRUE, quote=FALSE, sep="  ")
write.table(cdg, file = cdg_path, row.names = FALSE, col.names = TRUE, quote=FALSE, sep="  ")


# ---------------------------------------------------------------------

beep(1)

