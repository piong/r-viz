#####################################################################################
# This R file shows that almost all men are stronger than almost all women, according to
# a test of grip strength. Data was taken from the CDC's NHANES 2011-2012 data set
# that can be found here: 
#   http://www.cdc.gov/nchs/nhanes/nhanes2011-2012/overview_g.htm
# 
# This is a replication of redditor grasshoppermouse's visualization. The original
# viz can be found here:
#   https://i.redditmedia.com/Pa3fEwuyuzaNqxWWfjkfuQecyVO6IZcSiNsl7n5uEg8.png?w=768&s=d9f32895f3d47ef4c6480d9680ca206e
# and the reddit thread can be found here:
#   https://www.reddit.com/r/dataisbeautiful/comments/4vcxd0/almost_all_men_are_stronger_than_almost_all_women/
#####################################################################################

install.packages("Hmisc")  # to read .XPT data
install.packages("dplyr")  # to manipulate and merge datasets
install.packages("ggplot2")  # for data visualization
install.packages("RColorBrewer")  # for fancy colors.

library(Hmisc)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# set your working directory
setwd("~/Grip strength NHANES data")

# get data here: http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/MGX_G.XPT
# documentation here: http://wwwn.cdc.gov/nchs/nhanes/2011-2012/MGX_G.htm
gripdf <- sasxport.get("MGX_G.XPT")

# get data here: http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DEMO_G.XPT
# documentation here: http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DEMO_G.htm
demodf <- sasxport.get("DEMO_G.XPT") 

# merge gripdf and demodf on variable seqn to get gender + age + grip strength
comb <- inner_join(demodf, gripdf, by = "seqn")

# recoding values to strings, for legend labels later
comb$sex <- ifelse(comb$riagendr == 1, "Male", ifelse(comb$riagendr == 2, "Female", ""))

p <- ggplot(comb, aes(ridageyr, mgdcgsz, group=sex))

p +
  geom_count(shape=1, aes(color=factor(comb$sex))) +
  geom_smooth(se=FALSE, size=0.5, color="black") +
  scale_colour_brewer(palette="Set1") +
  theme_bw(base_family="Times") +
  guides(size=FALSE, color=guide_legend("Gender", reverse=TRUE)) +
  labs(x="Age", y="Combined Grip Strength (kg)", title="Grip Strength for Males vs Females")

# export image to your local directory
ggsave("gripstrength_by_gender.png", width=7, height=6)
