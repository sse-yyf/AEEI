library(terra)

community <- vect("../../raw/Kommun_RT90_region.shp")
crs(community)

pdf("../outcome/community.pdf") 
plot(community)
dev.off()

# re-projecting

railway <- vect("../../raw/jl_riks.shp")
new.crs <- crs(community)
railway.newproj <- project(railway, new.crs)

pdf("../outcome/railway in community.pdf")
plot(community)
plot(railway.newproj, add = TRUE, col = "#66CCFF")
dev.off()