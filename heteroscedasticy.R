library(ggplot2)

# Set seed for reproducibility
set.seed(1234)

# Generate data
x <- rnorm(20)
df <- data.frame(x = x, y = x + rnorm(20))

# Fit model
mod <- lm(y ~ x, data = df)

# Generate predictions and confidence intervals
newx <- seq(min(df$x), max(df$x), length.out = 100)
preds <- predict(mod, newdata = data.frame(x = newx), interval = "confidence")
preds_df <- data.frame(x = newx, lwr = preds[, "lwr"], upr = preds[, "upr"])

# Plot using ggplot2
p <- ggplot(df, aes(x = x, y = y)) +
    geom_point() + # Scatter plot
    geom_ribbon(data = preds_df, aes(y = NULL, ymin = lwr, ymax = upr), fill = "grey80", alpha = 0.5) +
    geom_line(data = preds_df, aes(y = (lwr + upr) / 2), color = "blue") + # Regression line
    geom_line(data = preds_df, aes(y = lwr), linetype = "dashed", color = "red") +
    geom_line(data = preds_df, aes(y = upr), linetype = "dashed", color = "red") +
    labs(
        title = "Regression Analysis with Confidence Interval",
        x = "Predictor X", y = "Response Y"
    ) +
    theme_minimal()

print(p)
