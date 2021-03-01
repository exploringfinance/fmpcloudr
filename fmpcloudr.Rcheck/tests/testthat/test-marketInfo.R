### Testing marketInfo functions:
# fmpc_symbols_by_market, fmpc_symbols_available, fmpc_symbol_search
# fmpc_symbols_index, fmpc_market_hours, fmpc_cusip_search
# fmpc_security_screener


# Basic Pulls using Validated API key
test_that("Test marketInfo with valid key", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))


  # Symbol Market
  symMrk = fmpc_symbols_by_market()
  expect_true(nrow(symMrk)>14000)
  expect_equal(length(unique(symMrk$market)),11)
  expect_equal(class(symMrk)[1],'tbl_df')
  symMrkIdx = fmpc_symbols_by_market('index')
  expect_true(nrow(symMrkIdx)>50)
  expect_warning(fmpc_symbols_by_market(c('test','index')))

  # Sym available
  symAva = fmpc_symbols_available()
  expect_true(nrow(symAva)>14000)
  expect_equal(class(symAva)[1],'tbl_df')

  # Sym Search
  symSearch = fmpc_symbol_search('tech')
  expect_equal(nrow(symSearch),10)
  expect_equal(ncol(symSearch),5)
  expect_equal(class(symSearch)[1],'tbl_df')
  BiggerSearch = fmpc_symbol_search('tech', 100)
  expect_equal(nrow(BiggerSearch),100)

  # Test index pull
  spcur = fmpc_symbols_index()
  expect_true(nrow(spcur)>500)
  expect_equal(class(spcur)[1],'tbl_df')
  expect_equal(ncol(spcur),8)
  sphis = fmpc_symbols_index('historical','nasdaq')
  expect_equal(class(sphis)[1],'tbl_df')
  expect_true(nrow(sphis)>200)
  expect_equal(ncol(sphis),7)

  # Test market hours
  MH = fmpc_market_hours()
  expect_equal(class(MH),'list')
  expect_equal(length(MH),2)
  expect_true(nrow(MH$holidays)>30)

  # Test CUSIP Pull
  CS = fmpc_cusip_search()
  expect_equal(class(CS)[1],'tbl_df')
  SPYCus = fmpc_cusip_search('78462F103')
  IVVCus = fmpc_cusip_search('464287200')

})

# Basic Pulls using Validated API key
test_that("Test stock sreener with valid key", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))

  default = fmpc_security_screener()
  expect_equal(nrow(default),100)
  def120 = fmpc_security_screener(limit = 120)
  expect_equal(nrow(def120),120)

  lrgMrkt = fmpc_security_screener(mrktCapAbove = 1e8)
  expect_true(min(lrgMrkt$marketCap) >= 1e8)
  smlMrkt = fmpc_security_screener(mrktCapBelow = 10000000)
  expect_true(max(smlMrkt$marketCap) <= 1e7)
  smlActvMrkt = fmpc_security_screener(mrktCapBelow = 10000000,volumeAbove = 1e6)
  expect_true(max(smlActvMrkt$marketCap) <= 1e7, min(smlActvMrkt$volume) > 1e6)

  HighDivLowVol = fmpc_security_screener(dividendAbove = 1, volumeBelow = 1e6)
  expect_true(max(HighDivLowVol$lastAnnualDividend) >= 1, min(smlActvMrkt$volume) < 1e6)

  LowDivHighBeta = fmpc_security_screener(dividendBelow = 1, betaAbove = 1)
  expect_true(max(LowDivHighBeta$lastAnnualDividend) <= 1, min(LowDivHighBeta$beta) > 1)

})
