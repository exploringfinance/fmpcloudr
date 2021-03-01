### Testing secDetails functions:
# fmpc_security_ratings, fmpc_security_mrktcap, fmpc_security_delisted,
# fmpc_security_news, fmpc_analyst_outlook, fmpc_earning_call_transcript


# Basic Pulls using Validated API key
test_that("Test sec details with API", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  # Set Token to FMP token
  # This cannot be done on CRAN
  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))

  symbols = c('AAPL','MSFT','TSLA')
  fails = c('NOTREAL','SPY')
  indexes = c('^SP500TR','BTCUSD','JPYUSD')
  symwErr = c(symbols,fails,indexes)
  symCt = length(unique(symbols))

  #### Ratings
  expect_warning(fmpc_security_ratings(symwErr))
  Ratings = fmpc_security_ratings(symbols, limit = 120)
  expect_equal(nrow(Ratings),symCt*120)
  expect_equal(ncol(Ratings),17)

  ### Market Cap
  expect_warning(fmpc_security_mrktcap(symwErr))
  MCap = fmpc_security_mrktcap(symbols, limit = 120)
  expect_equal(nrow(MCap),symCt*120)
  expect_equal(ncol(MCap),3)

  ### Delisted
  Del = fmpc_security_delisted(limit = 150)
  expect_equal(nrow(Del),150)
  expect_equal(ncol(Del),5)

  ### Newa
  expect_warning(fmpc_security_news(symwErr))
  News = fmpc_security_news(symbols, limit = 110)
  expect_equal(nrow(News),symCt*110)
  expect_equal(ncol(News),7)

  # Analyst outlook
  expect_warning(fmpc_analyst_outlook(symwErr))
  Surp = fmpc_analyst_outlook(symbols, 'surprise')
  expect_equal(ncol(Surp),4)

  Grd = fmpc_analyst_outlook(symbols, 'grade', limit = 120)
  expect_equal(nrow(Grd),symCt*120)
  expect_equal(ncol(Grd),5)

  QtrE = fmpc_analyst_outlook(symbols, 'estimateQtr')
  expect_equal(ncol(QtrE),22)

  AnlE = fmpc_analyst_outlook(symbols, 'estimateAnnl')
  expect_true(nrow(AnlE)<nrow(QtrE))
  expect_equal(ncol(AnlE),22)

  Recc = fmpc_analyst_outlook(symbols, 'recommend')
  expect_equal(ncol(Recc),7)

  Press = fmpc_analyst_outlook(symbols, 'press')
  expect_equal(ncol(Press),4)
  expect_equal(class(Press)[1],'tbl_df')

  # Call transcript
  CT = fmpc_earning_call_transcript(symbols, quarter = 1, year = 2019)
  expect_equal(class(CT)[1],'tbl_df')
  expect_equal(CT$quarter[1], 1)
  expect_equal(CT$year[1], 2019)

})

# Basic Pulls using DEMO
test_that("Testsec details with DEMO", {

  skip_on_cran()

  expect_warning(fmpc_set_token())

  symbols = c('AAPL')
  fails = c('NOTREAL','SPY')
  indexes = c('^SP500TR','BTCUSD','JPYUSD')
  symwErr = c(symbols,fails,indexes)
  symCt = length(unique(symbols))

  #### Ratings
  expect_warning(fmpc_security_ratings(symwErr))
  Ratings = fmpc_security_ratings(symbols, limit = 120)
  expect_equal(nrow(Ratings),symCt*120)
  expect_equal(ncol(Ratings),17)

  ### Market Cap
  expect_warning(fmpc_security_mrktcap(symwErr))
  MCap = fmpc_security_mrktcap(symbols, limit = 120)
  expect_equal(nrow(MCap),symCt*120)
  expect_equal(ncol(MCap),3)

  ### Delisted
  # Del = fmpc_security_delisted(limit = 150)
  # expect_equal(nrow(Del),150)
  # expect_equal(ncol(Del),5)

  ### News
  # expect_warning(fmpc_security_news(symwErr))
  # News = fmpc_security_news(symbols, limit = 110)
  # expect_equal(nrow(News),symCt*110)
  # expect_equal(ncol(News),7)

  # Analyst outlook
  expect_warning(fmpc_analyst_outlook(symwErr))
  Surp = fmpc_analyst_outlook(symbols, 'surprise')
  expect_equal(ncol(Surp),4)

  Grd = fmpc_analyst_outlook(symbols, 'grade', limit = 120)
  expect_equal(nrow(Grd),symCt*120)
  expect_equal(ncol(Grd),5)

  QtrE = fmpc_analyst_outlook(symbols, 'estimateQtr')
  expect_equal(ncol(QtrE),22)

  AnlE = fmpc_analyst_outlook(symbols, 'estimateAnnl')
  expect_true(nrow(AnlE)<nrow(QtrE))
  expect_equal(ncol(AnlE),22)

  Recc = fmpc_analyst_outlook(symbols, 'recommend')
  expect_equal(ncol(Recc),7)

  Press = fmpc_analyst_outlook(symbols, 'press')
  expect_equal(ncol(Press),4)
  expect_equal(class(Press)[1],'tbl_df')

  # Call transcript
  CT = fmpc_earning_call_transcript(symbols, quarter = 1, year = 2019)
  expect_equal(class(CT)[1],'tbl_df')
  expect_equal(CT$quarter[1], 1)
  expect_equal(CT$year[1], 2019)

})

