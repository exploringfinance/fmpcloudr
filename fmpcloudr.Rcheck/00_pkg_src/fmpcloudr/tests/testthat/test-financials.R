### Testing calendar functions:
# fmpc_financial_zip, fmpc_financial_bs_is_cf


# Basic Pulls using Validated API key
test_that("Test financials with API", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))

  zipFl = fmpc_financial_zip()
  expect_equal(ncol(zipFl),2)
  expect_true(nrow(zipFl)>2000)


  ### Test financial data pull
  symbols = c('AAPL','MSFT','BAC','TSLA')

  expect_error(fmpc_financial_bs_is_cf('AAPL',statement = 'cashflow', growth = TRUE, SECReported  = TRUE))
  expect_error(fmpc_financial_bs_is_cf(symbols,statement = 'cashflow', SECReported  = TRUE))

  Bal = fmpc_financial_bs_is_cf(symbols,statement = 'balance')
  BalG = fmpc_financial_bs_is_cf(symbols,statement = 'balance', growth = TRUE)
  expect_true(ncol(Bal)>45)
  expect_true(ncol(Bal) != ncol(BalG))
  expect_true(nrow(BalG) > 300)
  expect_equal(class(BalG)[1],'tbl_df')

  IS = fmpc_financial_bs_is_cf(symbols,statement = 'income')
  ISa = fmpc_financial_bs_is_cf(symbols,statement = 'income', quarterly = FALSE)
  expect_true(ncol(IS)> 30)
  expect_true(ncol(IS) == ncol(ISa))
  expect_true(nrow(IS) > nrow(ISa))


  cf = fmpc_financial_bs_is_cf(symbols,statement = 'cashflow')
  cfsec = fmpc_financial_bs_is_cf('AAPL',statement = 'cashflow', SECReported  = TRUE)
  expect_true(ncol(cf)> 30)
  expect_true(ncol(cf) != ncol(cfsec))
  expect_true(nrow(cf) > nrow(cfsec))

  int = fmpc_financial_bs_is_cf('RY.TO',statement = 'balance', quarterly = TRUE,
                       growth = TRUE, SECReported = FALSE, limit = 10)
  expect_true(nrow(int) >= 10)

  ### Financial metrics
  ratio = fmpc_financial_metrics(symbols, metric = 'ratios', quarterly = TRUE, trailingTwelve = TRUE, limit = 100)
  expect_true(ncol(ratio)>50)
  expect_true(nrow(ratio) == length(symbols))
  expect_equal(class(ratio)[1],'tbl_df')
  expect_true(grepl('TTM', paste0(colnames(ratio), collapse = '')))

  keym = fmpc_financial_metrics(symbols, metric = 'key', quarterly = FALSE, trailingTwelve = TRUE, limit = 100)
  expect_true(ncol(keym)>50)
  expect_true(nrow(keym) == length(symbols))

  ev = fmpc_financial_metrics(symbols, metric = 'ev', quarterly = TRUE, trailingTwelve = FALSE, limit = 100)
  expect_true(ncol(ev)>7)
  expect_true(nrow(ev) >= 100)

  growth = fmpc_financial_metrics(symbols, metric = 'growth', quarterly = FALSE, trailingTwelve = FALSE, limit = 120)
  expect_true(ncol(growth)> 30)
  expect_true(nrow(growth) >= 30)


  ### discounted cash flow
  dcCur = fmpc_financial_dcfv(symbols, period = 'current')
  expect_equal(ncol(dcCur), 4)
  expect_true(nrow(dcCur) == length(symbols))
  expect_equal(class(dcCur)[1],'tbl_df')

  dcDay = fmpc_financial_dcfv(symbols, period = 'daily')
  expect_equal(ncol(dcDay), 3)
  expect_true(nrow(dcDay) == length(symbols)*100)

  dcQtr = fmpc_financial_dcfv(symbols, period = 'quarterly')
  expect_equal(ncol(dcQtr), 4)
  expect_true(nrow(dcQtr) >= 100)

  dcAnl = fmpc_financial_dcfv(symbols, period = 'annually')
  expect_equal(ncol(dcAnl), 4)
  expect_true(nrow(dcAnl) >= 20)


})

