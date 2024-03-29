####################
# Distance metrics #
####################
library(ggplot2)

## Input Data 
# Create table with 2 observations with coordinates in a 2D space
df <- data.frame(X = as.numeric(c(0,9)),
                 Y = as.numeric(c(0,12))
                )

df

# Plot the positions of the 2 observations
ggplot(df, aes(x = X, y = X)) + 
  geom_point() +
  # Assuming a 40x60 field
  lims(x = c(-20,20), y = c(-20, 20))

### Euclidean distance - formula is the same as the Hypothenuse of a triangle 
### formed by the coordinates of the base and height
### This is the fundamental idea of calculating a measure of dissimilarity of two observations


## Alt 1
# Manually calculate the distance
distance <- sqrt( (df[1,1] - df[2,1])^2 + (df[1,2] - df[2,2])^2 )
distance


## Alt 2
# Define a custom distance function that takes as input a df with two numeric columns
calculate_eucledian <- function(df) {
  
  # Col names of a data frame with 2 columns of numeric values
  
  distance <- sqrt( (df[1,1] - df[2,1])^2 + (df[1,2] - df[2,2])^2 )
  
  return(distance)

}

# Apply custom function
result <- calculate_eucledian(df)
cat("The Eucledian distance is:", result)


## Alt 3
# Use R built in function dist()

result <- stats::dist(df, method = "euclidean")
result


# Create data with 3 observations
df2 <- data.frame(X = as.numeric(c(0,9,-2)),
                  Y = as.numeric(c(0,12,19))
                  )
df2

# apply dist() on df2 with 3 observations
result2 <- dist(df2, method = "euclidean")
result2

# Plot the positions of the 3 observations
ggplot(df2, aes(x = X, y = X)) + 
  geom_point() +
  # Assuming a 40x60 field
  lims(x = c(-20,20), y = c(-20, 20))


## scaling

# Create data with 3 observations on different scales
df3 <- data.frame(Height_meters = as.numeric(c(1.85, 1.68, 1.77)),
                  Weight_kg     = as.numeric(c(76, 65, 71))
                  )

# Plot
ggplot(df3, aes(x = Height_meters, y = Weight_kg)) + 
  geom_point()

# distance calculations unslaced data
result3 <- dist(df3, method = "euclidean")
result3


# distance calculations with built in scale(). Subtracts the mean and divides by st_dev (standardization).
df3_scaled <- data.frame(scale(df3))
df3_scaled

# Plot scaled, only changes the scale on the axes
ggplot(df3_scaled, aes(x = Height_meters, y = Weight_kg)) + 
  geom_point() +
  ggtitle("Values on X and Y axis are standardized")

result3_scaled <- dist(df3_scaled, method = "euclidean")
result3_scaled

# scaling is important before applying dist()