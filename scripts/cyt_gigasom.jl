# code for the cytometry example
using Pkg
Pkg.add("GigaSOM")

using GigaSOM

params, data = loadFCS("data/Levine_13dim.fcs")

getMetaData(params)

data

data = data[:,1:13]
som = initGigaSOM(data, 16, 16)
som = trainGigaSOM(som, data)
clusters = mapToGigaSOM(som, data)
e = embedGigaSOM(som, data)

# plot
draw(
    PNG("fig_test_cyto_example.png", 20cm, 20cm),
    plot(x = e[:,1], y = e[:,2], color = data[:,1])
)
