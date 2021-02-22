#' Get available symbols across markets
#'
#' Pulls all symbols available on FMP Cloud that has historical pricing data.
#' Markets can include equities, mutual funds, commodities, indexes, and more.
#'
#' @section Warning: Running 'all' generates 11 API calls
#'
#' @param market select one or more markets to pull available symbols. options
#'   include: 'all', 'etf', 'commodity', 'euronext', 'nyse',' amex', 'tsx',
#'   'index', 'mutual_fund', 'nasdaq', 'crypto', 'forex'
#'
#'
#' @return a data frame of pricing, split, and dividend history
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # A valid token must be set to use this function
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_symbols_by_market(market = c('index','commodity'))
#' fmpc_symbols_by_market() # default will pull all markets
#'
#' }
fmpc_symbols_by_market = function(market = 'all') {

  # Set to lower
  market = tolower(market)

  # Set available markets to query
  mrktsAvail = c('etf','commodity','euronext','nyse','amex','tsx','index','mutual_fund',
                 'nasdaq','crypto','forex')


  # If All, default to all markets
  if ('all' %in% market) {
    market = mrktsAvail
    notavail = NULL
  } else {
    # Pull out only available markets
    notavail = market[is.na(match(market,mrktsAvail))]
    market = mrktsAvail[match(market, mrktsAvail)]
    market = market[!is.na(market)]
  }

  if (length(notavail)>0) {
    warning(paste0('No results returned for: ',paste0(notavail, collapse = ', '),'. ',
                   'Please limit market to the available options: ',paste0(mrktsAvail, collapse = ', ')),
            call. = FALSE)
  }
  # If no valid request, then stop
  if (length(market)==0) {
    stop(paste0('Please limit market to the available options: ',paste0(c('all',mrktsAvail), collapse = ', ')),
         call. = FALSE)
  }

  # Match off for FMP entry for available markets
  marketMatch = data.frame(user = sort(mrktsAvail),
                           fmp = sort(c('amex','commodities','cryptocurrencies','etfs','euronext','forex-currency-pairs',
                                        'indexes','mutual-funds','nasdaq','nyse','tsk')))

  urlMarket = marketMatch$fmp[marketMatch$user %in% market]

  # Use custom function to collapse requests into data frame
  market_df = data.frame(URL = paste0('symbol/available-',sort(urlMarket),'?'),
                         label = sort(market))
  symbolDF = hlp_bindURLs(market_df$URL, label_df = market_df, label_name = 'market')

  # Returned stacked data
  symbolDF
}



#' Get symbols available through FMP Cloud that have a profile
#'
#' Use a valid API Token to pull all symbols that have a profile on FMP Cloud.
#' Pull the profile using \code{\link{fmpc_security_profile}}. Set API
#' token using \code{\link{fmpc_set_token}}.
#'
#' @return a data frame of symbols with descriptions
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_symbols_available()
#'
#' }
fmpc_symbols_available <- function() {

  # Make GET request
  Result <- fmpc_get_url('stock/list?')
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}

#' Search for symbols or companies
#'
#' Enter search string to pull back matching symbols or companies
#'
#' @param query a search string,for example 'tech'
#' @param limit limit the results to a certain number
#'
#' @return list of symbols and companies that meet the search criteria
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # Function can work without a valid API token
#' fmpc_set_token() # defaults to 'demo'
#' fmpc_symbol_search('apple')
#' fmpc_symbol_search('tech', 100)
#' }
fmpc_symbol_search <- function(query = 'apple inc', limit = 10) {

  # Build URL and Make GET request
  URL = paste0('search?query=',gsub(' ','%20',query),'&limit=',limit,'&')
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)

  dplyr::as_tibble(Result)
}




#' Current or historical constituents for a specific index
#'
#' Shows current or historical companies in the S&P 500, Nasdaq, or Dow Jones
#'
#' @param period 'current' for current list, 'historical' for a list of
#'   companies that have been added and the ones that were replaced
#'
#' @param index indicate the index to pull for: sp500, dowjones, nasdaq
#'
#' @return data frame of constituents
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_symbols_index()
#' fmpc_symbols_index('historical','nasdaq')
#' }
#'
fmpc_symbols_index <- function(period = c('current','historical'),index = c('sp500','nasdaq','dowjones')) {

  # Default to current
  if (missing(period)) period = 'current'
  if (missing(index)) index = 'sp500'
  hlp_select(period, c('current','historical'))

  # Set URL
  pullURL = ifelse(period == 'current', paste0(index,'_constituent?'), paste0('historical/',index,'_constituent?'))

  # Make GET request
  Result <- fmpc_get_url(pullURL)
  Result <- hlp_chkResult(Result)

  dplyr::as_tibble(Result)
}



