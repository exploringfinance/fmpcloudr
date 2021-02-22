#' Pull security rating
#'
#' Provides current and historical rating for one or more securities
#'
#' @inheritParams fmpc_security_profile
#' @param limit limit results for each ticker
#'
#' @return data frame of ratings data
#' @export
#'
#' @examples
#'
#'
#'\dontrun{
#'
#' # Demo can pull AAPL
#' fmpc_set_token()
#' fmpc_security_ratings('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_ratings(c('AAPL','MSFT','SPY'))
#'
#' }
#'
fmpc_security_ratings <- function(symbols = c('AAPL'),
                                  limit = 100) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)


  # Use custom function to collapse requests into data frame
  ratingDF = hlp_bindURLs(paste0('historical-rating/',symbReq,'?limit=',limit,'&'))

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,ratingDF$symbol,'fmpc_security_ratings: ')


  ratingDF

}

#' Pull market capitalization
#'
#' Provides current and historical market cap for one or more securities
#'
#' @inheritParams fmpc_security_ratings
#'
#' @return data frame of ratings data
#' @export
#'
#' @examples
#'
#'
#'\dontrun{
#'
#' # Demo can pull AAPL
#' fmpc_set_token()
#' fmpc_security_mrktcap('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_mrktcap(c('AAPL','MSFT','SPY'))
#'
#' }
#'
fmpc_security_mrktcap <- function(symbols = c('AAPL'),
                                  limit = 100) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)


  # Use custom function to collapse requests into data frame
  ratingDF = hlp_bindURLs(paste0('historical-market-capitalization/',symbReq,'?limit=',limit,'&'))

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,ratingDF$symbol,'fmpc_security_mrktcap: ')


  ratingDF

}

#' Delisted companies
#'
#' Shows companies that have been delisted
#'
#' @param limit set limit of results returned
#'
#' @return data frame of delisted companies
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_delisted()
#'
#' }
#'
fmpc_security_delisted <- function(limit = 100) {

  # Make GET request
  Result <- fmpc_get_url(paste0('delisted-companies?limit=',limit,'&'))
  Result <- hlp_chkResult(Result)

  dplyr::as_tibble(Result)
}

#'Get current news
#'
#'Provides current and historical News. Can enter securities to pull news for
#'specific securities
#'
#' @param symbols one or more symbols. Use NULL for general latest news
#' @inheritParams fmpc_security_ratings
#'
#' @return data frame of news for tickers
#' @export
#'
#' @examples
#'
#'\dontrun{
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_security_news(c('AAPL','MSFT','SPY'))
#' fmpc_security_news()
#'
#' }
#'
fmpc_security_news <- function(symbols = NULL,
                               limit = 100) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)
  # symbURL = ifelse(length(symbReq)==0,'',paste0('tickers=',paste0(symbReq,collapse = ','),'&'))
  if (length(symbReq)==0) {
    symbURL = ''
  } else {
    symbURL = paste0('tickers=',symbReq,'&')
    }

  # Use custom function to collapse requests into data frame
  newsDF = hlp_bindURLs(paste0('stock_news?',symbURL,'limit=',limit,'&'))

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,newsDF$symbol,'fmpc_security_mrktcap: ')


  newsDF

}

#' Pull analyst outlook for one or more securities
#'
#' Analyst details for one or more securities includes earnings estimates,
#' earnings surprises, stock grade, analyst recommendations, and company press
#' releases
#'
#' @inheritParams fmpc_security_ratings
#' @param outlook can be one of: 'surprise' for earnings surprise, 'grade' for
#'   stock grade', 'estimateAnnl' for analysts annual estimates, 'estimateQtr'
#'   for analysts quarterly estimate, 'recommend' for analyst recommendations,
#'   and 'press' for company press releases
#'
#' @return data frame of ratings data
#' @export
#'
#' @examples
#'
#'\dontrun{
#'
#' # Demo can pull AAPL
#' fmpc_set_token()
#' fmpc_analyst_outlook('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_analyst_outlook(c('AAPL','MSFT','SPY'))
#'
#' }
#'
fmpc_analyst_outlook <- function(symbols = c('AAPL'),
                                 outlook = c('surprise','grade','estimate','recommend','press'),
                                 limit = 100) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)

  # Verify outlook
  analysisOp = c('surprise','grade','estimateAnnl','estimateQtr','recommend','press')
  if (missing(outlook)) outlook = 'surprise'
  if (!(outlook %in% analysisOp)) {
    stop('Please enter a metric value of: ',paste0(analysisOp, collapse = ', '), call. = FALSE)
  }
  outURL = switch(outlook,'surprise' = 'earnings-surpises', 'grade' = 'grade',
                 'estimateAnnl' = 'analyst-estimates', 'estimateQtr' = 'analyst-estimates',
                 'press' = 'press-releases', 'recommend' = 'analyst-stock-recommendations')

  qtrAdd = ifelse(outlook == 'estimateQtr','period=quarter&','')
  # Use custom function to collapse requests into data frame
  outlookDF = hlp_bindURLs(paste0(outURL,'/',symbReq,'?limit=',limit,'&',qtrAdd))

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,outlookDF$symbol,'fmpc_security_mrktcap: ')


  outlookDF

}


#' Full transcript of earnings call
#'
#' @inheritParams fmpc_security_ratings
#' @param quarter earnings year quarter
#' @param year earnings call year
#'
#' @return earnings call transcript in data frame
#' @export
#'
#' @examples
#'
#'\dontrun{
#'
#' # Demo can pull AAPL
#' fmpc_set_token()
#' fmpc_earning_call_transcript('AAPL',quarter = 1, year = 2019)
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_earning_call_transcript(c('AAPL','MSFT','SPY'))
#'
#' }
#'
fmpc_earning_call_transcript <- function(symbols = c('AAPL'),
                                         quarter = 2,
                                         year = 2020) {

  symbReq = hlp_symbolCheck(symbols)
  callURL = paste0('earning_call_transcript/',symbReq,'?quarter=',quarter,'&year=',year,'&')

  # Use custom function to collapse requests into data frame
  callDF = hlp_bindURLs(callURL)

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,callDF$symbol,'fmpc_earning_call_transcript: ')

  callDF

}



