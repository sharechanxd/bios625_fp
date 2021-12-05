library(arules)
library(leaflet)
library(fpc)
library(openxlsx)
library(ggplot2)

final_cluster_data <- read.csv("final_cluster_data.csv")

# DBSCAN map
cPal <- colorNumeric(palette = c("black","blue"),domain = final_cluster_data$cluster)
leaflet(final_cluster_data)%>%addTiles%>%addCircles(color = ~cPal(final_cluster_data$cluster))%>%
  addLegend("bottomright", pal = cPal, values = ~cluster,bins = c(1,2,3,4),title = "cluster_DBSCAN")

# price map
cPal <- colorRampPalette(c('blue','red'))
datCol<-cPal(100)[as.numeric(cut(final_cluster_data[final_cluster_data$price<=800,]$price,breaks = 100))]
leaflet(final_cluster_data[final_cluster_data$price<=800,])%>%addTiles()%>%addCircles(color = datCol)

# final-cluster visualization
# descriptive statistics of price of each cluster
data.frame(mean = tapply(final_cluster_data$price, final_cluster_data$final_cluster, mean, na.rm = T),
           var = tapply(final_cluster_data$price, final_cluster_data$final_cluster, var, na.rm = T),
           median = tapply(final_cluster_data$price, final_cluster_data$final_cluster, median, na.rm = T),
           row.names = c("cluster1","cluster2","cluster3","cluster4","cluster5","cluster6","cluster7"))

# cluster plot
#qplot(final_cluster_data$longitude,final_cluster_data$latitude,colour = final_cluster_data$final_cluster)
# cluster map
cPal <- colorNumeric(palette = c("black","green"),domain = final_cluster_data$final_cluster)
leaflet(final_cluster_data)%>%addTiles%>%addCircles(color = ~cPal(final_cluster_data$final_cluster))%>%
  addLegend("bottomright", pal = cPal, values = ~final_cluster,bins = c(1,2,3,4,5,6,7),title = "cluster")

# cluster vs price boxplot
ggplot(data = final_cluster_data, aes(x=as.character(final_cluster),y=price, fill = final_cluster))+
  geom_boxplot()+
  guides(fill=guide_legend(title=NULL))+
  labs(title='prices in different areas (clusters)', x="cluster",y="price(/USD)")+
  theme(text=element_text(family="Kai"),plot.title = element_text(hjust = 0.5))+
  ylim(c(0,400))

