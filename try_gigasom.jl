# code to try gigasom
using Pkg
Pkg.add("GigaSOM")

using GigaSOM

d = randn(10000,4) .+ rand(0:1, 10000, 4).*10

som = initGigaSOM(d, 20, 20)
som = trainGigaSOM(som, d)

som.codes

mapToGigaSOM(som, d)

e = embedGigaSOM(som,d)

Pkg.add("Gadfly")
Pkg.add("Cairo")

using Gadfly
import Cairo

draw(PNG("test.png",20cm,20cm), plot(x=e[:,1], y=e[:,2], color=d[:,1]))