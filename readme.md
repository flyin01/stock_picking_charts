### stock picking charts ###

Using `tidyquant` package and tidyverse to plot stock quotes after applying some logic to sort out interesting stock. Using `quantmod` to get `DJI` and `VIX` data for trend analysis.  

#### src ####  
Contains R files:  
`stock_picker.Rmd`  
`stock_picker.nb.html`  
`trading_fil.Rmd`  
`trading_fil.nb.html`  

#### logic ####  
Above the Death-cross, i.e if a stock´s ma50 is above it´s ma200. These are the stocks that are showing significant upward trend and could be possible purchase candidates. The stocks that are selected as candidates varies over time.
