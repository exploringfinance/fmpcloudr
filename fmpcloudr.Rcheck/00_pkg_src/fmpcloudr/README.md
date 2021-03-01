
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fmpcloudr

<!-- badges: start -->

![Dev Version](https://img.shields.io/badge/github-0.1.5-blue.svg)
![CRAN
Version](https://www.r-pkg.org/badges/version/fmpcloudr?color=green)
![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/fmpcloudr)
<!-- badges: end -->

R package for accessing the [FMP Cloud](https://fmpcloud.io/) and
[Financial Modeling Prep](https://financialmodelingprep.com/) API.
`fmpcloudr` can be used interchangeably with either API key. FMP
Provides access to a wide range of financial data such as historical
prices for stocks, indexes, cryptos, currencies, and commodities. FMP
also provides data for 13F, Balance Sheet, Income Statements, Discounted
Cash Flow, and much more. Create an account to get an API token and
explore the `fmpcloudr` functions to see the capabilities.

See the
[article](https://exploringfinance.github.io/posts/2020-11-01-analyzing-sp500-with-fmp/)
on analyzing the S&P 500 to see a detailed analysis and working example
using FMP data.

## Installation

You can install `fmpcloudr` using:

``` r
# Available on CRAN
install.packages('fmpcloudr')

# Pull the GitHub development version - currently same as CRAN
# install.packages("devtools")
devtools::install_github("exploringfinance/fmpcloudr")
```

# Obtain an API Token

Register an API token on [FMP Cloud](https://fmpcloud.io/) or [Financial
Modeling Prep](https://financialmodelingprep.com/). To use the package
without an API key, see the bottom section ‘Examples using a demo API’
for API calls on Apple.

Please note: for most functions, each symbol entered will generate a
single API call. `fmpc_set_token` sets time between API calls so that no
more than 10 calls will be made per second. However, raw number of calls
can be breached depending on the subscription. For example, the free API
tier allows for 250 API calls. This will be exceeded if 251 symbols are
run through `fmpc_price_history`.

## Pricing Functions

Get current and historical prices using a range of functions. Prices can
be pulled for stocks, ETFs, Mutual Funds, Indexes, Crypto, Currencies,
and Commodities. See the Market Information section below to explore all
available symbols on FMP.

``` r
library(fmpcloudr)
# Set API Token
# The default setting will buffer requests so that no more than 10 requests are made every second
fmpc_set_token('VALID_FMP_API_TOKEN')

# Change the options to suppress the bulk request warning or to decrease time between 
# API calls if the registered token allows for more than 10 API calls per second.
# fmpc_set_token('VALID_FMP_API_TOKEN', timeBtwnReq = 0, noBulkWarn = TRUE)

# Make requests for stock tickers, Mutual Funds, Indexes, Currencies, and Commodities
symbols = c('AAPL','SPY','SWTSX')
indexes = c('^SP500TR','JPYUSD','BTCUSD','GCUSD')


# Get historical prices
fmpc_price_history(c(symbols,indexes))


# Get historical data frame of price, div, and splits
# NOTE: This will generate 3 API calls per symbol
fmpc_price_history_spldiv(c(symbols,indexes),startDate = '2020-01-01')

# Get Intraday prices
fmpc_price_intraday(c(symbols,indexes), freq = '5min')
fmpc_price_intraday(c(symbols,indexes), freq = '1hour')

# Get all prices for a single day
fmpc_price_batch_eod('2020-06-24')

# Get most recent price
fmpc_price_current(c(symbols,indexes))

# Get most recent price for all available indexes and ETFs
fmpc_price_full_market('index')
fmpc_price_full_market('etf')


# Get two month price history for the entire S&P 500
# Note: this will take about two minutes and will generate 500 unique API Calls
fmpc_set_token('VALID_FMP_API_TOKEN', noBulkWarn = TRUE)
SP500 = fmpc_symbols_index()
SPPrice = fmpc_price_history(SP500$symbol, startDate = Sys.Date() - 60)
```

## Market Information

Use these functions to find available tickers, search for companies,
check market hours, and screen stocks.

``` r
# Set API Token
fmpc_set_token('VALID_FMP_API_TOKEN')

# Pull available symbols for one or more markets
fmpc_symbols_by_market() # default will pull all markets making 11 API calls
fmpc_symbols_by_market(market = c('index','commodity'))

# Pull all available symbols that also have a profile
fmpc_symbols_available()

# Search for securities using text
fmpc_symbol_search('tech', 100)
fmpc_symbol_search('utilit', 100)
fmpc_symbol_search('Buffer ETF', 100)

# Get a list of all symbols in the Nasdaq
fmpc_symbols_index(index= 'nasdaq')

# Find all securities that have been added and removed from the S&P 500
fmpc_symbols_index('historical')

# Get current day market hours and a list of trading holidays
fmpc_market_hours()

# Screen for securities on a range of metrics
fmpc_security_screener(mrktCapAbove = 1e9, dividendBelow = 1, volumeAbove = 1e6)
fmpc_security_screener(dividendBelow = 1, betaAbove = 1)

# Search on CUSIP
fmpc_cusip_search('000360206')

```

## Other security metrics

Use these functions to get split history, dividend history, security
profiles, biggest gainers/losers, earnings, analyst
grades/recommendations, press releases, and earnings call transcripts.

``` r
# Set API Token
fmpc_set_token('VALID_FMP_API_TOKEN')
symbols = c('AAPL','SPY','SWTSX')

# Get historical dividend
fmpc_security_dividends(symbols, startDate = '2020-01-01')

# Get historical splits
fmpc_security_splits(symbols, startDate = '2020-01-01')

# Get sector returns for 30 trading days
fmpc_security_sector(30)

# Security Profile
fmpc_security_profile(symbols)

# Get current days biggest gainers/losers and most active
fmpc_security_gla('gainers')
fmpc_security_gla('losers')
fmpc_security_gla('actives')

# Pull news for a set of symbols
fmpc_security_news(symbols)

# Get analyst ratings
fmpc_security_ratings(symbols)

## Pull Analyst Outlooks

# Grades
fmpc_analyst_outlook(symbols, 'grade', limit = 120)

# Quarterly Earnings
fmpc_analyst_outlook(symbols, 'estimateQtr')

# Annual Earnings
fmpc_analyst_outlook(symbols, 'estimateAnnl')
  
# Recommendations  
fmpc_analyst_outlook(symbols, 'recommend')

# Press releases
fmpc_analyst_outlook(symbols, 'press')

# Earnings call transcript
fmpc_earning_call_transcript(symbols, quarter = 1, year = 2019)
```

## Technical Indicators

Pull a range of technical indicators over different frequencies and
periods.

``` r
  # Set API Token
  fmpc_set_token('VALID_FMP_API_TOKEN')
  symbols = c('AAPL', 'SPY')

  # Simple moving average
  sma = fmpc_security_tech_indic(symbols, indicator = 'SMA', freq = 'daily', period = 10)
 
  # Exponential moving average
  ema = fmpc_security_tech_indic(symbols, indicator = 'EMA',  freq = '1min', period = 10)
  
  # Weighted Moving Average
  wma = fmpc_security_tech_indic(symbols, indicator = 'WMA', freq = '5min', period = 10)
                             
  # Double Exponential moving average
  dema = fmpc_security_tech_indic(symbols, indicator = 'dema', freq = '30min', period = 10)

  # Triple Exponential moving average
  tema = fmpc_security_tech_indic(symbols, indicator = 'Tema', freq = '1hour', period = 10)
  
  # Williams momentum
  will = fmpc_security_tech_indic(symbols, indicator = 'Williams', freq = '4hour', period = 10)
  
  # Average Directional Moving Index
  adx = fmpc_security_tech_indic(symbols, indicator = 'adx', freq = 'daily', period = 10)
  
  # Standard Deviation
  sd = fmpc_security_tech_indic(symbols, indicator = 'StandardDeviation', freq = '1hour', period = 10)
 
  # Relative Strength Indicator
  rsi = fmpc_security_tech_indic(symbols, indicator = 'rsi', freq = 'daily', period = 14)

```

## Get Financial Data

Pull historic data for Balance Sheet, Income Statement, and Cash Flow
Statement. Data can be pulled annually or quarterly with a growth
indicator set.

``` r
  # Set API Token
  fmpc_set_token('VALID_FMP_API_TOKEN')
  
  symbols = c('AAPL','MSFT','BAC','TSLA')

  # Balance Sheet
  Bal = fmpc_financial_bs_is_cf(symbols,statement = 'balance')
  BalG = fmpc_financial_bs_is_cf(symbols,statement = 'balance', growth = TRUE)
  
  # Income statements
  IS = fmpc_financial_bs_is_cf(symbols,statement = 'income')
  ISa = fmpc_financial_bs_is_cf(symbols,statement = 'income', quarterly = FALSE)
  
  # Cash Flow Statements
  cf = fmpc_financial_bs_is_cf(symbols,statement = 'cashflow')
  cfsec = fmpc_financial_bs_is_cf('AAPL',statement = 'cashflow', SECReported  = TRUE)
  
  
  ### Discounted Cash Flow Value
  fmpc_financial_dcfv(symbols, period = 'current')
  fmpc_financial_dcfv(symbols, period = 'quarterly')
  
  
  ### Other financial metrics
  # Financial Ratios
  ratio = fmpc_financial_metrics(symbols, metric = 'ratios', quarterly = TRUE, trailingTwelve = TRUE, limit = 100)
  
  # Key Metrics
  keym = fmpc_financial_metrics(symbols, metric = 'key', quarterly = FALSE, trailingTwelve = TRUE, limit = 100)
  
  # Enterprise Value
  ev = fmpc_financial_metrics(symbols, metric = 'ev', quarterly = TRUE, trailingTwelve = FALSE, limit = 100)
  
  # Growth of revenue, profit, operating income, EPS, EBIT, etc.
  growth = fmpc_financial_metrics(symbols, metric = 'growth', quarterly = FALSE, trailingTwelve = FALSE, limit = 120)
```

## Get Holdings data

Holdings data can include institutions holding the security (13F) or
what a security is actually holding, for example what is SPY holding?

``` r
  # Set API Token
  fmpc_set_token('VALID_FMP_API_TOKEN')
  
  ## Get 13F data
  # Search for available ciks
  fmpc_13f_cik_list()
  
  # Narrow search for particular firms
  GS = fmpc_13f_cik_search('Goldman S')
  
  # Pull 13F data for dates and ciks
  fmpc_13f_data(cik = GS$cik, date = c('2020-03-31','2019-12-31'))

  # Find out which mutual funds are holding speific symbols
  fmpc_held_by_mfs(c('AAPL','MSFT','GOOGL'))
  
  # Understand the holdings within an ETF - by individual security, sector weighting, or country weighting
  fmpc_holdings_etf(c('SPY','EFA'), 'symbol')
  fmpc_holdings_etf(c('SPY','EFA'), 'sector')
  fmpc_holdings_etf(c('SPY','EFA'), 'sector')
  
```

## Get calendar events

Pull data for specific calendar events. Economic data releases can be
searched with historical data pulled.

``` r
  # Set API Token
  fmpc_set_token('VALID_FMP_API_TOKEN')
  
  # Get a list of economic events that can be searched
  Events = fmpc_economic_events()
  
  ## Search for specific economic event results
  # US ADP Employment Change
  fmpc_economic_results(event = 'adpEmploymentChange', country = 'US')
  
  # Italy three month interbank rate
  fmpc_economic_results(event = Events[100,1], country = Events[100,2])

  # Consumer credit - RS
  fmpc_economic_results(event = Events[1000,1], country = Events[1000,2])

  # Find out upcoming or past IPOs
  fmpc_calendar_events('ipo', startDate = Sys.Date()-100)

  # Find out earnings results vs estimates
  fmpc_calendar_events('earning')
  
  
```

## Examples using demo API

The demo API token allows for pulls on Apple.

``` r
library(fmpcloudr)
# Set API Token
fmpc_set_token()

# Get historical prices
fmpc_price_history('AAPL')

# Get historical dividend
fmpc_security_dividends('AAPL', startDate = '2020-01-01')

# Get historical splits
fmpc_security_splits('AAPL', startDate = '2020-01-01')

# Get historical data frame of price, div, and splits
# NOTE: This will generate 3 API calls per symbol
fmpc_price_history_spldiv('AAPL',startDate = '2020-01-01')

# Get Intraday prices
fmpc_price_intraday('AAPL', freq = '5min')

# Modify the frequency and start date
fmpc_price_intraday('AAPL', freq = '1hour', startDate = Sys.Date()-7)

# Get most recent price
fmpc_price_current('AAPL')

# Get technical indicators like ema, sma, rsi, williams, etc
fmpc_security_tech_indic('AAPL', indicator = 'ema')
fmpc_security_tech_indic('AAPL', indicator = 'rsi', freq = '15min', period = 25)

# Download balance sheet, cash flow, and income statement
fmpc_financial_bs_is_cf('AAPL',statement = 'balance')
fmpc_financial_bs_is_cf('AAPL',statement = 'income')
fmpc_financial_bs_is_cf('AAPL',statement = 'cashflow', quarterly = FALSE)
```
