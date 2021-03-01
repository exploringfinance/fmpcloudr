pkgname <- "fmpcloudr"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "fmpcloudr-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('fmpcloudr')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("fmpc_13f_cik_list")
### * fmpc_13f_cik_list

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_13f_cik_list
### Title: List of all 13F ciks
### Aliases: fmpc_13f_cik_list

### ** Examples

## Not run: 
##D # Function can work without a valid API token
##D fmpc_set_token() # defaults to 'demo'
##D fmpc_13f_cik_list()
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_13f_cik_list", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_13f_cik_name")
### * fmpc_13f_cik_name

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_13f_cik_name
### Title: Find name of company by cik
### Aliases: fmpc_13f_cik_name

### ** Examples

## Not run: 
##D # Function can work without a valid API token
##D fmpc_set_token() # defaults to 'demo'
##D fmpc_13f_cik_name(cik = '0001067983')
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_13f_cik_name", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_13f_cik_search")
### * fmpc_13f_cik_search

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_13f_cik_search
### Title: Search for 13F ciks
### Aliases: fmpc_13f_cik_search

### ** Examples



## Not run: 
##D 
##D # Function can work without a valid API token
##D fmpc_set_token() # defaults to 'demo'
##D fmpc_13f_cik_search('Berkshire')
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_13f_cik_search('Morgan')
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_13f_cik_search", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_13f_data")
### * fmpc_13f_data

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_13f_data
### Title: 13F data for a set of ciks and dates
### Aliases: fmpc_13f_data

### ** Examples




## Not run: 
##D 
##D # Berkshire can be run using the demo
##D fmpc_set_token()
##D fmpc_13f_data('0001067983', '2020-03-31')
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D goldmanCik = fmpc_13f_cik_search('golman')
##D fmpc_13f_data(cik = goldmanCik$cik, date = c('2020-03-31','2020-06-30'))
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_13f_data", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_analyst_outlook")
### * fmpc_analyst_outlook

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_analyst_outlook
### Title: Pull analyst outlook for one or more securities
### Aliases: fmpc_analyst_outlook

### ** Examples


## Not run: 
##D 
##D # Demo can pull AAPL
##D fmpc_set_token()
##D fmpc_analyst_outlook('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_analyst_outlook(c('AAPL','MSFT','SPY'))
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_analyst_outlook", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_calendar_events")
### * fmpc_calendar_events

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_calendar_events
### Title: Dates related to Economic data, IPOs, dividends, earnings, and
###   splits
### Aliases: fmpc_calendar_events

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_calendar_events('stock_split')
##D fmpc_calendar_events('economic')
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_calendar_events", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_cots_data")
### * fmpc_cots_data

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_cots_data
### Title: Get COTS data
### Aliases: fmpc_cots_data

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_cots_data()
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_cots_data", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_cots_symbols")
### * fmpc_cots_symbols

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_cots_symbols
### Title: Get list of COTS symbols
### Aliases: fmpc_cots_symbols

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_cots_symbols()
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_cots_symbols", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_cusip_search")
### * fmpc_cusip_search

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_cusip_search
### Title: Use a cusip to search a company and ticker
### Aliases: fmpc_cusip_search

### ** Examples


## Not run: 
##D # Demo offers AAON as an example
##D fmpc_set_token()
##D fmpc_cusip_search('000360206')
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_cusip_search", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_earning_call_transcript")
### * fmpc_earning_call_transcript

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_earning_call_transcript
### Title: Full transcript of earnings call
### Aliases: fmpc_earning_call_transcript

### ** Examples


## Not run: 
##D 
##D # Demo can pull AAPL
##D fmpc_set_token()
##D fmpc_earning_call_transcript('AAPL',quarter = 1, year = 2019)
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_earning_call_transcript(c('AAPL','MSFT','SPY'))
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_earning_call_transcript", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_economic_events")
### * fmpc_economic_events

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_economic_events
### Title: List economic events that can be searched
### Aliases: fmpc_economic_events

### ** Examples

## Not run: 
##D # Function can work without a valid API token
##D  fmpc_set_token('FMPAPIKEY')
##D fmpc_economic_events()
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_economic_events", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_economic_results")
### * fmpc_economic_results

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_economic_results
### Title: Economic results
### Aliases: fmpc_economic_results

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D Events = fmpc_economic_events()
##D fmpc_economic_results()
##D 
##D # Italy three month interbank rate
##D fmpc_economic_results(event = Events[100,1], country = Events[100,2])
##D 
##D # Consumer credit - RS
##D fmpc_economic_results(event = Events[1000,1], country = Events[1000,2])
##D 
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_economic_results", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_financial_bs_is_cf")
### * fmpc_financial_bs_is_cf

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_financial_bs_is_cf
### Title: Get financial data for one or more tickers
### Aliases: fmpc_financial_bs_is_cf

