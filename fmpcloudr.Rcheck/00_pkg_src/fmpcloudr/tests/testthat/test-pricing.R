### Testing pricing functions:
# fmpc_price_history, fmpc_price_history_spldiv, fmpc_price_intraday,
# fmpc_price_batch_eod, fmpc_price_current, fmpc_price_full_market, fmpc_price_forex


# Basic Pulls using Validated API key
test_that("Test small sample of prices", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))

  symbols = c('AAPL','SPY','SWTSX','SPY')
  fails = c('NOTREAL')
  indexes = c('^SP500TR','BTCUSD','JPYUSD')
  symwErr = c(symbols,fails,indexes)
  allSymbs = c(symbols,indexes)
  symCt = length(unique(symbols))

  # Test Historical Price
  expect_warning(fmpc_price_history(symwErr))                    # Warning for fail symbols
  hp = fmpc_price_history(allSymbs)
  # ---------- Standard across pricing functions
  expect_equal(class(hp)[1],'tbl_df')                           # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hp,symbol,date)), nrow(hp)) # Verify duplicate requests are dropped
  expect_equal(unique(hp$symbol), unique(allSymbs))             # Should include indexes and symbols
  # ---------- Specific to pricing function
  expect_equal(ncol(hp), 14)                                    # check 14 columns returned
  Numticks = length(unique(hp$symbol))
  expect_true(nrow(hp) >= 19*Numticks & nrow(hp)<=24*Numticks)    # check roughly one month returned
  hp = fmpc_price_history(allSymbs, startDate = '2000-01-01',    # Pull big history file
                                    endDate = Sys.Date())
  expect_equal(min(hp$date),as.Date('2000-01-03'))              # Min date should be 1/3/2000
  expect_true(max(hp$date)>Sys.Date()-5)                        # Max Date should be within last 5 days
  TrdDays = as.numeric(Sys.Date() - as.Date('2000-01-01'))
  expect_true(nrow(hp) > TrdDays/365*251)                       # 251 trading days on average

  # ========== End fmpc_price_history ===========


  # Test Historical Price, dividend, and splits
  expect_warning(object = (hpsd = fmpc_price_history_spldiv(symwErr)))  # Warning for fails and index/no split symbols
  # ---------- Standard across pricing functions
  expect_equal(class(hpsd)[1],'tbl_df')                         # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hpsd)), nrow(hpsd))         # Verify duplicate requests are dropped
  expect_equal(sort(unique(hpsd$symbol)),
               sort(unique(c(symbols,indexes))))                # Should include indexes and symbols
  # ---------- Specific to pricing function
  expect_equal(ncol(hpsd), 20)                                   # check 16 columns returned
  expect_match(paste0(colnames(hpsd),collapse=''),'adjDividend') # adjDividend should appear in merged data set
  expect_match(paste0(colnames(hpsd),collapse=''),'splitFactor') # splitFactor should appear in merged data set

  # ========== End fmpc_price_history_spldiv ===========


  # Test Intraday
  expect_warning(fmpc_price_intraday(symwErr, freq = '1hour'))   # Warning for fail symbols
  expect_error(fmpc_price_intraday(allSymbs, freq = '2hours'))
  intra = fmpc_price_intraday(allSymbs, freq = '1hour')
  # ---------- Standard across pricing functions
  expect_equal(class(intra)[1],'tbl_df')                        # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(intra)), nrow(intra))       # Verify duplicate requests are dropped
  expect_equal(sort(unique(intra$symbol)),
               sort(unique(c(symbols,indexes))))                # Should include indexes and symbols
  expect_equal(ncol(intra), 8)                                     # check 8 columns returned
  expect_equal(as.numeric(intra$dateTime[2] - intra$dateTime[1]), 1)  # Check 1 hour difference
  intra2 = fmpc_price_intraday(allSymbs, freq = '5min',
                                         startDate = Sys.Date()-60)   # Run for 15 minute difference and 60 days
  expect_equal(as.numeric(intra2$dateTime[2] - intra2$dateTime[1]), 5) # Check 1 hour difference
  # expect_true(as.numeric(Sys.Date()-intra2$date[1]) < 15)           # At 15 minute increments, only about 12 days are returned
  # ========== End fmpc_price_intraday ===========


  # Test current price
  expect_warning(fmpc_price_current(symwErr))
  CurPrice = fmpc_price_current(allSymbs)
  expect_equal(class(CurPrice)[1],'tbl_df')
  expect_equal(ncol(CurPrice), 22)                                    # confirm 22 columns
  expect_equal(nrow(CurPrice),length(unique(c(symbols,indexes))))     # confirm 1 row per
  # ========== End fmpc_price_current ===========


  ##### No CRAN

  # Test full close pull
  histDaySymb = fmpc_price_batch_eod('2020-06-24')
  expect_equal(class(histDaySymb)[1],'tbl_df')
  expect_true(nrow(histDaySymb) > 10000)
  expect_equal(ncol(histDaySymb), 8)




  # Test current price for market
  idxMrkt = fmpc_price_full_market('index')
  expect_true(nrow(idxMrkt)>25)
  expect_equal(class(histDaySymb)[1],'tbl_df')
  expect_equal(ncol(idxMrkt), 22)
  etfMrkt = fmpc_price_full_market('etf')
  expect_true(nrow(etfMrkt)>25)
  commMrkt = fmpc_price_full_market('commodity')
  expect_true(nrow(commMrkt)>25)
  currMrkt = fmpc_price_full_market('forex')
  expect_true(nrow(currMrkt)>25)
  mfmrkt = fmpc_price_full_market('mutual_fund')
  expect_true(nrow(mfmrkt)>25)
  expect_error(fmpc_price_full_market('currency'))

  # Test fprex
  fxQt = fmpc_price_forex()
  expect_equal(class(fxQt)[1],'tbl_df')
  expect_true(nrow(fxQt) > 100)
  expect_equal(ncol(fxQt), 8)

})


