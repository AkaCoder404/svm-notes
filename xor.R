# Script to product an XOR classification plot using ggplot2

# Load necessary library
library(ggplot2)
library(e1071)

# Set seed for reproducibility
set.seed(1)

# Generate random data
X_xor <- matrix(rnorm(500), ncol = 2)
y_xor <- ifelse(X_xor[, 1] > 0, 1, 0) != ifelse(X_xor[, 2] > 0, 1, 0)

# Convert to dataframe for ggplot
data <- data.frame(X1 = X_xor[, 1], X2 = X_xor[, 2], Class = factor(y_xor))

# Create plot
p <- ggplot(data, aes(x = X1, y = X2, color = Class, shape = Class)) +
    geom_point(size = 4) +
    scale_color_manual(values = c("blue", "red")) +
    scale_shape_manual(values = c(15, 16)) + # Using different shapes for classes
    labs(x = "Feature 1", y = "Feature 2") +
    ggtitle("XOR Classification") +
    theme_minimal() +
    xlim(-3, 3) +
    ylim(-3, 3) +
    theme(legend.title = element_blank())

print(p)

svmfit <- svm(Class ~ ., data = data, kernel = "radial", scale = FALSE)
plot(svmfit, data,
    col = c("lightblue", "lightgreen"), # Colors for classes
    pch = c(19, 19), # Solid circle for all classes
    cex = 1.5
) # Increase the size of the points