### ** Examples



## Not run: 
##D 
##D # Setting API key to 'demo' allows for AAPL only
##D fmpc_set_token()
##D fmpc_financial_bs_is_cf()
##D fmpc_financial_bs_is_cf('AAPL',statement = 'balance', quarterly = FALSE,
##D                      growth = FALSE, SECReported = TRUE, limit = 10)
##D 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_financial_bs_is_cf(c('AAPL','MSFT','TSLA'))
##D 
##D  symbols = c('AAPL','MSFT','BAC')
##D  Bal = fmpc_financial_bs_is_cf(symbols,statement = 'balance')
##D  BalG = fmpc_financial_bs_is_cf(symbols,statement = 'balance', growth = FALSE)
##D  IS = fmpc_financial_bs_is_cf(symbols,statement = 'income')
##D  ISa = fmpc_financial_bs_is_cf(symbols,statement = 'income', quarterly = FALSE)
##D  cf = fmpc_financial_bs_is_cf(symbols,statement = 'cashflow')
##D  cfsec = fmpc_financial_bs_is_cf(symbols,statement = 'cashflow', SECReported  = TRUE)
##D 
##D # International tickers work
##D fmpc_financial_bs_is_cf('RY.TO',statement = 'balance', quarterly = TRUE,
##D                      growth = TRUE, SECReported = FALSE, limit = 10)
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_financial_bs_is_cf", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_financial_dcfv")
### * fmpc_financial_dcfv

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_financial_dcfv
### Title: Discounted Cash Flow Value
### Aliases: fmpc_financial_dcfv

### ** Examples



## Not run: 
##D 
##D # Demo can pull AAPL
##D fmpc_set_token()
##D fmpc_financial_dcfv('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_financial_dcfv(c('AAPL','MSFT','SPY'), period = 'quarterly')
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_financial_dcfv", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_financial_metrics")
### * fmpc_financial_metrics

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_financial_metrics
### Title: Get financial metrics for one or more tickers
### Aliases: fmpc_financial_metrics

### ** Examples



## Not run: 
##D 
##D  # Setting API key to 'demo' allows for AAPL only
##D fmpc_set_token()
##D fmpc_financial_metrics()
##D fmpc_financial_metrics('AAPL',metric = 'ratios', quarterly = FALSE,
##D                      trailingTwelve = FALSE, limit = 10)
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_financial_metrics(c('AAPL','MSFT','TSLA'))
##D 
##D # International tickers work
##D fmpc_financial_metrics('RY.TO',metric = 'key', quarterly = TRUE,
##D                      trailingTwelve = TRUE, limit = 10)
##D 
##D 
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_financial_metrics", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_financial_zip")
### * fmpc_financial_zip

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_financial_zip
### Title: Get a list of Financial ZIP file locations
### Aliases: fmpc_financial_zip

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_financial_zip()
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_financial_zip", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_get_url")
### * fmpc_get_url

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_get_url
### Title: GET Request for specific URL
### Aliases: fmpc_get_url

### ** Examples

## Not run: 
##D # Set the FMP Token. The DEMO token has VERY limited access.
##D fmpc_set_token('demo')
##D 
##D # Pull price history for Apple
##D AppleHist = fmpc_get_url('historical-price-full/AAPL?serietype=line&')
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_get_url", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_held_by_mfs")
### * fmpc_held_by_mfs

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_held_by_mfs
### Title: List of mutual funds that hold a specified symbol
### Aliases: fmpc_held_by_mfs

### ** Examples




## Not run: 
##D 
##D # Demo can pull AAPL
##D fmpc_set_token()
##D fmpc_held_by_mfs('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_held_by_mfs(c('AAPL','MSFT','GOOGL'))
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_held_by_mfs", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_holdings_etf")
### * fmpc_holdings_etf

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_holdings_etf
### Title: Pull ETF holdings data
### Aliases: fmpc_holdings_etf

### ** Examples


## Not run: 
##D 
##D  # For multiple symbols, set a valid API Token
##D  fmpc_set_token('FMPAPIKEY')
##D  fmpc_holdings_etf(c('VOO','SPY'), holding = 'symbol')
##D  fmpc_holdings_etf(c('VOO','SPY'), holding = 'country')
##D  fmpc_holdings_etf(c('VOO','SPY'), holding = 'sector')
##D 
##D  
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_holdings_etf", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_market_hours")
### * fmpc_market_hours

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_market_hours
### Title: Current day market hours and holidays
### Aliases: fmpc_market_hours

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_market_hours()
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_market_hours", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_price_batch_eod")
### * fmpc_price_batch_eod

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_price_batch_eod
### Title: Pull all EOD pricing data for a specific date
### Aliases: fmpc_price_batch_eod

