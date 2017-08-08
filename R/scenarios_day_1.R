# SERI Fire Seminar - Day 1

# ---------
# Install R and RStudio.

# --------- 
# Download packages 
# We will be using the packages ggplot2 and dplyr. We may also need other 
# packages depending on the type of analyses conducted this week. These two
# packages can be downloaded individually or together with a number of other
# convenient packages using tidyverse.

# ---------
# Download scenarios
# These are available from GoogleDrive. Save someplace on your computer.

library(ggplot2)
library(dplyr)

# Import data
# basin.results=read.table(file.choose(),header=T)
basin_results <- read.table("outputs/basin_results.txt", header = T)
canopy_results <- read.table("outputs/canopy_results.txt", header = T)
basin_results$date <- as.Date(basin_results$date)
canopy_results$date <- as.Date(canopy_results$date)
head(basin_results)
head(canopy_results)

# Plot precipitation time-series
ggplot(basin_results) +
  geom_line(aes(x=date, y=precip))

# Plot annual precipitation time-series
basin_results_run_1 <- dplyr::filter(basin_results, run==1)
basin_results_groups <- dplyr::group_by(basin_results_run_1, wy)
basin_results_wy <- dplyr::summarise(basin_results_groups,
                                    precip_wy = sum(precip),
                                    streamflow_wy = sum(streamflow))
ggplot(basin_results_wy) +
  geom_line(aes(x=wy, y=precip_wy)) +
  geom_line(aes(x=wy, y=streamflow_wy))
summary(basin_results_wy)


