% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/holdings.R
\name{fmpc_13f_cik_list}
\alias{fmpc_13f_cik_list}
\title{List of all 13F ciks}
\usage{
fmpc_13f_cik_list()
}
\value{
cik list
}
\description{
Ciks are unique IDs for each company that files a 13F. This function returns
a list of each unique cik that FMP Cloud has available.
}
\examples{
\dontrun{
# Function can work without a valid API token
fmpc_set_token() # defaults to 'demo'
fmpc_13f_cik_list()
}
}
