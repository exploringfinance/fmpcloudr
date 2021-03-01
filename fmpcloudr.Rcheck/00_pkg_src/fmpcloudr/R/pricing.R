#' Historical End of Day pricing data for one or more symbols
#'
#' End of Day price history includes open, high, low, close, adjClose, volume,
#' vwap, and more. Symbol can include equity, mutual fund, index, currency, crypto,
#' or any other symbol that can be found in \code{\link{fmpc_symbols_by_market}}.
#'
#' @section Warning: Each symbol is a separate API call. If the API token has
#'   monthly limits, this should be considered before making a bulk request
#'
#' @param symbols one or more symbols from the FMP available list that can be
#'   found using \code{\link{fmpc_symbols_by_market}}. A valid API token must be
#'   set in order to enable functionality. See documentation for setting a token
#'   under \code{\link{fmpc_set_token}}.
#' @param startDate filter start date in yyyy-mm-dd format.
#' @param endDate filter end date in yyyy-mm-dd format.
#'
#' @return a data frame of price history
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#' # Default sets token to 'demo' which allows for AAPL only
#' fmpc_set_token()
#' fmpc_price_history('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' # Crypto, equity, currency, and index can all be entered in the same request
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_price_history(c('AAPL','MSFT','SPY','^SP500TR','JPYUSD','BTCUSD'))
#'
#' }
fmpc_price_history <- function(symbols = 'AAPL',
                               startDate = Sys.Date()-30,
                               endDate = Sys.Date()) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Use single historical pull helper function
  prc_url = 'historical-price-full/'
  bindedDF = dplyr::bind_rows(lapply(symbReq,
                              function(x) hlp_symbolHistory(x,prc_url,startDate,endDate)))

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,bindedDF$symbol,'fmpc_price_history: ')

  # Return Data Frame
  bindedDF

}


#' Historical EOD pricing, split, and dividend data for one or more symbols
#'
#' Pulls End of Day prices, splits, and dividends for a list of symbols. Symbol
#' can include equity, mutual fund, index, currency, crypto, or any other symbol
#' that can be found in \code{\link{fmpc_symbols_by_market}}.
#'
#' Uses functions \code{\link{fmpc_price_history}},
#' \code{\link{fmpc_security_dividends}}, and \code{\link{fmpc_security_splits}}
#' to aggregate split, dividend, and pricing data into a single data frame.
#' Warnings may be generated that split data or dividend data was not returned.
#' Results will still show in this function if price_history data is available.
#'
#' @section Warning: Each symbol is THREE separate API calls. If the API token
#'   has monthly limits, this should be considered before making a bulk request.
#'   Large Symbol requests will also take time because of the buffer time
#'   between API calls.
#'
#' @inheritParams fmpc_price_history
#'
#' @return a data frame of pricing, split, and dividend history
#' @export
#'
#' @examples
#'
#'
#'
#' \dontrun{
#' # Setting API key to 'demo' allows for AAPL only
#' fmpc_set_token()
#' fmpc_price_history_spldiv('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' # Index, currency, and crypto will return data even without splits/divs
#' fmpc_price_history_spldiv(c('AAPL','MSFT','SPY','^SP500TR','JPYUSD','BTCUSD'))
#'
#' }
fmpc_price_history_spldiv = function(symbols = 'AAPL',
                                     startDate = Sys.Date()-360,
                                     endDate = Sys.Date()) {

  # Set Variables to NULL for check()
  label <- adjDividend <- numerator <- denominator <- NULL

  # Get Price, Split, and Dividend Data
  PriceOut = fmpc_price_history(symbols,startDate,endDate)
  DivOut = fmpc_security_dividends(symbols,startDate,endDate)
  SSOut = fmpc_security_splits(symbols,startDate,endDate)

  # Merge data together where available
  TibOut = PriceOut
  if (length(TibOut)>0) {
    # If no Div Data then set to 0
    if (length(DivOut)>0) {
        TibOut =  TibOut %>% dplyr::left_join(dplyr::select(DivOut,-label),by=c('date','symbol'))
      } else {
        TibOut =  TibOut %>% dplyr::mutate(adjDividend=0)
      }
    # If no Split data then set Num/Denom to 1/1
    if(length(SSOut)>0) {
        TibOut = TibOut %>%
          dplyr::left_join(dplyr::select(SSOut,-label),by=c('date','symbol'))
      } else {
        TibOut = TibOut %>%
          dplyr::mutate(numerator=1,denominator=1)
      }

    # Set missing values to 0 and 1 for Dividend and Split Factor
    TibOut =  TibOut %>%
      dplyr::mutate(adjDividend = if.na(adjDividend,0),
                    splitFactor = if.na(numerator,1)/if.na(denominator,1),
                    numerator = NULL,
                    denominator = NULL)
  }

  # Return merged data frame
  TibOut

}