### ** Examples

## Not run: 
##D 
##D fmpc_set_token('FMPAPIKEY')
##D allSymbs = fmpc_price_batch_eod('2020-06-24')
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_price_batch_eod", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_price_current")
### * fmpc_price_current

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_price_current
### Title: Current price
### Aliases: fmpc_price_current

### ** Examples



## Not run: 
##D 
##D # Setting API key to 'demo' allows for AAPL only
##D fmpc_set_token()
##D fmpc_price_current('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_price_current(c('AAPL', 'MSFT', 'TSLA', 'SPY', 'BTCUSD', 'JPYUSD', '^SP500TR'))
##D 
## End(Not run)





base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_price_current", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_price_forex")
### * fmpc_price_forex

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_price_forex
### Title: Get all foreign exchange quotes
### Aliases: fmpc_price_forex

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_price_forex()
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_price_forex", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_price_full_market")
### * fmpc_price_full_market

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_price_full_market
### Title: Current Price for an Entire Market
### Aliases: fmpc_price_full_market

### ** Examples

## Not run: 
##D 
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_price_full_market('index')
##D fmpc_price_full_market('forex')
##D fmpc_price_full_market() # Default is to 'etf'
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_price_full_market", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_price_history")
### * fmpc_price_history

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_price_history
### Title: Historical End of Day pricing data for one or more symbols
### Aliases: fmpc_price_history

### ** Examples



## Not run: 
##D 
##D # Default sets token to 'demo' which allows for AAPL only
##D fmpc_set_token()
##D fmpc_price_history('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D # Crypto, equity, currency, and index can all be entered in the same request
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_price_history(c('AAPL','MSFT','SPY','^SP500TR','JPYUSD','BTCUSD'))
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_price_history", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_price_history_spldiv")
### * fmpc_price_history_spldiv

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_price_history_spldiv
### Title: Historical EOD pricing, split, and dividend data for one or more
###   symbols
### Aliases: fmpc_price_history_spldiv

### ** Examples




## Not run: 
##D # Setting API key to 'demo' allows for AAPL only
##D fmpc_set_token()
##D fmpc_price_history_spldiv('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D # Index, currency, and crypto will return data even without splits/divs
##D fmpc_price_history_spldiv(c('AAPL','MSFT','SPY','^SP500TR','JPYUSD','BTCUSD'))
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_price_history_spldiv", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_price_intraday")
### * fmpc_price_intraday

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_price_intraday
### Title: Historical End of Day pricing data for one or more symbols
### Aliases: fmpc_price_intraday

### ** Examples



## Not run: 
##D 
##D # Setting API key to 'demo' allows for AAPL only
##D fmpc_set_token()
##D # Freq of1hour will return about 2 months of data
##D fmpc_price_intraday('AAPL', freq = '5min')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_price_intraday(symbols = c('AAPL','MSFT','SPY','^SP500TR','JPYUSD','BTCUSD'),
##D                    startDate = '2020-01-01', freq = '1hour')
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_price_intraday", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_rss_sec")
### * fmpc_rss_sec

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_rss_sec
### Title: RSS feed of latest submissions to SEC
### Aliases: fmpc_rss_sec

### ** Examples


## Not run: 
##D # Demo offers AAON as an example
##D fmpc_set_token()
##D fmpc_rss_sec()
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_rss_sec", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_delisted")
### * fmpc_security_delisted

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_delisted
### Title: Delisted companies
### Aliases: fmpc_security_delisted

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_delisted()
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_delisted", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_dividends")
### * fmpc_security_dividends

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_dividends
### Title: Historical security dividend data
### Aliases: fmpc_security_dividends

### ** Examples



## Not run: 
##D 
##D # Setting API key to DEMO allows for AAPL only
##D fmpc_set_token()
##D fmpc_security_dividends('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_dividends(c('AAPL','MSFT','SPY'), startDate = '2010-01-01')
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_dividends", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_gla")
### * fmpc_security_gla

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_gla
### Title: Gainers, Losers, and active
### Aliases: fmpc_security_gla

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_gla('gainers')
##D fmpc_security_gla('losers')
##D fmpc_security_gla('actives')
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_gla", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_mrktcap")
### * fmpc_security_mrktcap

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_mrktcap
### Title: Pull market capitalization
### Aliases: fmpc_security_mrktcap

### ** Examples



