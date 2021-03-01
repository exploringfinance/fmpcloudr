#' Dates related to Economic data, IPOs, dividends, earnings, and splits
#'
#' Calendar dates related to Economic data, IPOs, dividends, earnings, and
#' splits
#'
#' @param calendar indicate which calendar to view. Options include 'ipo',
#'   'stock_split', 'stock_dividend', 'earning',or 'economic'
#' @inheritParams fmpc_price_history
#'
#' @return calendar events
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' fmpc_calendar_events('stock_split')
#' fmpc_calendar_events('economic')
#' }
fmpc_calendar_events <- function(calendar = 'economic',
                                 startDate = Sys.Date()-180,
                                 endDate = Sys.Date()) {

  calendars = c('economic', 'ipo', 'stock_split', 'stock_dividend', 'earning')
  if (!(calendar %in% calendars)) {
    stop('calendar must be one of: ',paste0(calendars, collapse = ', '), call. = FALSE)
  }

  # Build URL and Make GET request
  URL = paste0(calendar,'_calendar?from=',startDate,'&to=',endDate,'&')
  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)

  # Return result
  dplyr::as_tibble(Result)
}

#' List economic events that can be searched
#'
#' Shows the economic events that can be fed into
#' \code{\link{fmpc_economic_results}}
#'
#'
#' @return economic metrics
#' @export
#'
#' @examples
#' \dontrun{
#' # Function can work without a valid API token
#'  fmpc_set_token('FMPAPIKEY')
#' fmpc_economic_events()
#' }
fmpc_economic_events <- function() {

  # Make GET request
  Result <- fmpc_get_url('economic_calendar_event_list?')
  Result <- hlp_chkResult(Result)

  # Return result as tibble
  dplyr::as_tibble(Result)
}

#' Economic results
#'
#' Shows the results of the economic events from
#' \code{\link{fmpc_economic_events}}
#'
#' @param event an economic event from \code{\link{fmpc_economic_events}}
#' @param country a country from \code{\link{fmpc_economic_events}}
#' @inheritParams fmpc_price_history
#'
#' @return calendar events
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Must set a valid API token
#' fmpc_set_token('FMPAPIKEY')
#' Events = fmpc_economic_events()
#' fmpc_economic_results()
#'
#' # Italy three month interbank rate
#' fmpc_economic_results(event = Events[100,1], country = Events[100,2])
#'
#' # Consumer credit - RS
#' fmpc_economic_results(event = Events[1000,1], country = Events[1000,2])
#'
#'
#' }
fmpc_economic_results <- function(event = 'adpEmploymentChange',
                                  country = 'US',
                                  startDate = Sys.Date()-180,
                                  endDate = Sys.Date()) {

  # Build URL and Make GET request
  URL = paste0('historical/economic_calendar/',event,'?country=',country,'&')

  Result <- fmpc_get_url(URL)
  Result <- hlp_chkResult(Result)

  # Return result
  dplyr::as_tibble(Result)
}

