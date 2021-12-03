######## 从这开始 ########
final_cluster_data <- read.csv("final_cluster_data.csv")

# 根据 price 设置点色阶画图
cPal <- colorRampPalette(c('blue','red'))
datCol<-cPal(100)[as.numeric(cut(final_cluster_data[final_cluster_data$price<=800,]$price,breaks = 100))]
leaflet(final_cluster_data[final_cluster_data$price<=800,])%>%addTiles()%>%addCircles(color = datCol)

# 每组price的描述统计量
data.frame(mean = tapply(final_cluster_data$price, final_cluster_data$final_cluster, mean, na.rm = T),
           var = tapply(final_cluster_data$price, final_cluster_data$final_cluster, var, na.rm = T),
           median = tapply(final_cluster_data$price, final_cluster_data$final_cluster, median, na.rm = T),
           row.names = c("cluster1","cluster2","cluster3","cluster4","cluster5","cluster6","cluster7"))

# 根据cluster画图
#qplot(final_cluster_data$longitude,final_cluster_data$latitude,colour = final_cluster_data$final_cluster)
# cluster 地图
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