test_that("Test price request for 100", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'), noBulkWarn = T)


  fmpc_limit_warn <- getOption("fmpc_limit_warn")
  skip_if(is.null(fmpc_limit_warn) | fmpc_limit_warn != 'testLarge', message = 'Skipping large API pulls')
  # skip_if(fmpc_limit_warn != 'testLarge', message = 'Skipping large API pulls')
  ### Make large API requests
  spcur = fmpc_symbols_index()
  symMrkIdx = fmpc_symbols_by_market('index')
  SP100 = fmpc_price_history(spcur$symbol[1:100])
  expect_equal(length(unique(SP100$symbol)),100)
  expect_warning(object=(IndxPull = fmpc_price_history(symMrkIdx$symbol)))
  expect_true(length(unique(IndxPull$symbol))>50)

})



# Basic Pulls using DEMO API key
test_that("Test pricing with Demo", {

  # Set Token to DEMO
  # This can be done on CRAN
  expect_warning(fmpc_set_token())
  skip_on_cran()

  symbols = c('AAPL')
  fails = c('NOTREAL')
  indexes = c(NULL)
  symwErr = c(symbols,fails,indexes)
  allSymbs = c(symbols,indexes)
  symCt = length(unique(symbols))

  # Test Historical Price
  expect_warning(fmpc_price_history(symwErr))                    # Warning for fail symbols
  hp = fmpc_price_history(allSymbs)
  # ---------- Standard across pricing functions
  expect_equal(class(hp)[1],'tbl_df')                           # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hp,symbol,date)), nrow(hp)) # Verify duplicate requests are dropped
  expect_equal(unique(hp$symbol), unique(allSymbs))             # Should include indexes and symbols
  # ---------- Specific to pricing function
  expect_equal(ncol(hp), 14)                                    # check 14 columns returned
  Numticks = length(unique(hp$symbol))
  expect_true(nrow(hp) > 16*Numticks & nrow(hp)<25*Numticks)    # check roughly one month returned
  hp = fmpc_price_history(allSymbs, startDate = '2000-01-01',    # Pull big history file
                         endDate = Sys.Date())
  expect_equal(min(hp$date),as.Date('2000-01-03'))              # Min date should be 1/3/2000
  expect_true(max(hp$date)>Sys.Date()-5)                        # Max Date should be within last 5 days
  TrdDays = as.numeric(Sys.Date() - as.Date('2000-01-01'))
  expect_true(nrow(hp) > TrdDays/365*251)                       # 251 trading days on average

  # ========== End fmpc_price_history ===========


  # Test Historical Price, dividend, and splits
  expect_warning(object = (hpsd = fmpc_price_history_spldiv(symwErr)))  # Warning for fails and index/no split symbols
  # ---------- Standard across pricing functions
  expect_equal(class(hpsd)[1],'tbl_df')                         # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(hpsd)), nrow(hpsd))         # Verify duplicate requests are dropped
  expect_equal(sort(unique(hpsd$symbol)),
               sort(unique(c(symbols,indexes))))                # Should include indexes and symbols
  # ---------- Specific to pricing function
  expect_equal(ncol(hpsd), 20)                                   # check 16 columns returned
  expect_match(paste0(colnames(hpsd),collapse=''),'adjDividend') # adjDividend should appear in merged data set
  expect_match(paste0(colnames(hpsd),collapse=''),'splitFactor') # splitFactor should appear in merged data set

  # ========== End fmpc_price_history_spldiv ===========


  # Test Intraday
  expect_warning(fmpc_price_intraday(symwErr, freq = '1hour'))   # Warning for fail symbols
  expect_error(fmpc_price_intraday(allSymbs, freq = '2hours'))
  intra = fmpc_price_intraday(allSymbs, freq = '1hour')
  # ---------- Standard across pricing functions
  expect_equal(class(intra)[1],'tbl_df')                        # confirm object is a tibble
  expect_equal(nrow(dplyr::distinct(intra)), nrow(intra))       # Verify duplicate requests are dropped
  expect_equal(sort(unique(intra$symbol)),
               sort(unique(c(symbols,indexes))))                # Should include indexes and symbols
  expect_equal(ncol(intra), 8)                                     # check 8 columns returned
  expect_equal(as.numeric(intra$dateTime[2] - intra$dateTime[1]), 1)  # Check 1 hour difference
  intra2 = fmpc_price_intraday(allSymbs, freq = '5min',
                              startDate = Sys.Date()-60)   # Run for 15 minute difference and 60 days
  expect_equal(as.numeric(intra2$dateTime[2] - intra2$dateTime[1]), 5) # Check 1 hour difference
  # expect_true(as.numeric(Sys.Date()-intra2$date[1]) < 15)           # At 15 minute increments, only about 12 days are returned
  # ========== End fmpc_price_intraday ===========


  # Test current price
  expect_warning(fmpc_price_current(symwErr))
  CurPrice = fmpc_price_current(allSymbs)
  expect_equal(class(CurPrice)[1],'tbl_df')
  expect_equal(ncol(CurPrice), 22)                                    # confirm 22 columns
  expect_equal(nrow(CurPrice),length(unique(c(symbols,indexes))))     # confirm 1 row per
  # ========== End fmpc_price_current ===========

})




