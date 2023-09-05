## clustering 重新运行会重新计算cluster
library(arules)
library(leaflet)
library(fpc)
library(openxlsx)
library(ggplot2)
data = read.csv("listings.csv")
dim(data)
n = nrow(data)
price_data = read.csv("price_data_NYC.csv")
dim(price_data)
#对host_verifications列进行频繁模式挖掘
a=data$host_verifications
for (i in 1:length(a)) {
  a[i]=gsub('\'','',substr(a[i],2,nchar(a[i])-1))
}
write.csv2(a,'a.csv',row.names = F,quote = F)
basket=read.transactions('a.csv',format = 'basket',sep = ',')
summary(basket)
frequentsets=eclat(basket,parameter=list(support=0.5))
inspect(frequentsets)
rules=apriori(basket,parameter = list(support = 0.8, confidence = 0, minlen = 2))
inspect(rules)
m<-rep(0,length(a))
count=0
for(k in 1:length(a)){
  for (j in (as.numeric(basket@data@p[k])+1):(as.numeric(basket@data@p[k+1]))) {
    if(basket@data@i[j]==1 | basket@data@i[j]==10 | basket@data@i[j]==11){
      count=count+1
    }
  }
  if(count==3){
    m[k]=1
  }
  count=0
  print(k)
}

#对amenities进行频繁模式挖掘
b=data$amenities
for (i in 1:length(b)) {
  b[i]=gsub('"','',substr(b[i],2,nchar(b[i])-1))
  
}
write.csv2(b,'b.csv',row.names = F,quote = F)
basket=read.transactions('b.csv',format = 'basket',sep = ',')
summary(basket)
frequentsets=eclat(basket,parameter=list(support=0.5))
fre<-sort(frequentsets,by='support',decreasing = F)
inspect(fre)
itemFrequencyPlot(basket,topN=10,horiz=T,col='red')
rules=apriori(basket,parameter = list(support = 0.5, confidence = 0.7, minlen = 4))
inspect(rules)
ordered_rules<-sort(rules,by='lift')
inspect(ordered_rules)
count=0
g=rep(0,length(b))
for(k in 1:length(b)){
  for (j in (as.numeric(basket@data@p[k])+1):(as.numeric(basket@data@p[k+1]))) {
    if(basket@data@i[j]==1 | basket@data@i[j]==10 | basket@data@i[j]==11 | basket@data@i[j]==32 | basket@data@i[j]==38 | basket@data@i[j]==41){
      count=count+1
    }
  }
  if(count>=5){
    g[k]=1
  }
  count=0
  print(k)
}
count=0
l=rep(0,length(b))
for(k in 1:length(b)){
  for (j in (as.numeric(basket@data@p[k])+1):(as.numeric(basket@data@p[k+1]))) {
    if(basket@data@i[j]==8 | basket@data@i[j]==20 | basket@data@i[j]==25 | basket@data@i[j]==19 | basket@data@i[j]==23){
      count=count+1
    }
  }
  if(count>=3){
    l[k]=1
  }
  count=0
  print(k)
}

#地图
m <- leaflet()
at <- addTiles(m)
for (i in 1:n) {
  addMarkers(at,lng=price_data$longitude[i], lat=price_data$latitude[i],popup="nyc")
}
addMarkers(at,lng=price_data$longitude[1], lat=price_data$latitude[1], popup="nyc")
leaflet(price_data)%>%addTiles()%>%addCircles(weight = 2)%>%addProviderTiles("OpenMapSurfer.Roads")

#基于密度的聚类
#finaldata<-read.xlsx('final1.xlsx',sheet = 1)
#gps=data.frame(finaldata[,28],data0[,27])
gps=data.frame(price_data$longitude,price_data$latitude)
ds<-dbscan(gps,0.01,6)
par(bg='grey')
plot(ds,gps,cex=0.2) # 1 pink, 2 green, 3 dark blue, 4 light blue

price_data$cluster = ds$cluster
table(price_data$cluster)
dataprice1<-price_data[price_data$cluster==1,]
dataprice2<-price_data[price_data$cluster==2,]
dataprice3<-price_data[price_data$cluster==3,]
dataprice4<-price_data[price_data$cluster==4,]
#leaflet(subset(price_data,price_data$cluster==(1)))%>%addTiles()%>%addCircles(weight = 2)%>%addProviderTiles("OpenMapSurfer.Roads")

