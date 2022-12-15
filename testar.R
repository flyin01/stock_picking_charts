
tickers = ("UCG_IT")
unique(tickers)

message(paste0("For i: ", i, ". Something went wrong. Skipped!"))

# Logger
robustLog <- function(x) {
  tryCatch(tq_get("UCG-IT",
                  get = "stock.prices", 
                  from = today - 4*365, 
                  to = today),
           warning = function(w) {
             print(paste0("The iterator: ", i, " caused a warning. ", w, " Skipping!"))
           },
           error = function(e) {
             print(paste0("The iterator: ", i, " caused and error. Skipping!"))
           },
           finally = {
             next
           }
           )
}

for(i in unique(tickers)) {
  #print(paste("robust log of", i, "=", robustLog(i)))
  robustLog(i)
}


tryCatch(
  expr = {df2 <- tq_get("UCG-IT",
              get = "stock.prices", 
              from = today - 4*365, 
              to = today)
  },
  finally = {
    next
  }
)


### TEST

# ifelse
for(n in 1:10) {
  ifelse(n%%2==1, print(n), next)
}


# try 1
for(n in 1:10) {
  try(cat("\n Hej + ", ...), silent=TRUE) # silent error
}

# try 2
for(n in 1:10) {
  
  df2 <- try(tq_get("UCG-IT",
                    get = "stock.prices", 
                    from = today - 4*365, 
                    to = today), silent=TRUE)
  if(!is(df2, 'try-error')) next
}

# tryCatch 1
for(n in 1:10) {
  
  tryCatch(
    
    # Specify expression
    expr = {
      cat("\nHej + ", n)
    }
    )
}

# tryCatch 2
for(n in 1:10) {
  
  tryCatch(
    
    # Specify expression
    expr = {
      cat("\nHej + ", n)
    },
    # Specifying error message
      error =function(e){
        #cat("There is an error", e)
      },
    finally = {
      next
    }
    
  )
}



# DEFINE FUNCTION 1

loop_over_all_symbols <- function(x) {
  
  # segment the data
  df <- index_info %>%
    filter(symbol == i) %>%
    select(symbol) %>%
    head(1) %>% 
    tq_get(get = "stock.prices",
           from = today - 3*365,
           to = today)
  
  ## calculate moving averages
  
  # select symbol
  symbol_col <- df %>%
    select(symbol)
  
  # select date
  date_col <- df %>%
    select(date)
  
  # select close
  close <- df %>%
    select(close)
  
  # calculate rolling 50
  roll_50 <- df %>%
    select(close) %>%
    rollmean(50,
             fill = NA,
             align = "right")
  
  # calculate rolling 200
  roll_200 <- df %>%
    select(close) %>%
    rollmean(200,
             fill = NA,
             align = "right")
  
  # Compare the ma 50 and ma 200
  df_comp <- data.frame("symbol"   = symbol_col,
                        "date"     = date_col,
                        "close"    = close,
                        "ma_50"    = roll_50,
                        "ma_200"   = roll_200)
  
  names(df_comp) <- c("symbol", "date", "close", "ma_50", "ma_200") 
  
  # check logic if ma_50 >= ma_200
  df_comp_summary <- df_comp %>% 
    filter(ma_50 >= ma_200,
           date == max(date))%>%
    select(symbol,date, close, ma_50, ma_200) # select the date and the max 
  
  # bind results
  df_comp_results <- rbind(df_comp_results, df_comp)   # all rows per symbol  
  df_results      <- rbind(df_results,df_comp_summary) # one row per symbol
  
}


# TARGET LOOP TEST 1

# loop over each stock in the index_info -- WORKS but returns nothing
for (i in unique(index_info$symbol)) {
  
  skip_to_next <- FALSE
  
  tryCatch(
  
  loop_over_all_symbols(index_info)
  
  , error = function(e) {skip_to_next <<- TRUE})
  
  if(skip_to_next) { next }
  
}


# DEFINE FUNCTION 2

collect_symbol_data <- function(x) {
  
  # Try to collect data for a symbol
  index_info %>%
    filter(symbol == i) %>%
    select(symbol) %>%
    head(1) %>% 
    tq_get(get = "stock.prices",
           from = today - 3*365,
           to = today)
}

# TARGET LOOP TEST 2 -- WORKS for the DOW 30 stocks with no errors. BUT breaks with an error!

