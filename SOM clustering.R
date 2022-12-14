library(kohonen)

str(Workers)

workers_SOM <- as.matrix(scale(Workers[,-1]))

workers_grid <- somgrid(xdim = 4, ydim = 4, topo = "hexagonal")

set.seed(123)

workers_SOM_model <- som(X = workers_SOM, grid = workers_grid)

plot(workers_SOM_model, type = "counts")

plot(workers_SOM_model, type = "property",
     property = getCodes(workers_SOM_model)[, 1],
     main = colnames(Workers)[2])

plot(workers_SOM_model, type="changes")



# Viewing WCSS for kmeans
mydata <- workers_SOM_model$codes[[1]]
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var)) 
for (i in 2:15) {
  wss[i] <- sum(kmeans(mydata, centers=i)$withinss)
}
plot(wss)

som_cluster <- cutree(hclust(dist(workers_SOM_model$codes[[1]])), 6)
# Colour palette definition
pretty_palette <- c("#1f77b4", '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2')
# plot these results:
plot(workers_SOM_model, type="mapping", bgcol = pretty_palette[som_cluster], main = "Clusters") 
add.cluster.boundaries(workers_SOM_model, som_cluster)

cluster_assignment <- som_cluster[workers_SOM_model$unit.classif]
Workers$cluster <- cluster_assignment



