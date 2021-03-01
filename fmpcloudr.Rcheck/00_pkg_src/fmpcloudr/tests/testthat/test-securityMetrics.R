### Testing securityMetric functions:
# fmpc_security_splits, fmpc_security_dividends, fmpc_security_sector
# fmpc_security_profile, fmpc_security_gla, fmpc_security_tech_indic


# Basic Pulls using Validated API key
test_that("Test securityMetrics with valid key", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))

  splSym = c('AAPL','TQQQ')
  symbols = c('AAPL','SPY','SWTSX','SPY')
  fails = c('NOTREAL')
  indexes = c('^SP500TR','BTCUSD','JPYUSD')
  symwErr = c(symbols,fails,indexes)
  allSymbs = c(symbols,indexes)
  symCt = length(unique(symbols))

  # Test Historical Splits
  expect_warning(fmpc_security_splits(symwErr,startDate = '2014-01-01'))
  hs = fmpc_security_splits(splSym, startDate = '2014-01-01') # Warning for fail symbols
  # ---------- Standard across pricing functions
  expect_equal(class(hs)[1],'tbl_df')                           # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hs)), nrow(hs))             # Verify duplicate requests are dropped
  expect_true(unique(unique(hs$symbol) %in% c(splSym)))        # Should only include symbols, not indexes
  # ---------- Specific to pricing function
  expect_true(nrow(hs)>=2)                                      # check for at least 2 splits
  # ========== End fmpc_security_splits ===========


  # Test Historical Divdends
  expect_warning(fmpc_security_dividends(symwErr,startDate = '2014-01-01'))
  hdiv = fmpc_security_dividends(symbols, startDate = '2014-01-01')

  # ---------- Standard across pricing functions
  expect_equal(class(hdiv)[1],'tbl_df')                           # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hdiv)), nrow(hdiv))             # Verify duplicate requests are dropped
  expect_true(unique(unique(hdiv$symbol) %in% c(symbols)))        # Should only include symbols, not indexes
  # ---------- Specific to pricing function
  expect_true(nrow(hdiv)>=60)                                     # check for at least 27 Div payments
  # ========== End fmpc_security_dividends ===========


  # Test Profile
  expect_warning(fmpc_security_profile(allSymbs))
  prof = fmpc_security_profile(splSym)
  expect_true(ncol(prof) > 30)                                    # confirm 30+ columns
  expect_equal(nrow(prof), 2)


  # Test Sector pull
  sectors = fmpc_security_sector(30)
  expect_equal(length(unique(sectors$sector)),15)
 # expect_equal(length(unique(sectors$date)),30)

  # Gainers and loses
  Gner = fmpc_security_gla('gainers')
  expect_equal(ncol(Gner), 5)
  expect_equal(nrow(Gner), 30)
  Lser = fmpc_security_gla('losers')
  Actv = fmpc_security_gla('actives')
  expect_error(fmpc_security_gla('active'))


})


# Basic Pulls using Validated API key
test_that("Test securityMetrics with demo", {

  # Set Token to FMP token
  # This can be done on CRAN
  skip_on_cran()
  expect_warning(fmpc_set_token())

  splSym = c('AAPL')
  symbols = c('AAPL')
  fails = c('NOTREAL')
  indexes = c(NULL)
  symwErr = c(symbols,fails,indexes)
  allSymbs = c(symbols,indexes)
  symCt = length(unique(symbols))

  # Test Historical Splits
  expect_warning(fmpc_security_splits(symwErr,startDate = '2014-01-01'))
  hs = fmpc_security_splits(splSym, startDate = '2014-01-01') # Warning for fail symbols
  # ---------- Standard across pricing functions
  expect_equal(class(hs)[1],'tbl_df')                           # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hs)), nrow(hs))             # Verify duplicate requests are dropped
  expect_true(unique(unique(hs$symbol) %in% c(splSym)))        # Should only include symbols, not indexes
  # ---------- Specific to pricing function
  expect_true(nrow(hs)>=2)                                      # check for at least 2 splits
  # ========== End fmpc_security_splits ===========


  # Test Historical Divdends
  expect_warning(fmpc_security_dividends(symwErr,startDate = '2014-01-01'))
  hdiv = fmpc_security_dividends(symbols, startDate = '2014-01-01')

  # ---------- Standard across pricing functions
  expect_equal(class(hdiv)[1],'tbl_df')                           # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hdiv)), nrow(hdiv))             # Verify duplicate requests are dropped
  expect_true(unique(unique(hdiv$symbol) %in% c(symbols)))        # Should only include symbols, not indexes
  # ---------- Specific to pricing function
  expect_true(nrow(hdiv)>=20)                                     # check for at least 20 Div payments
  # ========== End fmpc_security_dividends ===========


  # Test Profile
  expect_warning(fmpc_security_profile(symwErr))
  prof = fmpc_security_profile(splSym)
  expect_true(ncol(prof) > 30)                                    # confirm 30+ columns
  expect_equal(nrow(prof), 1)


})


######### TEST TECHNICAL INDICATORS

