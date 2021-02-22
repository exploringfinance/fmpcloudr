### Testing calendar functions:
# fmpc_13f_cik_list, fmpc_13f_cik_search, fmpc_13f_cik_name
# fmpc_13f_data, fmpc_rss_sec, fmpc_holdings_etf, fmpc_held_by_mfs

# Basic Pulls using Validated API key
test_that("Test holding with API", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))

  # Get CIK list
  cikList = fmpc_13f_cik_list()
  expect_equal(ncol(cikList),2)
  expect_true(nrow(cikList)>1000)
  expect_equal(class(cikList)[1],'tbl_df')

  # Get CIK list search
  Mor = fmpc_13f_cik_search('Gold')
  MS = fmpc_13f_cik_search('Goldman S')
  expect_equal(ncol(Mor),2)
  expect_true(nrow(Mor)>nrow(MS))
  expect_equal(class(Mor)[1],'tbl_df')


  # Check Cik Name pull by cik
  cikNm = fmpc_13f_cik_name(cik = Mor$cik)
  expect_equal(ncol(Mor),2)
  expect_true(nrow(cikNm)>=nrow(Mor))

  # Pull 13F data
  expect_warning(fmpc_13f_data(cik = Mor$cik, date = c('2020-03-31','2020-06-30')))
  F13 = fmpc_13f_data(cik = MS$cik, date = c('2020-03-31','2019-12-31'))
  expect_equal(ncol(F13),12)
  expect_true(nrow(F13)>4000)
  expect_equal(class(F13)[1],'tbl_df')

  # Rss check
  rss = fmpc_rss_sec()
  expect_equal(ncol(rss),6)
  expect_true(nrow(rss)==100)
  expect_equal(class(F13)[1],'tbl_df')
  rss120 = fmpc_rss_sec(120)
  expect_true(nrow(rss120)==120)


  # Mutual fund holdings
  expect_warning(fmpc_held_by_mfs('SPY')) # No ETFs
  AMG = fmpc_held_by_mfs(c('AAPL','MSFT','GOOGL'))
  expect_equal(ncol(AMG),6)
  expect_true(nrow(AMG)>6000)
  expect_equal(class(AMG)[1],'tbl_df')

  # ETF Holdings
  expect_warning(fmpc_holdings_etf('DBOC'))
  expect_warning(fmpc_holdings_etf('TQQQ','country'))
  expect_warning(fmpc_holdings_etf('DBOC', 'sector'))
  Sym = fmpc_holdings_etf(c('SPY','TQQQ','NJAN'), 'symbol')
  expect_equal(ncol(Sym),4)
  expect_true(nrow(Sym)>500)
  expect_equal(class(Sym)[1],'tbl_df')
  Sector = fmpc_holdings_etf(c('SPY','EFA'), 'sector')
  expect_equal(ncol(Sector),3)
  expect_true(nrow(Sector)>15)
  Country = fmpc_holdings_etf(c('SPY','EFA'), 'country')
  expect_equal(ncol(Country),3)
  expect_true(nrow(Country)>10)


})
