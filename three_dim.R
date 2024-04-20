library(rgl)
library(e1071)

# Load data
data(iris)
data <- iris

# Only include two species for binary classification
# data <- data[data$Species != "versicolor", ]

# Fit SVM
model <- svm(
    Species ~ Sepal.Length + Sepal.Width + Petal.Length,
    data = data,
    kernel = "linear",
    scale = FALSE
)

# Create a sequence of values for each dimension
sl <- seq(min(data$Sepal.Length), max(data$Sepal.Length), length = 30)
sw <- seq(min(data$Sepal.Width), max(data$Sepal.Width), length = 30)
pl <- seq(min(data$Petal.Length), max(data$Petal.Length), length = 30)

# Expand grid to cover all combinations
grid <- expand.grid(Sepal.Length = sl, Sepal.Width = sw, Petal.Length = pl)

# Predict using the SVM model
classes <- predict(model, grid)

# Assign colors based on classes
colors <- ifelse(classes == "setosa", "red", "blue")
# colors <- ifelse(iris$Species == "setosa", "red",
#     ifelse(iris$Species == "versicolor", "blue", "green")
# )

# Plot the original data points
plot3d(
    x = data$Sepal.Length,
    y = data$Sepal.Width,
    z = data$Petal.Length,
    col = ifelse(data$Species == "setosa", "red", "blue"),
    # col = ifelse(iris$Species == "setosa", "red",
    #     ifelse(iris$Species == "versicolor", "blue", "green")
    # ),
    type = "s",
    radius = 0.05,
    xlab = "Sepal Length", ylab = "Sepal Width", zlab = "Petal Length"
)

# Add the SVM decision plane
points3d(
    x = grid$Sepal.Length,
    y = grid$Sepal.Width,
    z = grid$Petal.Length,
    col = colors,
    alpha = 0.5, # Semi-transparent
    size = 1
)
