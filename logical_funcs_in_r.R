# Functions in R are a bit different than python

# simple
quad <- function(x) x**2
quad(4)

# add conditional construct
quad <- function(x) {
  if(x>=0) x**2 
  else ("Input should be a non-negative number")
}
quad(4)
quad(-4)

# add condition alt
quad <- function(x) {
  ifelse(x>=0, x**2, "Input should be a non-negative number")
}
quad(4)
quad(-4)

# add 2 condition
quad <- function(x) {
  if(x==0) {
    print("0 is not very exciting!")
    } else if(x<100){
      x**2
    } else {
      print("Select a value below 100")
    }
      
}
quad(4)
quad(101)
quad(0)


