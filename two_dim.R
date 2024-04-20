library(e1071)
library(ggplot2)

# Load and prepare data
data(iris)
# data <- iris[iris$Species != "versicolor", ]
data <- iris

# Fit SVM for two features
# Also supports linear, polynomial, radial, sigmoid
model <- svm(
    Species ~ Sepal.Length + Sepal.Width,
    data = data,
    kernel = "linear"
)

print(model)

# Tune the model
costs <- c(0.001,0.01,.1,1,10,100)
tuned_model <- tune(
    svm,
    Species ~ Sepal.Length + Sepal.Width,
    data = data,
    kernel = "linear",
    ranges = list(cost = costs, gamma = c(0.1, 1, 10))
)

print(tuned_model)

# Create a sequence of values for each dimension
sl <- seq(min(data$Sepal.Length), max(data$Sepal.Length), length = 100)
sw <- seq(min(data$Sepal.Width), max(data$Sepal.Width), length = 100)

# Expand grid to cover all combinations
grid <- expand.grid(Sepal.Length = sl, Sepal.Width = sw)

# Predict using the SVM model
grid$Species <- predict(model, grid)

# Plot
p <- ggplot(data, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
    geom_point(alpha = 0.5, size = 3) +
    geom_tile(data = grid, aes(fill = Species, alpha = 2), color = NA) +
    scale_fill_manual(values = c("setosa" = "red", "virginica" = "blue", "versicolor" = "green")) +
    scale_color_manual(values = c("setosa" = "red", "virginica" = "blue", "versicolor" = "green")) +
    ggtitle("SVM Decision Boundary with Sepal Measurements") +
    theme_minimal() +
    theme(legend.position = "top")

print(p)

# Confusion matrix on predictions
confusion_matrix <- table(data$Species, predict(model, data))
print(confusion_matrix)
