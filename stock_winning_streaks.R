# length of consecutive gains in share price for a stock
library(tidyverse)
library(timetk)
library(tidyquant)

stock_name<-"MCD"

mcd_stock_price <- tidyquant::tq_get(stock_name)

dates <- mcd_stock_price %>%
  dplyr::summarise(
    start_date = min(date),
    end_date = max(date)
  )
dates

get_streaks <- mcd_stock_price %>%
  dplyr::select(date, close) %>%
  dplyr::mutate(
    up            = if_else(is.na(diff_vec(close) > 0), FALSE, diff_vec(close) > 0),
    cumul_streak  = cumsum(up) * up,
    detect_change = diff_vec(cumul_streak),
    adjust_streak = ifelse(detect_change < 0, detect_change, NA)
  ) %>%
  tidyr::fill(adjust_streak, .direction = "down") %>%
  dplyr::mutate(
    adjust_streak = ifelse(is.na(adjust_streak), 0, adjust_streak)*up,
    streak        = cumul_streak + adjust_streak
  )

get_streaks %>%
  dplyr::count(streak) %>%
  dplyr::mutate(pct = n/sum(n)) %>%
  ggplot(aes(forcats::as_factor(streak), pct)) +
  geom_col(fill = "#00A5B3") +
  scale_y_continuous(labels = scales::label_percent()) +
  labs(
    title = paste("Chances of Consecutive Increases in Closing Share Price of Stock between",dates$start_date,"-",dates$end_date),
    x = "Consecutive day by day increases in share  price",
    y = "Probability"
  )

# write data to csv
write.csv2(mcd_stock_price, file = "mcd_stock_price.csv")