#' Historical End of Day pricing data for one or more symbols
#'
#' Intraday includes open, high, low, close, for each time segment. The amount
#' of history available is based on the freq set. Smaller time intervals
#' frequency will pull back less history. Symbol can include equity, mutual
#' fund, index, currency, crypto, or any other symbol that can be found in
#' \code{\link{fmpc_symbols_by_market}}. Available history is limited by the
#' increment size.
#'
#'
#' @section Warning: Each symbol is a separate API call. If the API token has
#'   monthly limits, this should be considered before making a bulk request
#'
#' @inheritParams fmpc_price_history
#' @param freq the frequency of which to pull intraday prices. Options can be
#'   '1min','5min','15min','30min','1hour'
#'
#' @return a data frame of intraday prices
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#' # Setting API key to 'demo' allows for AAPL only
#' fmpc_set_token()
#' # Freq of1hour will return about 2 months of data
#' fmpc_price_intraday('AAPL', freq = '5min')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_price_intraday(symbols = c('AAPL','MSFT','SPY','^SP500TR','JPYUSD','BTCUSD'),
#'                    startDate = '2020-01-01', freq = '1hour')
#'
#' }
fmpc_price_intraday <- function(symbols = 'AAPL',
                                startDate = Sys.Date()-30,
                                endDate = Sys.Date(),
                                freq = c('1min','5min','15min','30min','1hour')) {

  # Set variables to NULL for check()
  dateTime <- symbol <- NULL

  # If freq missing, default to 30 min - error if outside list
  if (missing(freq)) freq <- '30min'
  hlp_select(freq, c('1min','5min','15min','30min','1hour'))

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Use create custom function to collapse data frame
  intra_df = data.frame(URL = paste0('historical-chart/',freq,'/',symbReq,'?from=',startDate,'&to=',endDate,'&'),
                        label =  gsub('%5E','\\^',symbReq))
  bindedDF = hlp_bindURLs(intra_df$URL, label_df = intra_df, label_name = 'symbol')

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,bindedDF$symbol,'fmpc_price_intraday: ')


  # If result is NULL, then return NULL
  if (is.null(bindedDF)) return(NULL)
  # Return Data Frame
  bindedDF %>%
    dplyr::mutate(dateTime = lubridate::as_datetime(date, tz = 'America/New_York'),
                  symbol = as.character(symbol),
                  date = as.Date(dateTime)) %>%
    dplyr::arrange(symbol,dateTime) %>%
    dplyr::relocate(symbol,date,dateTime)->
    Return

  # Return Result
  Return

}


#' Pull all EOD pricing data for a specific date
#'
#' Returns 10,000 or more symbols for a specific date. This generates one API
#' call for each date. Dates must be entered one at a time.
#'
#' @param priceDate price date to pull all securities. Use format yyyy-mm-dd
#'
#' @return data frame of a single days prices
#' @export
#'
#' @examples
#' \dontrun{
#'
#' fmpc_set_token('FMPAPIKEY')
#' allSymbs = fmpc_price_batch_eod('2020-06-24')
#'
#' }
fmpc_price_batch_eod <- function(priceDate = Sys.Date()-1) {

  # Create URL based on the Price Date
  URL = paste0('batch-request-end-of-day-prices?date=',priceDate,'&')

  # Make request and send error if nothing returned
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)
  if (is.null(Result)) return(NULL)

  # Check if any results
  if (nrow(Result) == 0) {
    stop('No results. Make sure the priceDate is less than current day and a valid trading day', call. = FALSE)
  }

  # Modify to tibble and date class
  dplyr::as_tibble(Result) %>%
    dplyr::mutate(date = as.Date(date)) ->
    Return

  # Return Result
  Return

}

