# bushns = [2, 3, 4, 5, 6, 7, 8]
# nstdistance = [ 0.42599 0.24868 0.16772 0.12339 0.09586 0.07725 0.06408;
#                 0.46299 0.21781 0.12874 0.08541 0.0611 0.04575 0.03653;
#                 0.41777 0.16249 0.08449 0.05089 0.03337 0.02382 0.01724;
#                 0.34919 0.11346 0.05236 0.0289 0.01813 0.01188 0.00855]

bushns = [3, 4, 5, 6, 7, 8]
nstdistance = [ 0.24868 0.16772 0.12339 0.09586 0.07725 0.06408;
                0.21781 0.12874 0.08541 0.0611 0.04575 0.03653;
                0.16249 0.08449 0.05089 0.03337 0.02382 0.01724;
                0.11346 0.05236 0.0289 0.01813 0.01188 0.00855]

using PyPlot
pt = subplot2grid((1,5), (0,0), colspan=5)
pt.spines["top"].set_visible(false) #remove the box
pt.spines["right"].set_visible(false)
for i=1:size(nstdistance,1)
    pt.plot(bushns,nstdistance[i,:],linewidth=2,marker = ".",label ="Height = $i")
end
#title("Process distance vs bushiness for trees of different heights")
xlabel("Branches at each node")
ylabel("Multistage distance")
#title("Process Distance")
axis("tight") # Fit the axis tightly to the plot
legend(loc="upper right",fancybox="true") # Create a legend of all the existing plots using their labels as names
#grid(true)
#savefig("BushNesHeight.png")
