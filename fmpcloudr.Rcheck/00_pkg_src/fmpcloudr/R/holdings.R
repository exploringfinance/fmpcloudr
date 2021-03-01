#' List of all 13F ciks
#'
#' Ciks are unique IDs for each company that files a 13F. This function returns
#' a list of each unique cik that FMP Cloud has available.
#'
#'
#' @return cik list
#' @export
#'
#' @examples
#'\dontrun{
#' # Function can work without a valid API token
#' fmpc_set_token() # defaults to 'demo'
#' fmpc_13f_cik_list()
#'}
fmpc_13f_cik_list <- function() {

  # Make GET request
  Result <- fmpc_get_url('cik_list?')
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}

#' Search for 13F ciks
#'
#' Ciks are unique IDs for each company that files a 13F. This function allows
#' search queries to identify and search for specific companies.
#'
#' @param query a search string to find asset managers by name
#'
#' @return cik list
#' @export
#'
#' @examples
#'
#'
#' \dontrun{
#'
#' # Function can work without a valid API token
#' fmpc_set_token() # defaults to 'demo'
#' fmpc_13f_cik_search('Berkshire')
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_13f_cik_search('Morgan')
#'
#' }
fmpc_13f_cik_search <- function(query = 'Berkshire') {

  # Build URL and Make GET request
  URL = paste0('cik-search/',gsub(' ','%20',query),'?')
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)

  dplyr::as_tibble(Result)
}


#' Find name of company by cik
#'
#' Ciks are unique IDs for each company that files a 13F. This function returns
#' the name of the company associated with one or more ciks
#'
#' @param cik a valid cik
#'
#' @return company name associated with cik
#' @export
#'
#' @examples
#' \dontrun{
#' # Function can work without a valid API token
#' fmpc_set_token() # defaults to 'demo'
#' fmpc_13f_cik_name(cik = '0001067983')
#' }
fmpc_13f_cik_name <- function(cik = '0001067983') {

  cikReq = unique(cik)

  # Make GET request
  Result <- hlp_bindURLs(paste0('cik/',cikReq,'?'))
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  Result
}

#' 13F data for a set of ciks and dates
#'
#' 13F shows the holdings of an asset manager as of a specific date
#'
#' @param cik one or more valid ciks from \code{\link{fmpc_13f_cik_list}}
#' @param date one or more quarter end dates (yyyy-03-31, yyyy-06-30,
#'   yyyy-09-30, yyyy-12-31)
#'
#' @return 13F holdings
#' @export
#'
#' @examples
#'
#'
#'
#' \dontrun{
#'
#' # Berkshire can be run using the demo
#' fmpc_set_token()
#' fmpc_13f_data('0001067983', '2020-03-31')
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' goldmanCik = fmpc_13f_cik_search('golman')
#' fmpc_13f_data(cik = goldmanCik$cik, date = c('2020-03-31','2020-06-30'))
#'
#' }
fmpc_13f_data <- function(cik = '0001067983',
                          date = '2019-12-31') {

  # For check()
  fillingDate <- NULL

  # convert to unique cik
  cikPull = unique(cik)

  #Force date to quarter end
  datePull = unique(lubridate::ceiling_date(as.Date(date), unit = 'quarter') - 1)
  checkDate = unique(date) != datePull
  if (TRUE %in% checkDate) warning('13F can only be pulled for quarter end.', call. = FALSE)

  CrossCikDate = tidyr::crossing(cik = cikPull, date = datePull) %>%
    dplyr::mutate(URL =  paste0('form-thirteen/',cik,'?date=',date,'&'))


  # Use create custom function to collapse data frame
  cikDate = hlp_bindURLs(CrossCikDate$URL)


  # Send warning for symbols not pulled
  hlp_respCheck(cikPull,cikDate$cik,'Missing cik(s) for fmpc_13f_data: ')
  hlp_respCheck(datePull,unique(cikDate$date),'Missing date(s) fmpc_13f_data: ')

  # If result is NULL, then return NULL
  if (is.null(cikDate)) return(NULL)
  cikDate %>%
    dplyr::distinct() %>%
    dplyr::mutate_at(dplyr::vars(date,fillingDate),as.Date)
}



