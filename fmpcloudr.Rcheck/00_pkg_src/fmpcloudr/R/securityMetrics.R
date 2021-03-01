#' Historical security split data
#'
#' Pulls stock split history for one or more securities
#'
#' @section Warning: Each symbol is a separate API call. If the API token has
#'   monthly limits, this should be considered before making a bulk request
#'
#' @inheritParams fmpc_price_history
#'
#' @return a data frame of split history
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#' # Setting API key to DEMO allows for AAPL only
#' fmpc_set_token()
#' fmpc_security_splits('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_splits(c('AAPL','TSLA'), startDate = '2020-01-01')
#'
#' }
fmpc_security_splits <- function(symbols = 'AAPL',
                                 startDate = Sys.Date()-3600,
                                 endDate = Sys.Date()) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Use single historical pull helper function
  splt_url = 'historical-price-full/stock_split/'
  bindedDF = dplyr::bind_rows(lapply(symbReq,
                                     function(x) hlp_symbolHistory(x,splt_url,startDate,endDate)))

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,bindedDF$symbol,'fmpc_security_splits: ')

  # Return Data Frame
  bindedDF

}


#' Historical security dividend data
#'
#' Pulls dividends for a list of securities. Data includes dividend, adjusted
#' dividend, payment date, record date, and declaration date
#'
#' @section Warning: Each symbol is a separate API call. If the API token has
#'   monthly limits, this should be considered before making a bulk request
#'
#' @inheritParams fmpc_price_history
#'
#' @return a data frame of dividend history that includes payment date, record
#'   date, and declaration date
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#' # Setting API key to DEMO allows for AAPL only
#' fmpc_set_token()
#' fmpc_security_dividends('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_dividends(c('AAPL','MSFT','SPY'), startDate = '2010-01-01')
#'
#' }
fmpc_security_dividends <- function(symbols = 'AAPL',
                                    startDate = Sys.Date()-360,
                                    endDate = Sys.Date()) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Use single historical pull helper function
  div_url = 'historical-price-full/stock_dividend/'
  bindedDF = dplyr::bind_rows(lapply(symbReq,
                                     function(x) hlp_symbolHistory(x,div_url,startDate,endDate)))

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,bindedDF$symbol,'fmpc_security_dividends: ')

  # Return Data Frame
  bindedDF

}


#' Pull daily returns for all sectors
#'
#' For each day, the return for a sector will be pulled
#'
#' @param days number of trading days to pull returns from current day. For
#'   example, 20 will pull the last 20 trading days, about one month of data.
#'
#' @return data frame of sectors and daily returns
#' @export
#'
#' @examples
#' \dontrun{
#'
#' fmpc_set_token('FMPAPIKEY')
#' allSymbs = fmpc_security_sector(30)
#'
#' }
fmpc_security_sector <- function(days = 25) {

  # Set variables to NULL for check()
  sector <- percentChange <- NULL

  # Create URL
  URL = paste0('historical-sectors-performance?limit=',days,'&')

  # GET request
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)
  if (is.null(Result)) return(NULL)
  # Modify output into a more readable format
  dplyr::as_tibble(Result) %>%
    tidyr::gather(key='sector',value='percentChange',-date) %>%
    dplyr::mutate(sector = gsub('ChangesPercentage','',sector),
                  percentChange = percentChange/100) %>%
    dplyr::arrange(date,sector) ->
    Return

  # Return Result
  Return
}


#' Pull profile for a company
#'
#' Provides pricing, market cap, dividend, company description, CEO, number of
#' employees, and more for one or more symbols
#'
#' @param symbols one or more symbols from the FMP available list that can be
#'   found using \code{\link{fmpc_symbols_available}}. A valid API token must be
#'   set in order to enable functionality. See documentation for setting a token
#'   under \code{\link{fmpc_set_token}}.
#'
#' @return data frame of descriptive information
#' @export
#'
#' @examples
#'
#'
#'\dontrun{
#'
#' # Demo can pull AAPL
#' fmpc_set_token()
#' fmpc_security_profile('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_profile(c('AAPL','MSFT','SPY'))
#'
#' }
#'
fmpc_security_profile <- function(symbols = c('AAPL')) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)


  # Use custom function to collapse requests into data frame
  symbol_df = data.frame(URL =  paste0('profile/',symbReq,'?'),
                         label =  gsub('%5E','\\^',symbReq))
  profileDF = hlp_bindURLs(symbol_df$URL)

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,profileDF$symbol,'fmpc_security_profile: ')


  profileDF

}

