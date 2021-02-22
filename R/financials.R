#' Get a list of Financial ZIP file locations
#'
#' Get location to download ZIP file for all symbols. This function will not
#' download the file. Use a 'wget' command or enter the link into a browser.
#'
#' @return a data frame of symbols with zip file location
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_financial_zip()
#'
#' }
fmpc_financial_zip <- function() {

  # for check()
  symbol = NULL

  # Make GET request
  Result <- fmpc_get_url('financial-statement-symbol-lists?')
  Result <- dplyr::tibble(symbol = Result)
  Result <- Result %>%
    dplyr::mutate(zipLocation = paste0('https://fmpcloud.io/api/v3/financial-statements/',symbol,'?datatype=zip&apikey=',getOption("fmpc_API_token"))) %>%
    dplyr::distinct()

  # Return result as tibble
  dplyr::as_tibble(Result)
}



#' Get financial data for one or more tickers
#'
#' Pull balance sheet, income statement, or cash flow statement for one or more
#' tickers. Can elect to see data quarterly or annually and view growth
#'
#' @param symbols one or more publicly traded companies domestic or
#'   international
#' @param statement indicate the statement to view. Can be 'income', 'balance',
#'   or 'cashflow'
#' @param quarterly TRUE/FALSE whether the statement should be shown quarterly
#'   or annually
#' @param growth TRUE/FALSE whether the growth statement should be shown
#' @param SECReported TRUE/FALSE whether to display the information as it was
#'   reported to the SEC. Only one symbol can be passed if this is set to TRUE.
#'   Growth must also be set to FALSE. International stocks should not be
#'   passed.
#' @param limit limit the result for each ticker
#'
#' @return returns balance sheet, income statement, or cash flow
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#' # Setting API key to 'demo' allows for AAPL only
#' fmpc_set_token()
#' fmpc_financial_bs_is_cf()
#' fmpc_financial_bs_is_cf('AAPL',statement = 'balance', quarterly = FALSE,
#'                      growth = FALSE, SECReported = TRUE, limit = 10)
#'
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_financial_bs_is_cf(c('AAPL','MSFT','TSLA'))
#'
#'  symbols = c('AAPL','MSFT','BAC')
#'  Bal = fmpc_financial_bs_is_cf(symbols,statement = 'balance')
#'  BalG = fmpc_financial_bs_is_cf(symbols,statement = 'balance', growth = FALSE)
#'  IS = fmpc_financial_bs_is_cf(symbols,statement = 'income')
#'  ISa = fmpc_financial_bs_is_cf(symbols,statement = 'income', quarterly = FALSE)
#'  cf = fmpc_financial_bs_is_cf(symbols,statement = 'cashflow')
#'  cfsec = fmpc_financial_bs_is_cf(symbols,statement = 'cashflow', SECReported  = TRUE)
#'
#' # International tickers work
#' fmpc_financial_bs_is_cf('RY.TO',statement = 'balance', quarterly = TRUE,
#'                      growth = TRUE, SECReported = FALSE, limit = 10)
#'
#' }
fmpc_financial_bs_is_cf <- function(symbols = 'AAPL',
                                    statement = c('income','balance','cashflow'),
                                    quarterly = TRUE,
                                    growth = FALSE,
                                    SECReported = FALSE,
                                    limit = 100) {
  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Collect and verify user inputs
  statements = c('income','balance','cashflow')
  if (missing(statement)) statement <- 'income'
  if (!(statement %in% statements)) {
    stop('Please enter a statment value of: ',paste0(statements, collapse = ', '), call. = FALSE)
  }

  # Check SEC request
  if (SECReported & (growth | length(symbReq)>1)){
    stop('If SECReported = TRUE. Only pass 1 symbol and ensure growth = FALSE', call. = FALSE)
  }

  # Gather User inputs
  finObject = switch(statement, 'income' = 'income', 'balance' = 'balance-sheet', 'cashflow' = 'cash-flow')
  grw = ifelse(growth,'-growth','')
  pd = ifelse(quarterly,'period=quarter&','')
  sec = ifelse(SECReported,'-as-reported','')

  # Create URL based on user inputs
  URL = paste0(finObject,'-statement',grw,sec,'/',symbReq,'?',pd,'limit=',limit,'&')
  bindedDF = hlp_bindURLs(URL)

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,bindedDF$symbol,'fmpc_financial_bs_is_cf: ')

  # Return binded DataFrame
  bindedDF
}