dataprice1$price = as.numeric(substring(dataprice1$price,2))
dataprice2$price = as.numeric(substring(dataprice2$price,2))
dataprice3$price = as.numeric(substring(dataprice3$price,2))
dataprice4$price = as.numeric(substring(dataprice4$price,2))
data.frame(mean = c(mean(dataprice1$price,na.rm = T),mean(dataprice2$price,na.rm = T),mean(dataprice3$price,na.rm = T),mean(dataprice4$price,na.rm = T)),
           var = c(var(dataprice1$price,na.rm = T),var(dataprice2$price,na.rm = T),var(dataprice3$price,na.rm = T),var(dataprice4$price,na.rm = T)),
           median = c(median(dataprice1$price,na.rm = T),median(dataprice2$price,na.rm = T),median(dataprice3$price,na.rm = T),median(dataprice4$price,na.rm = T)),
           row.names = c("dataprice1","dataprice2","dataprice3","dataprice4"))

opar = par(mfrow = c(2,2))
hist(dataprice1$price)
hist(dataprice1[dataprice1$price<=200,]$price)
hist(dataprice2$price)
hist(dataprice3$price)
hist(dataprice4$price)
par(opar)


cPal <- colorNumeric(palette = c("blue",'yellow',"red"),domain = dataprice1[dataprice1$price<=600,]$price)
leaflet(dataprice1[dataprice1$price<=600,])%>%addTiles%>%addCircleMarkers(fillColor = ~cPal(dataprice1$price),stroke = FALSE,fillOpacity = 1,popup=~as.character(price))%>%
  addLegend("bottomright", pal = cPal, values = ~price,bins = c(200,400,600),title = "price",labFormat = labelFormat(suffix = "USD"),opacity = 1)
ggplot(data = dataprice1[dataprice1$price>=200 & dataprice1$price<=600,], 
       mapping = aes(x = dataprice1[dataprice1$price>=200 & dataprice1$price<=600,]$longitude, 
                     y = dataprice1[dataprice1$price>=200 & dataprice1$price<=600,]$latitude, 
                     colour =dataprice1[dataprice1$price>=200 & dataprice1$price<=600,]$price)) + geom_point(size =2,alpha = 0.3) + scale_colour_gradient(low = 'green', high = 'red', breaks = c(1200))
plot.gg = function(data,lower,higher){
  ggplot(data = data[data$price>lower & data$price<=higher,], 
         mapping = aes(x = data[data$price>lower & data$price<=higher,]$longitude, 
                       y = data[data$price>lower & data$price<=higher,]$latitude)) + geom_point(size = 1 )
                       #size = data[data$price>lower & data$price<=higher,]$price)) + scale_size_area(max_size = 3)
  
}
#p1 = plot.gg(dataprice1, 400, 10^4)
#p2 = plot.gg(dataprice1, 300, 400)
#p3 = plot.gg(dataprice1, 220, 300)
#p4 = plot.gg(dataprice1, 180, 220)
#p5 = plot.gg(dataprice1, 160, 180)
#p6 = plot.gg(dataprice1, 150, 160)
#
#cowplot::plot_grid(p1,p2,p3,p4,p5,p6,nrow = 2)

# 对dataprice1 kmeans细分4类
gps1 = data.frame(dataprice1$longitude,dataprice1$latitude)
k=4
km1 = kmeans(gps1,k)
table(km1$cluster)
dataprice1$km.cluster = km1$cluster
# price mean
for(i in 1:k){
  print(mean(dataprice1[dataprice1$km.cluster==i,]$price,na.rm = T))
}
# price median
for(i in 1:k){
  print(median(dataprice1[dataprice1$km.cluster==i,]$price,na.rm = T))
}
# price hist
par(mfrow = c(2,2))
for(i in 1:4){
  hist(dataprice1[dataprice1$km.cluster==i,]$price,na.rm = T)
}
qplot(dataprice1$longitude,dataprice1$latitude,colour = km1$cluster)

# 一共4+3=7类
dataprice2$km.cluster = NA
dataprice3$km.cluster = NA
dataprice4$km.cluster = NA
final_dataprice1<-dataprice1[dataprice1$km.cluster==1,]
final_dataprice1$final_cluster = 1
final_dataprice2<-dataprice1[dataprice1$km.cluster==2,]
final_dataprice2$final_cluster = 2
final_dataprice3<-dataprice1[dataprice1$km.cluster==3,]
final_dataprice3$final_cluster = 3
final_dataprice4<-dataprice1[dataprice1$km.cluster==4,]
final_dataprice4$final_cluster = 4
final_dataprice5<-dataprice2
final_dataprice5$final_cluster = 5
final_dataprice6<-dataprice3
final_dataprice6$final_cluster = 6
final_dataprice7<-dataprice4
final_dataprice7$final_cluster = 7
final_cluster_data = data.frame(rbind(final_dataprice1,final_dataprice2,final_dataprice3,final_dataprice4,
      final_dataprice5,final_dataprice6,final_dataprice7))
#write.csv(final_cluster_data, file = "final_cluster_data.csv")


