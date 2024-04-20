library(e1071)

# Subset and prepare the data
data <- iris[iris$Species %in% c("setosa", "virginica"), ]

# Fit the SVM model
model <- svm(Species ~ Petal.Width,
    data = data, kernel = "linear"
)

# Generate a sequence of Petal.Width values for prediction
Petal_width_range <- seq(
    min(data$Petal.Width), max(data$Petal.Width),
    length.out = 300
)

# Predict species for each value in Petal_width_range
predictions <- predict(
    model, data.frame(Petal.Width = Petal_width_range),
    decision.values = TRUE
)

# Extract decision values
dec_values <- attributes(predictions)$decision.values

# Find the Petal.Width value where decision value is closest to zero
# (crossing point)
boundary_point <- Petal_width_range[which.min(abs(dec_values))]

# Plotting
xlim <- c(0, 4)
ylim <- c(0, 1)
col <- c("red", "yellow", "blue")
plot(NA, xlim = xlim, ylim = ylim, axes = FALSE, ann = FALSE)
points(data$Petal.Width,
    rep(0, length(data$Petal.Width)),
    col = col[data$Species],
    pch = 19
)

axis(1)
axis(2, at = 0, labels = "Petal.Width")
title("iris Petal width")
points(boundary_point, 0, col = "green", pch = 4) # Mark the boundary point
# Add a legend
legend("topleft",
    legend = c("setosa", "virginica"),
    col = c("red", "blue"), pch = 19
)
