# Code for analyzing the fire seminar runs
# 
# 

source("R/0.1_utilities.R")

# ---------------------------------------------------------------------
# Patch-level analysis

# Plot height
ggplot(canopy_results) +
  geom_line(aes(x=date, y=height, color=as.factor(run), linetype=as.factor(canopy_layer))) +
  ylim(0,30)

# Plot plantc (plantc includes roots. Need to exclude.)
ggplot(cdg) +
  geom_line(aes(x=date, y=plantc, color=as.factor(canopy_layer))) +
  geom_hline(aes(yintercept = 700)) +
  geom_hline(aes(yintercept = 500))

# Plot leafc
ggplot(cdg) +
  geom_line(aes(x=date, y=leafc, color=as.factor(canopy_layer))) +
  ylim(0,1000)

# Plot live_stemc
ggplot(cdg) +
  geom_line(aes(x=date, y=live_stemc, color=as.factor(canopy_layer)))

# Plot dead_stemc
ggplot(cdg) +
  geom_line(aes(x=date, y=dead_stemc, color=as.factor(canopy_layer)))+
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