## Not run: 
##D 
##D # Demo can pull AAPL
##D fmpc_set_token()
##D fmpc_security_mrktcap('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_mrktcap(c('AAPL','MSFT','SPY'))
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_mrktcap", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_news")
### * fmpc_security_news

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_news
### Title: Get current news
### Aliases: fmpc_security_news

### ** Examples


## Not run: 
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_news(c('AAPL','MSFT','SPY'))
##D fmpc_security_news()
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_news", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_profile")
### * fmpc_security_profile

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_profile
### Title: Pull profile for a company
### Aliases: fmpc_security_profile

### ** Examples



## Not run: 
##D 
##D # Demo can pull AAPL
##D fmpc_set_token()
##D fmpc_security_profile('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_profile(c('AAPL','MSFT','SPY'))
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_profile", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_ratings")
### * fmpc_security_ratings

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_ratings
### Title: Pull security rating
### Aliases: fmpc_security_ratings

### ** Examples



## Not run: 
##D 
##D # Demo can pull AAPL
##D fmpc_set_token()
##D fmpc_security_ratings('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_ratings(c('AAPL','MSFT','SPY'))
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_ratings", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_screener")
### * fmpc_security_screener

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_screener
### Title: Stock Screener
### Aliases: fmpc_security_screener

### ** Examples

## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_screener() # Default pulls a list of 100 with no filters
##D # Search for market cap above a billion,
##D # that trades at least a million shares with a dividend under 1
##D fmpc_security_screener(mrktCapAbove = 1e9, dividendBelow = 1, volumeAbove = 1e6)
##D 
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_screener", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_sector")
### * fmpc_security_sector

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_sector
### Title: Pull daily returns for all sectors
### Aliases: fmpc_security_sector

### ** Examples

## Not run: 
##D 
##D fmpc_set_token('FMPAPIKEY')
##D allSymbs = fmpc_security_sector(30)
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_sector", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_splits")
### * fmpc_security_splits

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_splits
### Title: Historical security split data
### Aliases: fmpc_security_splits

### ** Examples



## Not run: 
##D 
##D # Setting API key to DEMO allows for AAPL only
##D fmpc_set_token()
##D fmpc_security_splits('AAPL')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_splits(c('AAPL','TSLA'), startDate = '2020-01-01')
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_splits", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_security_tech_indic")
### * fmpc_security_tech_indic

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_security_tech_indic
### Title: Technical Indicators
### Aliases: fmpc_security_tech_indic

### ** Examples


## Not run: 
##D 
##D # Setting API key to DEMO allows for AAPL only
##D fmpc_set_token()
##D fmpc_security_tech_indic('AAPL')
##D fmpc_security_tech_indic('AAPL', indicator = 'standardDeviation')
##D fmpc_security_tech_indic('AAPL', 'sma')
##D 
##D # For multiple symbols, set a valid API Token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_security_tech_indic(c('AAPL','MSFT','SPY'), indicator = 'RSI', freq = '15min', period = 25)
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_security_tech_indic", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_set_token")
### * fmpc_set_token

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_set_token
### Title: Set FMP Token for all other functions
### Aliases: fmpc_set_token

### ** Examples

## Not run: 
##D # Set the FMP Token. The DEMO token has VERY limited access.
##D fmpc_set_token('demo', timeBtwnReq = 0, noBulkWarn = TRUE)
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_set_token", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_symbol_search")
### * fmpc_symbol_search

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_symbol_search
### Title: Search for symbols or companies
### Aliases: fmpc_symbol_search

### ** Examples


## Not run: 
##D # Function can work without a valid API token
##D fmpc_set_token() # defaults to 'demo'
##D fmpc_symbol_search('apple')
##D fmpc_symbol_search('tech', 100)
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_symbol_search", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_symbols_available")
### * fmpc_symbols_available

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_symbols_available
### Title: Get symbols available through FMP Cloud that have a profile
### Aliases: fmpc_symbols_available

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_symbols_available()
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_symbols_available", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_symbols_by_market")
### * fmpc_symbols_by_market

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_symbols_by_market
### Title: Get available symbols across markets
### Aliases: fmpc_symbols_by_market

### ** Examples


## Not run: 
##D 
##D # A valid token must be set to use this function
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_symbols_by_market(market = c('index','commodity'))
##D fmpc_symbols_by_market() # default will pull all markets
##D 
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_symbols_by_market", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("fmpc_symbols_index")
### * fmpc_symbols_index

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: fmpc_symbols_index
### Title: Current or historical constituents for a specific index
### Aliases: fmpc_symbols_index

### ** Examples


## Not run: 
##D 
##D # Must set a valid API token
##D fmpc_set_token('FMPAPIKEY')
##D fmpc_symbols_index()
##D fmpc_symbols_index('historical','nasdaq')
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("fmpc_symbols_index", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
