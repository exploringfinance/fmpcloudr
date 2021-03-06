% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calendar.R
\name{fmpc_calendar_events}
\alias{fmpc_calendar_events}
\title{Dates related to Economic data, IPOs, dividends, earnings, and splits}
\usage{
fmpc_calendar_events(
  calendar = "economic",
  startDate = Sys.Date() - 180,
  endDate = Sys.Date()
)
}
\arguments{
\item{calendar}{indicate which calendar to view. Options include 'ipo',
'stock_split', 'stock_dividend', 'earning',or 'economic'}

\item{startDate}{filter start date in yyyy-mm-dd format.}

\item{endDate}{filter end date in yyyy-mm-dd format.}
}
\value{
calendar events
}
\description{
Calendar dates related to Economic data, IPOs, dividends, earnings, and
splits
}
\examples{

\dontrun{

# Must set a valid API token
fmpc_set_token('FMPAPIKEY')
fmpc_calendar_events('stock_split')
fmpc_calendar_events('economic')
}
}