#' Current price
#'
#' Last traded price with additional price metrics such as 50D and 200D avg
#' price, volume, shares outstanding, and more. This does NOT include a quote,
#' such as bid/ask detail.
#'
#' @inheritParams fmpc_price_history
#'
#' @return data frame of current price details
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#' # Setting API key to 'demo' allows for AAPL only
#' fmpc_set_token()
#' fmpc_price_current('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_price_current(c('AAPL', 'MSFT', 'TSLA', 'SPY', 'BTCUSD', 'JPYUSD', '^SP500TR'))
#'
#' }
#'
#'
fmpc_price_current <- function(symbols = c('AAPL')) {

  # Set variables to NULL for check()
  dateTime <- NULL

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Create URL for function. Allow for multiple symbols
  URL <- paste0('quote/',paste0(symbReq,collapse = ','),'?')

  # Make Get request
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,Result$symbol,'fmpc_price_current: ')

  # If result is NULL, then return NULL
  if (is.null(Result)) return(NULL)

  # Modify results
  dplyr::as_tibble(Result) %>%
    dplyr::rename(dateTime = 22) %>% # rename timestamp to avoid check() errors
    dplyr::mutate(dateTime = lubridate::as_datetime(dateTime, tz = 'America/New_York')) ->
    Return

  # Return Result
  Return

}



#' Current Price for an Entire Market
#'
#' Enter a market to get last traded price with additional price metrics such as
#' 50D and 200D avg price, volume, shares outstanding, etc. This does NOT
#' include a quote, such as bid/ask detail. Each market will return multiple
#' responses, but only one API call as made per market.
#'
#' @param market Select a market to get current price for all securities:
#'   'etf','commodity','euronext','nyse','amex','tsx','index','mutual_fund',
#'   'nasdaq','crypto','forex'. Select a single market.
#'
#'
#' @return data frame of current price
#' @export
#'
#' @examples
#' \dontrun{
#'
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_price_full_market('index')
#' fmpc_price_full_market('forex')
#' fmpc_price_full_market() # Default is to 'etf'
#'
#' }
fmpc_price_full_market <- function(market = 'etf') {

  # Set variables to NULL for check()
  dateTime <- NULL

  # Set available markets to query
  mrktsAvail = c('etf','commodity','euronext','nyse','amex','tsx','index','mutual_fund',
                 'nasdaq','crypto','forex')

  # Validate market request
  if (!(market %in% mrktsAvail)) {
    stop(paste0('Please enter a valid market: ',paste0(mrktsAvail,collapse = ', ')), call. = FALSE)
  }

  # Create URL for function. Allow for multiple symbols
  URL <- paste0('quotes/',market,'?')

  # Make Get request
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)

  # Modify results
  dplyr::as_tibble(Result) %>%
    dplyr::rename(dateTime = 22) %>% # rename timestamp to avoid check() errors
    dplyr::mutate(dateTime = lubridate::as_datetime(dateTime, tz = 'America/New_York')) ->
    Return

  # Return Result
  Return

}

#' Get all foreign exchange quotes
#'
#' Use a valid API Token to pull all foreign exchange quotes which includes
#' Bid/Ask. Set API token using \code{\link{fmpc_set_token}}.
#'
#' @return a data frame of forex with quotes
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_price_forex()
#'
#' }
fmpc_price_forex <- function() {

  # Make GET request
  Result <- fmpc_get_url('fx?')
  Result <- hlp_chkResult(Result)

  ticker <- NULL # for check()

  # Return result as tibble
  dplyr::as_tibble(Result) %>%
    dplyr::mutate(ticker = gsub('/','',ticker))
}
