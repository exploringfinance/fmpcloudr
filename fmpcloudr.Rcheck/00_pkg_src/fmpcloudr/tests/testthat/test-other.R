# Basic Pulls using Validated API key
test_that("Test small sample of prices", {

  ### All tests with API key should be skipped on CRAN
  skip_on_cran()

  fmpc_set_token(readRDS('/home/rstudio/Secure/fmp.rds'))


  symbs = fmpc_cots_symbols()
  expect_true(nrow(symbs) >= 30 & ncol(symbs)>=2)

  gold = fmpc_cots_data('gc')
  expect_true(nrow(gold) >= 30 & ncol(gold)>=100)

})