#' Gainers, Losers, and active
#'
#' Shows top gainers, bottom losers, and most active for the current trading day
#'
#' @param gla options include 'gainers','losers', and 'active'
#'
#' @return securities with details for current trading day
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_gla('gainers')
#' fmpc_security_gla('losers')
#' fmpc_security_gla('actives')
#'
#' }
#'
fmpc_security_gla <- function(gla = c('gainers','losers','actives')) {

  # Make GET request
  if (missing(gla)) gla = 'gainers'
  hlp_select(gla, c('gainers','losers','actives'))

  Result <- fmpc_get_url(paste0(gla,'?'))
  Result <- hlp_chkResult(Result)

  dplyr::as_tibble(Result)
}

#' Technical Indicators
#'
#' Pull Technical Indicators for a set of symbols over a specific number of
#' periods set by the frequency
#'
#' Technical indicators include: 'SMA', 'EMA', 'WMA', 'DEMA', 'TEMA',
#' 'williams', 'RSI', 'ADX', 'standardDeviation'
#'
#' @inheritParams fmpc_price_history
#' @param freq the frequency of which to pull intraday data. Options are
#'   '1min', '5min', '15min', '30min', '1hour'
#' @param period Number of periods over which to calculate the technical
#'   indicator
#' @param indicator 'SMA', 'EMA', 'WMA', 'DEMA', 'TEMA', 'williams', 'RSI',
#'   'ADX', 'standardDeviation'
#'
#' @return technical indicator in a data frame
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Setting API key to DEMO allows for AAPL only
#' fmpc_set_token()
#' fmpc_security_tech_indic('AAPL')
#' fmpc_security_tech_indic('AAPL', indicator = 'standardDeviation')
#' fmpc_security_tech_indic('AAPL', 'sma')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_tech_indic(c('AAPL','MSFT','SPY'), indicator = 'RSI', freq = '15min', period = 25)
#'
#' }
fmpc_security_tech_indic <- function(symbols = 'AAPL',
                                     indicator = c('SMA', 'EMA', 'WMA', 'DEMA', 'TEMA',
                                                   'williams', 'RSI', 'ADX', 'standardDeviation'),
                                     freq = c('daily','1min','5min','15min','30min','1hour','4hour'),
                                     period = 10) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  if (missing(freq)) freq = 'daily'
  if (missing(indicator)) indicator = 'SMA'
  indicator = ifelse(tolower(indicator)=='standarddeviation','standardDeviation',tolower(indicator))
  freq = tolower(freq)

  # Check inputs for validity
  freqOpt = c('daily','1min','5min','15min','30min','1hour','4hour')
  indOpt = c('SMA', 'EMA', 'WMA', 'DEMA', 'TEMA', 'williams', 'RSI', 'ADX', 'standardDeviation')
  if (!(freq %in% freqOpt)) {
    stop(paste0('freq should be one of the following: ',paste0(freqOpt, collapse = ', ')))
  }
  if (!(tolower(indicator) %in% tolower(indOpt))) {
    stop(paste0('indicator should be one of the following: ',paste0(indOpt, collapse = ', ')))
  }


  frontURL = paste0('technical_indicator/',freq,'/')
  backURL = paste0('?period=',period,'&type=',indicator,'&')

  # Use create custom function to collapse data frame
  techInd_df = data.frame(URL = paste0('technical_indicator/',freq,'/',symbReq,'?period=',period,'&type=',indicator,'&'),
                        label =  symbReq)
  bindedDF = hlp_bindURLs(techInd_df$URL, label_df = techInd_df, label_name = 'symbol')

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,bindedDF$symbol,'fmpc_security_tech_indic: ')


  # Returned merged data frame as tibble
  bindedDF

}


