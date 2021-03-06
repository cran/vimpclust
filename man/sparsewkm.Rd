% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sparsewkm.R
\name{sparsewkm}
\alias{sparsewkm}
\title{Sparse weighted k-means}
\usage{
sparsewkm(
  X,
  centers,
  lambda = NULL,
  nlambda = 20,
  nstart = 10,
  itermaxw = 20,
  itermaxkm = 10,
  renamelevel = TRUE,
  verbose = 1,
  epsilonw = 1e-04
)
}
\arguments{
\item{X}{a dataframe of dimension \code{n} (observations) by \code{p} (variables) with
numerical, categorical or mixed data.}

\item{centers}{an integer representing the number of clusters.}

\item{lambda}{a vector of numerical values (or a single value) providing 
a grid of values for the regularization parameter. If NULL (by default), the function computes its 
own lambda sequence of length \code{nlambda} (see details).}

\item{nlambda}{an integer indicating the number of values for the regularization parameter. 
By default, \code{nlambda=20}.}

\item{nstart}{an integer representing the number of random starts in the k-means algorithm.
By default, \code{nstart=10}.}

\item{itermaxw}{an integer indicating the maximum number of iterations for the inside 
loop over the weights \code{w}. By default, \code{itermaxw=20}.}

\item{itermaxkm}{an integer representing the maximum number of iterations in the k-means 
algorithm. By default, \code{itermaxkm=10}.}

\item{renamelevel}{a boolean. If TRUE (default option), each level of a categorical variable
is renamed as \code{'variable_name=level_name'}.}

\item{verbose}{an integer value. If \code{verbose=0}, the function stays silent, if \code{verbose=1} (default option), it  prints
whether the stopping criterion over the weights \code{w} is satisfied.}

\item{epsilonw}{a positive numerical value. It provides the precision of the stopping 
criterion over \code{w}. By default, \code{epsilonw =1e-04}.}
}
\value{
\item{lambda}{a numerical vector containing the regularization parameters (a grid of values).}

\item{W}{a \code{p} by \code{length(lambda)} matrix. It contains the weights associated to each variable.}

\item{Wm}{a \code{q} by \code{length(lambda)} matrix, where \code{q} is the 
number of numerical variables plus the number of levels of the categorical 
variables. It contains the weights associated to the numerical variables and to the levels of the categorical
 variables.}

\item{cluster}{a \code{n} by \code{length(lambda)} integer matrix. It contains the 
cluster memberships, for each value of the regularization parameter.}

\item{sel.init.feat}{a numerical vector of the same length as \code{lambda}, giving the 
number of selected variables for each value of the regularization parameter.}

\item{sel.trans.feat}{a numerical vector of the same length as \code{lambda}, giving the 
number of selected numerical variables and levels of categorical variables.}

\item{X.transformed}{a matrix of size \code{n} by \code{q}, containing the transformed data: numerical variables scaled to 
zero mean and unit variables, categorical variables transformed into dummy variables, scaled (in means and variance)
with respect to the relative frequency of the levels.}

\item{index}{a numerical vector indexing the variables and allowing to group together the levels of a
 categorical variable.}

\item{bss.per.feature}{a matrix of size \code{q} by \code{length(lambda)}. 
It contains the between-class variance computed on the \code{q} transformed variables (numerical variables and 
levels of categorical variables).}
}
\description{
This function performs sparse weighted k-means on a set 
of observations described by numerical and/or categorical variables.
It generalizes the sparse clustering algorithm introduced in
Witten & Tibshirani (2010) to any type of data (numerical, categorical
or a mixture of both). The weights of the variables indicate their importance
in the clustering process and discriminant variables are thus selected by 
means of weights set to 0.
}
\details{
Sparse weighted k-means performs clustering on mixed data (numerical and/or categorical), and automatically
selects the most discriminant variables by setting to zero the weights of the non-discriminant ones. 

The mixted data is first preprocessed: numerical variables are scaled to zero mean and unit variance;
categorical variables are transformed into dummy variables, and scaled -- in mean and variance -- with
respect to the relative frequency of each level. 

The algorithm is based on the optimization of a cost function which is the weighted between-class variance penalized
 by a group L1-norm. The groups are implicitely defined: each numerical variable constitutes its own group, the levels 
associated to one categorical variable constitute a group. The importance of the penalty term may be adjusted through
the regularization parameter \code{lambda}.
 
The output of the algorithm is two-folded: one gets a partitioning of the data set and a vector of weights associated
to each variable. Some of the weights are equal to 0, meaning that the associated variables do not participate in the
clustering process. If \code{lambda} is equal to zero, there is no penalty applied to the weighted between-class variance in the 
optimization procedure. The larger the value of \code{lambda}, the larger the penalty term and the number of variables with
null weights. Furthemore, the weights associated to each level of a categorical variable are also computed.

Since it is difficult to choose the regularization parameter \code{lambda} without prior knowledge,
the function builds automatically a grid of parameters and finds a partition and vector of weights for each 
value of the grid.

Note also that the columns of the data frame \code{X} must be of class factor for 
categorical variables.
}
\examples{
data(HDdata)
\donttest{
out <- sparsewkm(X = HDdata[,-14], centers = 2)
# grid of automatically selected regularization parameters
out$lambda
k <- 10
# weights of the variables for the k-th regularization parameter
out$W[,k]
# weights of the numerical variables and of the levels 
out$Wm[,k]
# partitioning obtained for the k-th regularization parameter
out$cluster[,k]
# number of selected variables
out$sel.init.feat
# between-class variance on each variable
out$bss.per.feature[,k]
# between-class variance
sum(out$bss.per.feature[,k])
}
}
\references{
Witten, D. M., & Tibshirani, R. (2010). A framework for feature 
selection in clustering. Journal of the American Statistical Association, 
105(490), 713-726.

Chavent, M. & Lacaille, J. & Mourer, A. & Olteanu, M. (2020). 
Sparse k-means for mixed data via group-sparse clustering, ESANN proceedings.
}
\seealso{
\code{\link{plot.spwkm}}, \code{\link{info_clust}}, 
\code{\link{groupsparsewkm}}, \code{\link{recodmix}}
}
