\name{LogrankA}
\alias{LogrankA}
\title{
Logrank Test for Aggregated Survival Data
}
\description{
\code{LogrankA} provides a logrank test across unlimited groups with the
possibility to input aggregated survival data.
}
\usage{
LogrankA(surv, group, weight)
}
\arguments{
  \item{surv}{
  An object of type \code{survival} is expected as input argument \code{surv}.
  This object is generated with the function \code{Surv} of the package
  \code{survival} and holds information about the survival time and censoring
  status of each observation.
}
  \item{group}{
  Argument \code{group} provides the group affiliation of each observation in
  the survival argument.
}
  \item{weight}{
  The argument \code{weight} is optional. It specifies the number of occurrences
  for each value combination in an aggregated dataset. Expected is a
  non-negative numeric vector.
}
}
\details{
  The \code{group} and \code{weight} arguments must correspond to the entries in
  the \code{surv} argument. Therefore the \code{group} and \code{weight} vectors
  must be equal in length to the time and status columns in the survival object
  of \code{surv}

  If the weight argument is not specified it is assumed that the input data is 
  not aggregated.

  More than a single group must be specified.
}
\value{

\item{p.chi2}{P-value of chi-squared test of logrank test statistic.}
\item{df}{Degrees of freedom used for chi-squared test.}
\item{LR}{Value of logrank test statistic.}
\item{lr.parameter}{Number of observations, observed events, expected events,
(O-E)^2/E for each group.}

In addition a short text summary of the logrank test is printed to the console.

}
\references{
Peto, R. et al. (1977). "Design and analysis of randomized clinical trials
requiring prolonged observation of each patient". II. analysis and examples. In:
British journal of cancer 35.1, pp. 1-39.

Ziegler, A., S. Lange, and R. Bender (2007). "Ueberlebenszeitanalyse: Der 
Log-Rang-Test". In: Deutsche Medizinische Wochenschrift 132, pp. 39-41.
}
\author{
Jonas Richter-Dumke and Roland Rau

Maintainer: Jonas Richter-Dumke <jrd.r.project@gmail.com>
}
\note{
For an in-depth explanation of \code{LogrankA} please see the package vignette.
}
\seealso{
\code{\link{Surv}}, \code{\link{survdiff}}
}
\examples{
library(survival)
library(MASS)

## data: survival of australian aids patients (individual and aggregated)

aids2.ind <- Aids2 # import australian aids data
aids2.ind$status <- as.numeric(aids2.ind$status) - 1 # recode status to 0/1
stime.days <- aids2.ind$death - aids2.ind$diag # generate survival time in weeks
aids2.ind$stime <- round(stime.days / 7, 0)
aids2.ind$agegr <- cut(aids2.ind$age, # generate age groups
                       c(0, 20, 40, 60, 100), right = FALSE)
aids2.ind <- aids2.ind[ , c(5, 8, 9)] # keep only important columns
aids2.aggr <- aggregate(aids2.ind$stime, # transform to aggregated data
                        by = list(aids2.ind$status, aids2.ind$stime,
                                  aids2.ind$agegr),
                        FUN = length)
colnames(aids2.aggr) <- c("status", "stime", "agegr", "n")
# generate survival objects for individual and aggregated data
surv.ind <- Surv(aids2.ind$stime, aids2.ind$status)
surv.aggr <- Surv(aids2.aggr$stime, aids2.aggr$status)

## logrank test on individual and aggregated data

# logrank on individual data
LogrankA(surv = surv.ind,
         group = aids2.ind$agegr)
# logrank on aggregated data
LogrankA(surv = surv.aggr,
         group = aids2.aggr$agegr,
         weight = aids2.aggr$n)
}
\keyword{ survival }