test_that("Technical Indicators", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'),timeBtwnReq = .2)

  symbols = c('AAPL','SPY')

  # Test etechnical indicators
  sma = fmpc_security_tech_indic(symbols,
                             indicator = 'SMA',
                             freq = 'daily',
                             period = 10)
  expect_true(nrow(sma) > 10)
  expect_match(paste0(colnames(sma),collapse=''),'sma')

  ema = fmpc_security_tech_indic(symbols,
                             indicator = 'EMA',
                             freq = 'daily', #'1min',
                             period = 10)
  expect_true(nrow(ema) > 10)
  expect_match(paste0(colnames(ema),collapse=''),'ema')

  wma = fmpc_security_tech_indic(symbols,
                             indicator = 'WMA',
                             freq = 'daily', #'5min',
                             period = 10)
  expect_true(nrow(wma) > 10)
  expect_match(paste0(colnames(wma),collapse=''),'wma')

  dema = fmpc_security_tech_indic(symbols,
                              indicator = 'dema',
                              freq = 'daily', #'30min',
                              period = 10)
  expect_true(nrow(dema) > 10)
  expect_match(paste0(colnames(dema),collapse=''),'dema')

  tema = fmpc_security_tech_indic(symbols,
                              indicator = 'Tema',
                              freq = 'daily', #'1hour',
                              period = 10)
  expect_true(nrow(tema) > 10)
  expect_match(paste0(colnames(tema),collapse=''),'tema')

  will = fmpc_security_tech_indic(symbols,
                              indicator = 'Williams',
                              freq = 'daily', #'4hour',
                              period = 10)
  expect_true(nrow(will) > 10)
  expect_match(paste0(colnames(will),collapse=''),'williams')

  adx = fmpc_security_tech_indic(symbols,
                             indicator = 'adx',
                             freq = 'daily', #
                             period = 10)
  expect_true(nrow(adx) > 10)
  expect_match(paste0(colnames(adx),collapse=''),'adx')

  sd = fmpc_security_tech_indic(symbols,
                            indicator = 'StandardDeviation',
                            freq = 'daily', #'4hour',
                            period = 10)
  expect_true(nrow(sd) > 10)
  expect_match(paste0(colnames(sd),collapse=''),'standardDeviation')

  rsi = fmpc_security_tech_indic(symbols,
                             indicator = 'rsi',
                             freq = 'daily',
                             period = 14)
  expect_true(nrow(rsi) > 10)
  expect_match(paste0(colnames(rsi),collapse=''),'rsi')

  expect_error(TItest = fmpc_security_tech_indic(symbols,indicator = 'test'))

  # ========== End tech inciators ===========

#   sd = fmpc_security_tech_indic('AAPL',
#                             indicator = 'StandardDeviation',
#                             freq = 'daily',
#                             period = 10)
# library(dplyr)
#   fmpc_price_history('AAPL') %>%
#     arrange(desc(date)) %>%
#     mutate(LogRet = log(adjClose/lead(adjClose)),
#            RN = row_number()) %>%
#     filter(RN<=10) %>%
#     mutate(sd = sd(LogRet),
#            sdch = sd(changePercent),
#            sdsim = sd(exp(LogRet)-1))


})

test_that("Technical Indicators on CRAN", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  expect_warning(fmpc_set_token())

  symbols = c('AAPL')

  # Test etechnical indicators
  sma = fmpc_security_tech_indic(symbols,
                             indicator = 'SMA',
                             freq = 'daily',
                             period = 10)
  expect_true(nrow(sma) > 10)
  expect_match(paste0(colnames(sma),collapse=''),'sma')

  ema = fmpc_security_tech_indic(symbols,
                             indicator = 'EMA',
                             freq = '1min',
                             period = 10)
  expect_true(nrow(ema) > 10)
  expect_match(paste0(colnames(ema),collapse=''),'ema')

  wma = fmpc_security_tech_indic(symbols,
                             indicator = 'WMA',
                             freq = 'daily',
                             period = 10)
  expect_true(nrow(wma) > 10)
  expect_match(paste0(colnames(wma),collapse=''),'wma')

  dema = fmpc_security_tech_indic(symbols,
                              indicator = 'dema',
                              freq = 'daily',
                              period = 10)
  expect_true(nrow(dema) > 10)
  expect_match(paste0(colnames(dema),collapse=''),'dema')

  tema = fmpc_security_tech_indic(symbols,
                              indicator = 'Tema',
                              freq = 'daily',
                              period = 10)
  expect_true(nrow(tema) > 10)
  expect_match(paste0(colnames(tema),collapse=''),'tema')

  will = fmpc_security_tech_indic(symbols,
                              indicator = 'Williams',
                              freq = 'daily',
                              period = 10)
  expect_true(nrow(will) > 10)
  expect_match(paste0(colnames(will),collapse=''),'williams')

  adx = fmpc_security_tech_indic(symbols,
                             indicator = 'adx',
                             freq = 'daily',
                             period = 10)
  expect_true(nrow(adx) > 10)
  expect_match(paste0(colnames(adx),collapse=''),'adx')

  sd = fmpc_security_tech_indic(symbols,
                            indicator = 'StandardDeviation',
                            freq = 'daily', #'1hour',
                            period = 10)
  expect_true(nrow(sd) > 10)
  expect_match(paste0(colnames(sd),collapse=''),'standardDeviation')

  rsi = fmpc_security_tech_indic(symbols,
                             indicator = 'rsi',
                             freq = 'daily',
                             period = 14)
  expect_true(nrow(rsi) > 10)
  expect_match(paste0(colnames(rsi),collapse=''),'rsi')

  # ========== End tech inciators ===========



})

