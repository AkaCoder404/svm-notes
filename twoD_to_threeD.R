library(ggplot2)
library(MASS)
library(rgl)
library(e1071)

# Set seed for reproducibility
set.seed(123)

# Parameters for the dataset
num_points_center <- 100 # Number of points in the center cluster
num_points_surround <- 300 # Number of points in the surrounding cluster
radius <- 2 # Radius of the surrounding ring
ring_width <- 0.2 # Width of the ring

# Generate the central cluster
mean_center <- c(0, 0)
cov_center <- matrix(c(0.1, 0, 0, 0.1), nrow = 2)
data_center <- mvrnorm(n = num_points_center, mu = mean_center, Sigma = cov_center)
labels_center <- rep(0, num_points_center)

# Generate the surrounding ring using polar coordinates
angles <- runif(num_points_surround, 0, 2 * pi)
radii <- rnorm(num_points_surround, mean = radius, sd = ring_width)
data_surround <- cbind(radii * cos(angles), radii * sin(angles))
labels_surround <- rep(1, num_points_surround)

# Combine the datasets
data <- rbind(data_center, data_surround)
labels <- c(labels_center, labels_surround)

# Convert matrix to a data frame
data_df <- as.data.frame(data)
names(data_df) <- c("X1", "X2") # naming the columns

# Combine labels with data
data_df$labels <- as.factor(labels) # make sure labels are factors for the svm model

# Plot the dataset using base R plot
colors <- c("red", "blue")
plot(data_df$X1, data_df$X2, col = colors[labels + 1], pch = 19, xlab = "", ylab = "", main = "2D Dataset with Central Cluster and Surrounding Ring")

# Train SVM
svmfit <- svm(labels ~ ., data = data_df, kernel = "polynomial", degree = 3, scale = FALSE)
print(svmfit)

# Plot SVM model using plot.svm
# plot(svmfit, data_df)

# Map the points using the following: M(x1, x2) = (x1, x2, x1^2 + x2^2)
# Create the mapped dataset
data_mapped <- cbind(data, data[, 1]^2 + data[, 2]^2)
z <- data_mapped[, 3]
# Plot to a 3D mapping
open3d()
plot3d(data[, 1], data[, 2], z, col = colors[labels + 1], size = 5, xlab = "", ylab = "", zlab = "")
legend3d("topright", legend = c("Center Cluster", "Surrounding Ring"), col = 1:2, pch = 16)

# Draw a plane at z = 2 to separate the two clusters
planes3d(a = 0, b = 0, c = 1, d = -1.5, alpha = 0.5, col = "gray")

# Map the plane back to 2D space
# Draw the circle for z = 1.5
radius_z <- sqrt(1.5)
theta <- seq(0, 2 * pi, length.out = 100)
x <- radius_z * cos(theta)
y <- radius_z * sin(theta)
lines(x, y, col = "red", lwd = 2)
