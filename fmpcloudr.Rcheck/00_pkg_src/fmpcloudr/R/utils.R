
# Basic NA Check and replace
if.na <- function(x,y)(ifelse(is.na(x),y,x))

# Stop if missing match
hlp_select = function(select,options) {
  if (!(select %in% options)) {
    stop('Please enter a statment value of: ',paste0(options, collapse = ', '), call. = FALSE)
  }
}



# --------- Helper Function 1 - Validate return against request ----------
# Set warning to all symbols that did not return anything
hlp_respCheck = function(req,resp,msg='') {

  # Flip Indexes back to ^
  req = toupper(gsub('%5E','\\^',req))

  # If length is 0, everything is missing
  if (length(resp)==0) {
    missing = req
    } else {
    # Check symbols missing from response in req
    missing = req[which(!(gsub('/','',req) %in% gsub('/','',resp)))]
    }

  # If populated send a warning
  if (length(missing)>0) {
    missSymb = paste0(missing,collapse = ', ')
    warning(paste0(msg,'The following request(s) returned no results: ',missSymb,'.'),
            call. = FALSE)
  }

}


# --------- Helper Function 2 - Confirm number of requests ----------
# Confirm user wants to make bulk API request
hlp_symbolCheck = function(symbols) {

  # Check if request is for more than 10 symbols
  unqSymbs =  unique(toupper(gsub('\\^','%5E',symbols)))
  reqs = length(unqSymbs)
  if (reqs > 10) {

    # See if user requested to suppress warning
    fmpc_limit_warn <- getOption("fmpc_limit_warn")

      # If user wishes to suppress warning return or is not interactive then run query
      if (is.null(fmpc_limit_warn) & interactive()) {

      ChkReq = utils::menu(c('Allow Once','Allow and suppress this warning for session','Cancel request'),
                           title = paste('Your request will generate at least',reqs,'API request.',
                                         'How would you like to handle this? (Note: You can suppress this',
                                         'warning going forward by setting "noBulkWarn = TRUE" in the',
                                         'fmpc_set_token function.', sep = ' '))
      if (ChkReq == 3) stop('Request cancelled', call. = FALSE)
      if (ChkReq == 2) options(fmpc_limit_warn = 'suppress')
    }


  }

  unqSymbs


}

# --------- Helper Function 3 - Confirm result from request ----------
# Check results were returned and no errors
hlp_chkResult = function(result) {

  # If nothing returned, return NULL
  if(length(result) == 0) return(NULL)

  # Collapse list names into a string
  chkErr = paste0(ls(result),collapse = ' ')

  # If error message appears then send as warning and return NULL
  if (grepl('error',tolower(chkErr))) {
    errMsg = result$`Error Message`
    if (is.null(errMsg)) errMsg = result$error

    # Too many requests gets a warning
    if (grepl('Too Many Requests',errMsg)) {
      errMsg = paste0(errMsg,
                      '. You can also use fmpcloudr::fmpc_set_token to increase time between API Calls ',
                      'by setting the argument "timeBtwnReq".')
      stop(errMsg, call. = FALSE)
    } else if (grepl('Invalid API KEY',errMsg)) {
    # Invalid API KEY has a warning
      warning(paste0('Invalid API Key. Use fmpcloudr::fmpc_set_token() to set a valid key. If you do not ',
                  'have an API key, visit https://fmpcloud.io to create a FREE key.'), call. = FALSE)
    } else {
    # Otherwise give warning with FMP error message
    warning(errMsg, call. = FALSE)

    }
    return(NULL)
  }

  # Return result if no issues
  result

}


# ------- Function 4 - Price Helper Function -----------
# Helper function for historical data - pulls single symbol to get history from list
hlp_symbolHistory <- function(symbol = 'AAPL',
                              url = 'historical-price-full/',
                              startDate = Sys.Date()-30,
                              endDate = Sys.Date()) {

  # Create URL for function for single symbol
  URL <- paste0(url,symbol,'?from=',startDate,'&to=',endDate,'&')

  # Make Get request
  result <- fmpc_get_url(URL)

  # Check result for errors and NULL
  result <- hlp_chkResult(result)
  if (is.null(result$historical)) return(NULL)

  # Add symbol to column in the data frame and set date as date class
  df = result$historical
  df$symbol = gsub('/','',result$symbol) # remove /
  df$date = as.Date(df$date)

  # Modify data
  return = dplyr::relocate(df,symbol) %>%
    dplyr::as_tibble() %>%
    dplyr::arrange(symbol,date)

  # Return Data frame of symbol data
  return
}


# ------- Function 5 - Bind lapply function -----------
# Helper function for historical data - pulls single symbol
hlp_bindURLs <- function(URLs, label_df = NULL, label_name = NULL){

  # Run lapply over list of URLs to bind them and label with name
  bindedDF = dplyr::bind_rows(lapply(URLs,
                                     function(x) {
                                       # Build URL
                                       URL = x

                                       # Make GET Request
                                       Result <- fmpc_get_url(URL)
                                       Result <- hlp_chkResult(Result)

                                       if (is.null(Result)) return(NULL)

                                       # If label name does not already exist and is passed, then add
                                       if (!is.null(label_df)) {
                                         if(!(label_name %in% colnames(Result))) {
                                         Result$label = label_df$label[label_df$URL == URL]
                                         colnames(Result)[colnames(Result)=='label'] <- label_name
                                         }
                                         }



                                       Result
                                     }))

  if(length(bindedDF)==0) return(NULL)
  dplyr::as_tibble(bindedDF)

}

