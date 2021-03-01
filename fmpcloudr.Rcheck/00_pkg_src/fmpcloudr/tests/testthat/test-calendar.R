### Testing calendar functions:
# fmpc_calendar_events, fmpc_economic_events, fmpc_economic_results


# Basic Pulls using Validated API key
test_that("Test calendar with API", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))

  # Check calendar events
  ipo = fmpc_calendar_events('ipo', startDate = Sys.Date()-100)
  expect_equal(ncol(ipo),8)
  expect_true(min(ipo$date) >= Sys.Date()-100)
  expect_equal(class(ipo)[1],'tbl_df')

  spl = fmpc_calendar_events('stock_split')
  expect_equal(ncol(spl),5)

  div = fmpc_calendar_events('stock_dividend')
  expect_equal(ncol(div),8)

  earn = fmpc_calendar_events('earning')
  expect_equal(ncol(earn),7)

  econ = fmpc_calendar_events('economic',startDate = Sys.Date()-360)
  expect_equal(ncol(econ),8)

  # List of econ events
  Events = fmpc_economic_events()
  expect_equal(ncol(Events),2)
  expect_true(nrow(Events) > 1000)
  expect_equal(class(Events)[1],'tbl_df')

  # Econ results
  baseEc = fmpc_economic_results()
  expect_equal(ncol(baseEc),7)
  randEC1 = fmpc_economic_results(event = Events[100,1], country = Events[100,2])
  expect_equal(ncol(randEC1),7)
  expect_true(nrow(randEC1) > 500)
  randEC2 = fmpc_economic_results(event = Events[1000,1], country = Events[1000,2])
  expect_equal(ncol(randEC2),7)
  expect_true(nrow(randEC2) > 100)
  expect_equal(class(randEC2)[1],'tbl_df')

})
