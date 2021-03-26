#' Get list of COTS symbols
#'
#' Provides a list of all the symbols available on the Commitment of Traders
#' data pull
#'
#' @return a data frame of cots symbols with descriptions
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_cots_symbols()
#'
#' }
fmpc_cots_symbols <- function() {

  # Make GET request
  Result <- fmpc_get_url('commitment_of_traders_report/list?', api_version = '4')
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}



#' Get COTS data
#'
#' Provides raw data from Commitment of Traders report
#'
#' @inheritParams fmpc_price_history
#' @param type 'report' is the raw data, 'analysis' is analysis of raw reports
#' @param cots_sym COTS symbol that can be found in
#'   \code{\link{fmpc_cots_symbols}}. Default is 'all'. Date parameters are only
#'   valid with 'all'. Otherwise the full history is pulled.
#'
#' @return a data frame of cots data
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_cots_data()
#' fmpc_cots_data('gc','analysis')
#'
#' }
fmpc_cots_data <- function(cots_sym = 'all',
                           type = c('report','analysis'),
                           startDate = Sys.Date()-30,
                           endDate = Sys.Date()) {

  # Determine symbol
  if(missing(type)) type = ''
  if(type != 'analysis'){type = ''}else{type = '_analysis'}
  symb_sub = ifelse(cots_sym=='all','',paste0('/',toupper(cots_sym)))

  # Make GET request
  Result <- fmpc_get_url(paste0('commitment_of_traders_report',type,symb_sub,'?from=',startDate,'&to=',endDate,'&'), api_version = '4')
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}



#' ETF List
#'
#' Provides a list of all ETFs
#'
#'
#' @return a data frame of ETFs
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_etf_list()
#'
#' }
fmpc_etf_list <- function() {


  # Make GET request
  Result <- fmpc_get_url('etf/list?')
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}
