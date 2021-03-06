% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/holdings.R
\name{fmpc_held_by_mfs}
\alias{fmpc_held_by_mfs}
\title{List of mutual funds that hold a specified symbol}
\usage{
fmpc_held_by_mfs(symbols = c("AAPL"))
}
\arguments{
\item{symbols}{one or more symbols from the FMP available list that can be
found using \code{\link{fmpc_symbols_by_market}}. A valid API token must be
set in order to enable functionality. See documentation for setting a token
under \code{\link{fmpc_set_token}}.}
}
\value{
data frame of mutual funds holding specified security
}
\description{
Shows mutual funds holding a list of symbols provided. Not currently available
for ETFs
}
\details{
This differs from \code{\link{fmpc_holdings_etf}} which allows a search by
ETF to see detail on what the ETF is holding.
}
\examples{



\dontrun{

# Demo can pull AAPL
fmpc_set_token()
fmpc_held_by_mfs('AAPL')

# For multiple symbols, set a valid API Token
fmpc_set_token('FMPAPIKEY')
fmpc_held_by_mfs(c('AAPL','MSFT','GOOGL'))

}

}
