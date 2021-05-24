# code for a gigasom trial on realistic data

using CSV
using DataFrames
using GigaSOM
using FastRunningMedian

# for plotting
using Gadfly
import Cairo

# read data and plot for sanity
data = CSV.read("data/whole_season_preproc_435.csv", DataFrame)

# a simple speed function
sld = function (data, x, y, t)
    xdiff = data[2:(nrow(data)),x] .- data[(1:(nrow(data) - 1)),x]
    ydiff = data[2:(nrow(data)),y] .- data[(1:(nrow(data) - 1)),y]
    tdiff = data[2:(nrow(data)),t] .- data[(1:(nrow(data) - 1)),t]
    return vcat(Inf, sqrt.((xdiff .^ 2) .+ (ydiff .^ 2)) ./ tdiff)
end

# add speed
data[:, "speed"] = sld(data, "x", "y", "time")


# select first 2000 rows and
# select relevant cols - waterlevel and speed
data = data[1:2000,:]
filter!(row -> row.speed < Inf, data)
# add smoothed speed
data[:,"speed_smooth"] = running_median(data[:,"speed"], 5)

data_som = data[:,["speed", "speed_smooth"]]

# run gigasom, we only want perhaps 3 clusters
# initGigaSOM works for DFs that can be coerced to matrix
som = initGigaSOM(data_som, 1, 3)
som = trainGigaSOM(som, data_som)

som.codes

indices = mapToGigaSOM(som, data_som)

# add indices to data
data[:,"index"] = indices.index

# palettef = Scale.lab_gradient("darkgreen", "orange", "blue")
# plot to check
using RCall

R"library(ggplot2)"
R"ggplot($data)+
    geom_path(aes(x,y),size=0.2)+
    geom_point(aes(x,y,fill=factor(index)),shape=21,size = 2)+
    facet_wrap(~tide_number)+
    coord_sf(crs = 32631)"
