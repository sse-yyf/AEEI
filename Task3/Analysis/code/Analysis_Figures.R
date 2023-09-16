library(ggplot2)
library(cluster)
library(factoextra)
library(ggrepel)

df <- read.csv("../input/selected_WV6.csv")
rownames(df) <- df[,1]
df <- df[,c("Job","Democracy","Strong_Leader","Poli_Leader","University","Business")]

#####################################
###           Analysis            ###
#####################################



# kmeans
km_result <- kmeans(df[,c("Job","Democracy")], centers = 7,nstart = 10,algorithm="Hartigan-Wong",iter.max=20)



# prcomp()
pca <- prcomp(df, scale = TRUE)


#####################################
###           Figures             ###
#####################################



# kmeans
kmeans_figure <- fviz_cluster(km_result, df[,c("Job","Democracy")],
             geom.label = TRUE,      # Show labels for data points
             palette = c("#66CCFF", "#00FFCC","#E7B800", "#EE0000","#f5ccd8","#006666","#FC4E07"),
             #ellipse.type = "euclid",
             star.plot = TRUE, 
             repel = TRUE,
             main="K-means Cluster plot",
             ggtheme = theme_minimal()
)
ggsave("../outcome/kmeans.png", plot = kmeans_figure)



# PCA Analysis
scree_plot <- fviz_eig(pca)
ggsave("../outcome/pca_scree_plot.png", plot = scree_plot)
variables_plot <- fviz_pca_var(pca, 
                               col.var = "cos2",
                               repel = TRUE)
ggsave("../outcome/pca_variables_plot.png", plot = variables_plot)


# PCA Ind 
pca_df <- as.data.frame(pca$x)
pca_df$cluster <- km_result$cluster
pca_df$country_name <- rownames(df)
# Use cluster
individuals_plot <- ggplot(data = pca_df, aes(x = PC1, y = PC2, color = factor(cluster))) +
  geom_point() +
  geom_text_repel(aes(label = country_name)) 
ggsave("../outcome/pca_individuals_plot.png", plot = individuals_plot)