#' Current day market hours and holidays
#'
#' Pulls back current day market hours and holidays for 2019 going forward
#'
#' @return an object of class list containing two data frames for market hours
#'   and holidays
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_market_hours()
#'
#' }
#'
fmpc_market_hours <- function() {

  # Set variables to NULL for check()
  holiday <- . <- NULL

  # Make GET Request
  Result <- fmpc_get_url('market-hours?')
  Result <- hlp_chkResult(Result)
  if (is.null(Result)) return(NULL)

  # Pull holidays into its own data frame
  holidays = as.data.frame(Result$stockMarketHolidays)
  holidays = as.data.frame(t(holidays)) %>%
    dplyr::mutate(holiday = row.names(.)) %>%
    dplyr::filter(holiday != 'year') %>%
    tidyr::gather(key='num',value='date',-holiday) %>%
    dplyr::as_tibble()

  # Modify result to pull out Holidays
  holidays$num = NULL
  Result$stockMarketHolidays = NULL
  Output = list(marketHours = dplyr::as_tibble(Result), holidays = holidays)

  # Return Output as an object of class list containing Market hours and holidays
  Output

}


#' Use a cusip to search a company and ticker
#'
#' Use a cusip to search a company and ticker
#'
#' @param cusip a valid cusip
#'
#' @return a data frame of symbol, cusip, and company
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # Demo offers AAON as an example
#' fmpc_set_token()
#' fmpc_cusip_search('000360206')
#' }
#'
fmpc_cusip_search <- function(cusip = '000360206') {

  # Make GET request
  Result <- fmpc_get_url(paste0('cusip/',cusip,'?'))
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}



#' Stock Screener
#'
#' Filter for stocks based on numerous criteria.
#'
#' This function will temporarily modify options(scipen=999).
#'
#' @param limit limit output to a certain amount or rows
#' @param mrktCapAbove integer - market cap greater than
#' @param mrktCapBelow integer - market cap less than
#' @param betaAbove double - beta greater than
#' @param betaBelow double - beta less than
#' @param dividendAbove double - dividend greater than
#' @param dividendBelow double - dividend less than
#' @param volumeAbove integer - volume in shares greater than
#' @param volumeBelow integer - volume in shares less than
#' @param sector indicate a sector. Documentation is unclear of options. 'tech'
#'   is the example used
#' @param industry indicate an industry. Documentation is unclear of options.
#'   'Software' is the example used
#'
#' @return a list of securities based on criteria supplied
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_screener() # Default pulls a list of 100 with no filters
#' # Search for market cap above a billion,
#' # that trades at least a million shares with a dividend under 1
#' fmpc_security_screener(mrktCapAbove = 1e9, dividendBelow = 1, volumeAbove = 1e6)
#'
#' }
#'
fmpc_security_screener <- function(limit = 100,
                                   mrktCapAbove = NULL, mrktCapBelow = NULL,
                                   betaAbove = NULL, betaBelow = NULL,
                                   dividendAbove = NULL, dividendBelow = NULL,
                                   volumeAbove = NULL, volumeBelow = NULL,
                                   sector = NULL, industry = NULL) {

  # Reset options on exit
  old <- options()
  on.exit(options(old))
  options(scipen=999)

  # Build URL
  ma = ifelse(!is.numeric(mrktCapAbove),'',paste0('marketCapMoreThan=',mrktCapAbove,'&'))
  mb = ifelse(!is.numeric(mrktCapBelow),'',paste0('marketCapLowerThan=',mrktCapBelow,'&'))
  ba = ifelse(!is.numeric(betaAbove),'',paste0('betaMoreThan=',betaAbove,'&'))
  bb = ifelse(!is.numeric(betaBelow),'',paste0('betaLowerThan=',betaBelow,'&'))
  da = ifelse(!is.numeric(dividendAbove),'',paste0('dividendMoreThan=',dividendAbove,'&'))
  db = ifelse(!is.numeric(dividendBelow),'',paste0('dividendLowerThan=',dividendBelow,'&'))
  va = ifelse(!is.numeric(volumeAbove),'',paste0('volumeMoreThan=',volumeAbove,'&'))
  vb = ifelse(!is.numeric(volumeBelow),'',paste0('volumeLowerThan=',volumeBelow,'&'))
  sec = ifelse(is.null(sector),'',paste0('sector=',sector,'&'))
  ind = ifelse(is.null(industry),'',paste0('industry=',industry,'&'))
  URL = paste0('stock-screener?limit=',limit,'&',ma,mb,ba,bb,da,db,va,vb,sec,ind)


  # Make GET request
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)




}