# Basic Pulls using Validated API key
test_that("Test financials with DEMO", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  expect_warning(fmpc_set_token())


  ### Test financial data pull
  symbols = c('AAPL')

  expect_error(fmpc_financial_bs_is_cf('AAPL',statement = 'cashflow', growth = TRUE, SECReported  = TRUE))
  # expect_error(fmpc_financial_bs_is_cf(symbols,statement = 'cashflow', SECReported  = TRUE))

  Bal = fmpc_financial_bs_is_cf(symbols,statement = 'balance')
  BalG = fmpc_financial_bs_is_cf(symbols,statement = 'balance', growth = TRUE)
  expect_true(ncol(Bal)>45)
  expect_true(ncol(Bal) != ncol(BalG))
  expect_true(nrow(BalG) > 10)
  expect_equal(class(BalG)[1],'tbl_df')

  IS = fmpc_financial_bs_is_cf(symbols,statement = 'income')
  ISa = fmpc_financial_bs_is_cf(symbols,statement = 'income', quarterly = FALSE)
  expect_true(ncol(IS)> 30)
  expect_true(ncol(IS) == ncol(ISa))
  expect_true(nrow(IS) > nrow(ISa))


  cf = fmpc_financial_bs_is_cf(symbols,statement = 'cashflow')
  cfsec = fmpc_financial_bs_is_cf('AAPL',statement = 'cashflow', SECReported  = TRUE)
  expect_true(ncol(cf)> 30)
  expect_true(ncol(cf) != ncol(cfsec))
  expect_true(nrow(cf) > nrow(cfsec))

  int = fmpc_financial_bs_is_cf('RY.TO',statement = 'balance', quarterly = TRUE,
                                growth = TRUE, SECReported = FALSE, limit = 10)
  expect_true(nrow(int) >= 10)

  ### Financial metrics
  ratio = fmpc_financial_metrics(symbols, metric = 'ratios', quarterly = TRUE, trailingTwelve = TRUE, limit = 100)
  expect_true(ncol(ratio)>50)
  expect_true(nrow(ratio) == length(symbols))
  expect_equal(class(ratio)[1],'tbl_df')
  expect_true(grepl('TTM', paste0(colnames(ratio), collapse = '')))

  keym = fmpc_financial_metrics(symbols, metric = 'key', quarterly = FALSE, trailingTwelve = TRUE, limit = 100)
  expect_true(ncol(keym)>50)
  expect_true(nrow(keym) == length(symbols))

  ev = fmpc_financial_metrics(symbols, metric = 'ev', quarterly = TRUE, trailingTwelve = FALSE, limit = 100)
  expect_true(ncol(ev)>7)
  expect_true(nrow(ev) >= 100)

  growth = fmpc_financial_metrics(symbols, metric = 'growth', quarterly = FALSE, trailingTwelve = FALSE, limit = 120)
  expect_true(ncol(growth)> 30)
  expect_true(nrow(growth) >= 30)


  ### discounted cash flow
  dcCur = fmpc_financial_dcfv(symbols, period = 'current')
  expect_equal(ncol(dcCur), 4)
  expect_true(nrow(dcCur) == length(symbols))
  expect_equal(class(dcCur)[1],'tbl_df')

  dcDay = fmpc_financial_dcfv(symbols, period = 'daily')
  expect_equal(ncol(dcDay), 3)
  expect_true(nrow(dcDay) == length(symbols)*100)

  dcQtr = fmpc_financial_dcfv(symbols, period = 'quarterly')
  expect_equal(ncol(dcQtr), 4)
  expect_true(nrow(dcQtr) >= 100)

  dcAnl = fmpc_financial_dcfv(symbols, period = 'annually')
  expect_equal(ncol(dcAnl), 4)
  expect_true(nrow(dcAnl) >= 20)


})
