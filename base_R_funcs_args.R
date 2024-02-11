### Some lesser known arguments to common base R functions


## str() print out the structure of an object. Especially usfull with nested lists
nested_list <- list(
    x = list(x1 = 1:3, x2 = list(x3 = 4:6, x4 = 7:9)),
    y = list(y1 = list(y2 = list(y3 = mtcars)))
)

str(nested_list)
# The output is quite alot of info and hard to see all the content due to the levels

# Use max.level argument to get high level overview
str(nested_list, max.level = 1)


## print()
chick_tbl <- tibble::as.tibble(ChickWeight[1:21, ])
print(chick_tbl)

# use n to limit the nbr of rows to be printed just in head()
print(chick_tbl, n = 4)


## library() to attach an external package to e.g use the famous cake data
library(lme4)

# Use quitely to stop messages from printing
library(lme4, quietly = TRUE)

# use ls() to see how many object we did attach from the libs?
length(ls("package:lme4"))

# use include.only to be more selective.
detach("package:lme4")
library(lme4, include.only = "cake") # load only the cake dataset, not the other 97 objects
ls("package:lme4")

head(cake)

# [] to give us the rows and columns from data frames that we want
cake[1:3, c("temp","angle")]

# if we select a single column we get it back as a vector
cake[1:3, "temp"]

# drop = FALSE ff we want to keep the one column as a data frame
cake[1:3, "temp", drop = FALSE]
