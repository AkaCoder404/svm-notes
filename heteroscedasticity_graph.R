library(ggplot2)
library(e1071)

# Set seed for reproducibility
set.seed(123)

# Parameters for the dataset
num_points_per_class <- 300
max_x <- 4.0
max_y <- 8
exclusion_radius <- 0.15 # Radius within which points are excluded
standard_deviation_factor <- 0.9 # How many standard deviations to plot for the envelope

# Generate data points for XOR pattern with heteroscedasticity
# Generate more initially to compensate for filtering
x1 <- runif(num_points_per_class * 2, -max_x, max_x)
x2_positive <- x1 + rnorm(num_points_per_class * 2, sd = abs(x1) / 2 * standard_deviation_factor)

x2_negative <- -x1 + rnorm(num_points_per_class * 2, sd = abs(x1) / 2 * standard_deviation_factor)

# Combine into a data frame
data <- data.frame(x1 = x1, x2 = c(x2_positive, x2_negative), labels = factor(rep(0:1, each = num_points_per_class * 2)))

# Filter out points near the center (0,0)
data <- data[with(data, sqrt(x1^2 + x2^2) > exclusion_radius), ]

# Ensure that we have roughly equal numbers after filtering
data_positive <- data[data$labels == 0, ][1:num_points_per_class, ]
data_negative <- data[data$labels == 1, ][1:num_points_per_class, ]
data <- rbind(data_positive, data_negative)

# Fit the model for data_positive
model_positive <- lm(x2 ~ x1, data = data_positive)

# Generate predictions and confidence intervals
newx <- seq(min(data$x1), max(data$x1), length.out = length(data$x1))
preds_positive <- predict(model_positive, newdata = data.frame(x1 = newx), interval = "confidence", level = 0.99)
preds_positive_df <- data.frame(x1 = newx, lwr = preds_positive[, "lwr"], upr = preds_positive[, "upr"])


# Fit the model for data_negative
model_negative <- lm(x2 ~ x1, data = data_negative)
newy <- seq(min(data$x2), max(data$x2), length.out = length(data$x2))
preds_negative <- predict(model_negative, newdata = data.frame(x2 = newy), interval = "confidence", level = 0.99)
preds_negative_df <- data.frame(x2 = newy, lwr = preds_negative[, "lwr"], upr = preds_negative[, "upr"])

# Ribbon to contain all data_positive of positive points
ribbon_positive <- data.frame(x1 = c(preds_positive_df$x1, rev(preds_positive_df$x1)), y = c(preds_positive_df$upr, rev(preds_positive_df$lwr)))



# Plot using ggplot
colors <- c("blue", "red")
# p <- ggplot(data, aes(x = x1, y = x2, colors = labels)) +
p <- ggplot(data, aes(x = x1, y = x2)) +
    geom_point(alpha = 0.6, size = 3, aes(color = labels)) +
    scale_color_manual(values = c("blue", "red")) +
    labs(title = "2D XOR Dataset with Heteroscedasticity, Excluding Center", x = "X1", y = "X2") +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "blue") +
    geom_abline(slope = -1, intercept = 0, linetype = "dashed", color = "red") +
    # Graph the confidence interval for the positive class
    geom_ribbon(data = preds_positive_df, aes(y = NULL, ymin = lwr, ymax = upr), fill = "grey80", alpha = 0.5) +
    geom_ribbon(data = preds_negative_df, aes(y = NULL, ymin = lwr, ymax = upr), fill = "grey80", alpha = 0.5) +
    # Ribbon
    coord_equal(ratio = 1) +
    xlim(-6, 6) +
    ylim(-6, 6) +
    theme_minimal()

print(p)

# Calculate SVM
svmfit <- svm(labels ~ ., data = data, kernel = "radial", cost = 10, scale = FALSE)

# Plot the decision boundary
plot(svmfit, data)


# function map2Dto3D() {
#     # Map the 2D data to 3D space
#     data_mapped <- cbind(data, data$x1^2 + data$x2^2)
#     z <- data_mapped[, 3]

#     # Plot to a 3D mapping
#     open3d()
#     plot3d(
#         data$x1,
#         data$x2,
#         z,
#         col = c("blue", "red")[as.numeric(data$labels)],
#         size = 5,
#         xlab = "",
#         ylab = "",
#         zlab = ""
#     )
#     legend3d("topright", legend = c("Class 0", "Class 1"), col = 1:2, pch = 16)
#     planes3d(a = 0, b = 0, c = 1, d = -1.4, alpha = 0.5, col = "gray")
# }