# loop over each stock in the index_info
for (i in unique(index_info$symbol)) {
  
  # segment the data
  
  ## this step fails sometimes, skip symbol if there is an error fetching data
  skip_to_next <- FALSE
  
  tryCatch(
  df <- collect_symbol_data(index_info), error = function(e) {skip_to_next <<- TRUE})
  if(skip_to_next) { next }
  
  ## calculate moving averages
  
  # select symbol
  symbol_col <- df %>%
    select(symbol)
  
  # select date
  date_col <- df %>%
    select(date)
  
  # select close
  close <- df %>%
    select(close)
  
  # calculate rolling 50
  roll_50 <- df %>%
    select(close) %>%
    rollmean(50,
             fill = NA,
             align = "right")
  
  # calculate rolling 200
  roll_200 <- df %>%
    select(close) %>%
    rollmean(200,
             fill = NA,
             align = "right")
  
  # Compare the ma 50 and ma 200
  df_comp <- data.frame("symbol"   = symbol_col,
                        "date"     = date_col,
                        "close"    = close,
                        "ma_50"    = roll_50,
                        "ma_200"   = roll_200)
  
  names(df_comp) <- c("symbol", "date", "close", "ma_50", "ma_200") 
  
  # check logic if ma_50 >= ma_200
  df_comp_summary <- df_comp %>% 
    filter(ma_50 >= ma_200,
           date == max(date))%>%
    select(symbol,date, close, ma_50, ma_200) # select the date and the max 
  
  # bind results
  df_comp_results <- rbind(df_comp_results, df_comp)   # all rows per symbol  
  df_results      <- rbind(df_results,df_comp_summary) # one row per symbol
}

# TARGET LOOP TEST 3

# loop over each stock in the index_info
for (i in unique(index_info$symbol)) {
  
  # segment the data
  
  ## Data collection step fails sometimes, skip symbol if it generates warning/error while fetching data
  skip_to_next <- FALSE
  
  tryCatch(
    # segment the data
    {df <- index_info %>%
      filter(symbol == i) %>%
      select(symbol) %>%
      head(1) %>% 
      tq_get(get = "stock.prices",
             from = today - 3*365,
             to = today)
    }, warning = function(w) {
      skip_to_next <<- TRUE
      
    }, error = function(e) {
      skip_to_next <<- TRUE
      })
  
  if(skip_to_next) { next }
  
  ## calculate moving averages
  
  # select symbol
  symbol_col <- df %>%
    select(symbol)
  
  # select date
  date_col <- df %>%
    select(date)
  
  # select close
  close <- df %>%
    select(close)
  
  # calculate rolling 50
  roll_50 <- df %>%
    select(close) %>%
    rollmean(50,
             fill = NA,
             align = "right")
  
  # calculate rolling 200
  roll_200 <- df %>%
    select(close) %>%
    rollmean(200,
             fill = NA,
             align = "right")
  
  # Compare the ma 50 and ma 200
  df_comp <- data.frame("symbol"   = symbol_col,
                        "date"     = date_col,
                        "close"    = close,
                        "ma_50"    = roll_50,
                        "ma_200"   = roll_200)
  
  names(df_comp) <- c("symbol", "date", "close", "ma_50", "ma_200") 
  
  # check logic if ma_50 >= ma_200
  df_comp_summary <- df_comp %>% 
    filter(ma_50 >= ma_200,
           date == max(date))%>%
    select(symbol,date, close, ma_50, ma_200) # select the date and the max 
  
  # bind results
  df_comp_results <- rbind(df_comp_results, df_comp)   # all rows per symbol  
  df_results      <- rbind(df_results,df_comp_summary) # one row per symbol
}



### END OF TEST




# create two empty df for the results
df_comp_results <- data.frame("symbol" = as.character(),
                              "date"   = as.Date(x = integer(0), origin = "1970-01-01"),
                              "close"  = as.numeric(),
                              "ma_50"  = as.numeric(),
                              "ma_200" = as.numeric())

df_results <- data.frame("symbol" = as.character(),
                         "date"   = as.Date(x = integer(0), origin = "1970-01-01"),
                         "close"  = as.numeric(),
                         "ma_50"  = as.numeric(),
                         "ma_200" = as.numeric())


# TARGET LOOP CLEAN

# loop over each stock in the index_info
for (i in unique(index_info$symbol)) {
  # segment the data
  df <- index_info %>%
    filter(symbol == i) %>%
    select(symbol) %>%
    head(1) %>% 
    tq_get(get = "stock.prices",
           from = today - 3*365,
           to = today)
  
  ## calculate moving averages
  
  # select symbol
  symbol_col <- df %>%
    select(symbol)
  
  # select date
  date_col <- df %>%
    select(date)
  
  # select close
  close <- df %>%
    select(close)
  
  # calculate rolling 50
  roll_50 <- df %>%
    select(close) %>%
    rollmean(50,
             fill = NA,
             align = "right")
  
  # calculate rolling 200
  roll_200 <- df %>%
    select(close) %>%
    rollmean(200,
             fill = NA,
             align = "right")
  
  # Compare the ma 50 and ma 200
  df_comp <- data.frame("symbol"   = symbol_col,
                        "date"     = date_col,
                        "close"    = close,
                        "ma_50"    = roll_50,
                        "ma_200"   = roll_200)
  
  names(df_comp) <- c("symbol", "date", "close", "ma_50", "ma_200") 
  
  # check logic if ma_50 >= ma_200
  df_comp_summary <- df_comp %>% 
    filter(ma_50 >= ma_200,
           date == max(date))%>%
    select(symbol,date, close, ma_50, ma_200) # select the date and the max 
  
  # bind results
  df_comp_results <- rbind(df_comp_results, df_comp)   # all rows per symbol  
  df_results      <- rbind(df_results,df_comp_summary) # one row per symbol
}