#' RSS feed of latest submissions to SEC
#'
#' RSS feed of latest submissions to SEC that includes 6-k, 10-Q, 13F
#'
#' @param limit limit output to a specific number of results
#'
#' @return a data frame of title, data, link to submission, cik, and submission
#'   type
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # Demo offers AAON as an example
#' fmpc_set_token()
#' fmpc_rss_sec()
#' }
#'
fmpc_rss_sec <- function(limit = 100) {

  # Make GET request
  Result <- fmpc_get_url(paste0('rss_feed?limit=',limit,'&'))
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}


#' List of mutual funds that hold a specified symbol
#'
#' Shows mutual funds holding a list of symbols provided. Not currently available
#' for ETFs
#'
#' This differs from \code{\link{fmpc_holdings_etf}} which allows a search by
#' ETF to see detail on what the ETF is holding.
#'
#' @inheritParams fmpc_price_history
#'
#' @return data frame of mutual funds holding specified security
#' @export
#'
#' @examples
#'
#'
#'
#'\dontrun{
#'
#' # Demo can pull AAPL
#' fmpc_set_token()
#' fmpc_held_by_mfs('AAPL')
#'
#' # For multiple symbols, set a valid API Token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_held_by_mfs(c('AAPL','MSFT','GOOGL'))
#'
#' }
#'
fmpc_held_by_mfs <- function(symbols = c('AAPL')) {

  # Confirm Bulk API Request
  symbReq = hlp_symbolCheck(symbols)


  # Use custom function to collapse requests into data frame
  mf_df = data.frame(URL =  paste0('mutual-fund-holder/',symbReq,'?'),
                     label =  gsub('%5E','\\^',symbReq))
  mutualFundDF = hlp_bindURLs(mf_df$URL, label_df = mf_df, label_name = 'symbol')

  # Send warning for symbols not pulled
  hlp_respCheck(symbReq,mutualFundDF$symbol,'fmpc_held_by_mfs: ')


  mutualFundDF

}



#' Pull ETF holdings data
#'
#' Shows holdings data for one or more ETFs provided. Either individual
#' holdings, sector weightings, or country weightings.
#'
#' This differs from \code{\link{fmpc_held_by_mfs}} which allows a search by
#' symbol to see the mutual funds holding the specified symbol(s). This function
#' searches by ETF and shows the holding of the ETF
#'
#'
#' @param etfs one or more valid ETFs.
#' @param holding holding type can be other individual symbols, the sector
#'   breakdown, or the country breakdown. Valid inputs include 'symbol',
#'   'sector', 'country'
#'
#' @return data frame of mutual fund holdings
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#'  # For multiple symbols, set a valid API Token
#'  fmpc_set_token('FMPAPIKEY')
#'  fmpc_holdings_etf(c('VOO','SPY'), holding = 'symbol')
#'  fmpc_holdings_etf(c('VOO','SPY'), holding = 'country')
#'  fmpc_holdings_etf(c('VOO','SPY'), holding = 'sector')
#'
#'  }
#'
fmpc_holdings_etf <- function(etfs = c('SPY'),
                              holding = c('symbol', 'sector', 'country')) {

  # Confirm Bulk API Request
  etfReq = hlp_symbolCheck(etfs)

  if (missing(holding)) holding = 'symbol'
  if (!(holding %in% c('symbol', 'sector', 'country'))){
    stop('Holding must be one of the following: symbol, sector, or country')
  }

  holdReq = switch(holding, 'symbol' = 'holder', 'sector' = 'sector-weightings', 'country' = 'country-weightings')


  # Use custom function to collapse requests into data frame
  etf_df = data.frame(URL =  paste0('etf-',holdReq,'/',etfReq,'?'),
                      label = etfReq)
  etfDF = hlp_bindURLs(etf_df$URL, label_df = etf_df, label_name = 'etf')

  # Send warning for symbols not pulled
  hlp_respCheck(etfReq,etfDF$etf,'fmpc_holdings_etf: ')


  etfDF

}


