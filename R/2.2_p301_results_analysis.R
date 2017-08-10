# Code for analyzing the fire seminar runs
# 
# 

source("R/0.1_utilities.R")

# ---------------------------------------------------------------------
# Patch-level analysis

# Plot height
ggplot(canopy_results) +
  geom_line(aes(x=date, y=height, color=as.factor(scenario), linetype=as.factor(canopy_layer))) +
  ylim(0,30)

# Plot plantc (plantc includes roots. Need to exclude.)
ggplot(canopy_results) +
  geom_line(aes(x=date, y=plantc, color=as.factor(canopy_layer))) +
  geom_hline(aes(yintercept = 700)) +
  geom_hline(aes(yintercept = 500))

# Plot leafc
ggplot(canopy_results) +
  geom_line(aes(x=date, y=leafc, color=as.factor(canopy_layer))) +
  ylim(0,1000)

# Plot above_ground_carbon
ggplot(canopy_results) +
  geom_line(aes(x=date, y=above_ground_carbon, color=as.factor(scenario), linetype=as.factor(canopy_layer)))+
  ylim(0,4000)

# Plot litter
ggplot(basin_results) +
  geom_line(aes(x=date, y=litrc, color=as.factor(run)))


# Plot below_ground_carbon
ggplot(canopy_results) +
  geom_line(aes(x=date, y=below_ground_carbon, color=as.factor(run), linetype=as.factor(canopy_layer)))+
  ylim(0,5000)

# Plot live_crootc
ggplot(cdg) +
  geom_line(aes(x=date, y=dead_crootc, color=as.factor(canopy_layer))) +
  ylim(0,70)

# Plot litrc
ggplot(pdg) +
  geom_line(aes(x=date, y=litr4c))

ggplot(bdg) +
  geom_line(aes(x=date, y=litrc)) +
  geom_hline(aes(yintercept = 0.7))

ggplot(results$bdg.wyd) +
  geom_line(aes(x=wyd, y=litrc))


# Plot streamflow
ggplot(basin_results) +
  geom_line(aes(x=date, y=streamflow, color=as.factor(scenario)))

basin_results_groups <- dplyr::group_by(basin_results, wy, scenario)
basin_results_wy <- dplyr::summarise(basin_results_groups,
                                     streamflow_wy = sum(streamflow))
ggplot(basin_results_wy) +
  geom_boxplot(aes(x=wy ,y=streamflow_wy, color=as.factor(scenario)))


ggplot(basin_results) +
  geom_line(aes(x=date, y=streamflow, color=as.factor(scenario))) +
  xlim("1966-1-1","1968-1-1")


ggplot(basin_results) +
  geom_line(aes(x=date, y=litter, color=as.factor(scenario)))


basin_results_groups <- dplyr::group_by(basin_results, wy, scenario)
basin_results_wy <- dplyr::summarise(basin_results_groups,
                                     streamflow_wy = sum(streamflow))
ggplot(basin_results_wy) +
  geom_line(aes(x=wy, y=streamflow_wy, color=scenario))


basin_results_run_1 <- dplyr::filter(basin_results, scenario==1)
basin_results_groups <- dplyr::group_by(basin_results_run_1, wy, scenario)
basin_results_wy <- dplyr::summarise(basin_results_groups,
                                     streamflow_wy = sum(streamflow))
ggplot(basin_results_wy) +
  geom_line(aes(x=wy, y=streamflow_wy, color=scenario))


ggplot(canopy_results) +
  geom_line(aes(x=date, y=above_ground_carbon, color=as.factor(scenario), linetype=as.factor(canopy_layer)))

canopy_results_groups <- dplyr::group_by(canopy_results, wy, scenario, canopy_layer)
canopy_results_wy <- dplyr::summarise(canopy_results_groups,
                                      above_ground_carbon_wy = sum(above_ground_carbon))
ggplot(canopy_results_wy) +
  geom_line(aes(x=wy, y=above_ground_carbon_wy, color=scenario, linetype=as.factor(canopy_layer)))