#' Get financial metrics for one or more tickers
#'
#' Pull finance ratios, enterprise value, key metrics, and financial growth
#'
#' @inheritParams fmpc_financial_bs_is_cf
#'
#' @param metric indicate the statement to view. Can be 'income', 'balance',
#'   or 'cashflow'
#' @param trailingTwelve TRUE/FALSE whether finance ratios should show as
#'   trailing 12 months. Only available for finance ratios.
#'
#' @return data frame of financial metrics
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#'  # Setting API key to 'demo' allows for AAPL only
#' fmpc_set_token()
#' fmpc_financial_metrics()
#' fmpc_financial_metrics('AAPL',metric = 'ratios', quarterly = FALSE,
#'                      trailingTwelve = FALSE, limit = 10)
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_financial_metrics(c('AAPL','MSFT','TSLA'))
#'
#' # International tickers work
#' fmpc_financial_metrics('RY.TO',metric = 'key', quarterly = TRUE,
#'                      trailingTwelve = TRUE, limit = 10)
#'
#'
#'
#' }
fmpc_financial_metrics <- function(symbols = 'AAPL',
                                   metric = c('ratios','key','ev','growth'),
                                   quarterly = TRUE,
                                   trailingTwelve = FALSE,
                                   limit = 100) {
  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Collect and verify user inputs
  metrics = c('ratios','key','ev','growth')
  if (missing(metric)) metric <- 'ratios'
  if (!(metric %in% metrics)) {
    stop('Please enter a metric value of: ',paste0(metrics, collapse = ', '), call. = FALSE)
  }
  finObject = switch(metric, 'ratios' = 'ratios', 'key' = 'key-metrics',
                     'ev' = 'enterprise-values', 'growth' = 'financial-growth')
  ttm = ifelse(trailingTwelve,'-ttm','')
  pd = ifelse(quarterly,'period=quarter&','')


  # Create URL based on user inputs
  finMet_df = data.frame(URL = paste0(finObject,ttm,'/',symbReq,'?',pd,'limit=',limit,'&'),
                          label =  symbReq)
  bindedDF = hlp_bindURLs(finMet_df$URL, label_df = finMet_df, label_name = 'symbol')


  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,bindedDF$symbol,'fmpc_financial_bs_is_cf: ')

  # Return binded DataFrame
  bindedDF
}



#'Discounted Cash Flow Value
#'
#'Pull Discounted Cash Flow Value for one or more securities
#'
#'@inheritParams fmpc_financial_bs_is_cf
#'@param period period for discounted cash flow - current, daily, quarterly,
#'  annually
#'
#'@return data frame of discounted cash flow
#'@export
#'
#' @examples
#'
#'
#'\dontrun{
#'
#' # Demo can pull AAPL
#' fmpc_set_token()
#' fmpc_financial_dcfv('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_financial_dcfv(c('AAPL','MSFT','SPY'), period = 'quarterly')
#'
#' }
#'
fmpc_financial_dcfv <- function(symbols = c('AAPL'),
                                period = c('current','daily','quarterly','annually'),
                                limit = 100) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Parse period into a URL
  periods = c('current','daily','quarterly','annually')
  if (missing(period)) period = 'current'
  if (!(period %in% periods)) {
    stop('Please enter a metric value of: ',paste0(periods, collapse = ', '), call. = FALSE)
  }
  hist = ifelse(period=='current','','historical-')
  lmt = ifelse(period=='current','',paste0('limit=',limit,'&'))
  day = ifelse(period=='daily','daily-','')
  qtr = ifelse(period=='quarterly','period=quarter&','')
  stmt = ifelse(period %in% c('quarterly','annually'),'-statement','')

  # Build URL
  URL = paste0(hist,day,'discounted-cash-flow',stmt,'/',symbReq,'?',qtr,lmt)

  # Use custom function to collapse requests into data frame
  dcfDF = hlp_bindURLs(URL)

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,dcfDF$symbol,'fmpc_financial_dcfv: ')


  dcfDF

}

