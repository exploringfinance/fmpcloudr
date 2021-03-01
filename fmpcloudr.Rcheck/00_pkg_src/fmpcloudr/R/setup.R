#' Set FMP Token for all other functions
#'
#' Pass a valid FMP API Token to enable all other functions
#'
#' In order to use the FMP Cloud API, an account must be created at
#' \href{https://fmpcloud.io/}{FMP Cloud}. There is a free account option
#' that but sets a cap at 250 calls. There are different subscription levels. To
#' use this package, the free subscription can be used up to the limit.
#'
#' Please note that most functions will make an individual API call for each
#' symbol passed. If running a function on multiple symbols, be aware this could
#' quickly hit API call limits. When running in an interactive environment, a
#' warning will appear asking to confirm running bulk requests. This can be
#' suppressed for a session using the options. You can also suppress when using
#' the option noBulkWarn = TRUE in this function. When running in a non
#' interactive environment like CRON, the bulk request will be processed without
#' a warning regardless.
#'
#' @param APIToken a valid API Token from FMP Cloud
#' @param timeBtwnReq Time between API calls in seconds. FMP Cloud may limit API
#'   call frequency depending on the package subscription. Use this to set a
#'   time between API calls. The default is .1 to limit calls to no more than 10
#'   per second.
#' @param noBulkWarn Boolean of TRUE or FALSE. When making large API calls, an
#'   initial warning will be given to make sure the user wants to make bulk
#'   requests. If the user has a FREE FMP API a bulk request may be
#'   undesirable. Each symbol requested for many functions will be a unique
#'   API request. Use this parameter to silence this warning.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Set the FMP Token. The DEMO token has VERY limited access.
#' fmpc_set_token('demo', timeBtwnReq = 0, noBulkWarn = TRUE)
#' }
fmpc_set_token = function(APIToken='demo', timeBtwnReq = .1, noBulkWarn = FALSE) {

  # Warn that demo has very minimal access
  if (APIToken == 'demo') {
    warning(paste0('Only very limted data can be pulled using "demo". It is advised to ',
                   'register a free token on https://fmpcloud.io/ to take advantage ',
                   'of the functions in this package.'), call. = FALSE)
  }

  # Allow user to suppress bulk message warning/prompt when setting token
  if (noBulkWarn) options(fmpc_limit_warn = 'suppress')

  # Set FMP token into options
  options(fmpc_API_token = APIToken)

  # Set time between requests
  options(fmpc_API_buffer = timeBtwnReq)

}




#' GET Request for specific URL
#'
#' FMP helper function that takes a URL, appends the API Token, makes a GET
#' call, and parses the data
#'
#' This function is a helper in most other fmpcloudr functions, so does not need
#' to be used by the end user. That being said, FMP is always adding data with
#' new URLs. If this package does not have a URL available on FMP, this function
#' can be used to simplify the GET call. Pass the URL appearing after 'api/v3'
#' with the search parameters entered, but do not include the API token
#'
#' @param URL The URL to pull specific data from FMP Cloud. Search parameters
#'   should be included, but not the API key. Start with the URL after 'api/v3'
#' @param api_version The API version of the URL. FMP is constantly updating
#'   their API and new URLs may be under anew version
#'
#' @return list output of data set
#' @export
#'
#' @examples
#' \dontrun{
#' # Set the FMP Token. The DEMO token has VERY limited access.
#' fmpc_set_token('demo')
#'
#' # Pull price history for Apple
#' AppleHist = fmpc_get_url('historical-price-full/AAPL?serietype=line&')
#' }
fmpc_get_url = function(URL, api_version = '3'){

  # Get FMP token from options
  fmpc_api <- getOption("fmpc_API_token")

  # Check for API Token
  if (is.null(fmpc_api)) {
    stop('FMP API token has not been set. Use fmpc_set_token to set the API token.', call. = FALSE)
  }

  # Ensure API token is not being passed
  if (grepl('apikey',tolower(URL))) {
    stop('Do not pass an API token into this function. Set it using fmpc_set_token', call. = FALSE)
  }

  # Create URL
  pullURL = paste0('https://fmpcloud.io/api/v',api_version,'/',URL,'apikey=',fmpc_api)

  # Make request for JSON return
  result <- httr::GET(url = pullURL,
                      httr::add_headers(.headers=c(`Upgrade-Insecure-Requests` = '1')),
                      query = list(datatype='json'))

  # Add Time between API Calls
  BufferTime <- getOption("fmpc_API_buffer")
  if (is.null(BufferTime)) BufferTime <- .1
  Sys.sleep(BufferTime)

  # extract content and return JSON
  jsonrst <- httr::content(result, as = "text")
  jsonrst <- jsonlite::fromJSON(jsonrst)

  jsonrst

}

