#' Description object for task.
#'
#' Description object for task, encapsulates basic properties of the task
#' without having to store the complete data set.
#'
#' Object members:
#' \describe{
#' \item{id [\code{character(1)}]}{Id string of task.}
#' \item{type [\code{character(1)}]}{Type of task, \dQuote{classif} for classification,
#'   \dQuote{regr} for regression, \dQuote{surv} for survival, \dQuote{costsens} for
#'   cost-sensitive classification.}
#' \item{target [\code{character(0)} | \code{character(1)} | \code{character(2)}]}{
#'  Name of target variable.
#'  For \dQuote{surv} these are the names of the survival time and event columns, so it has length 2.
#'  For \dQuote{costsens} ist has length 0, as there is no target column, but a cost matrix instead.}
#' \item{size [\code{integer(1)}]}{Number of cases in data set.}
#' \item{n.feat [\code{integer(2)}]}{Number of features, named vector with entries:
#'   \dQuote{numerics}, \dQuote{factors}, \dQuote{ordered}.}
#' \item{has.missings [\code{logical(1)}]}{Are missing values present?}
#' \item{has.weights [\code{logical(1)}]}{Are weights specified for each observation?}
#' \item{has.blocking [\code{logical(1)}]}{Is a blocking factor for cases available in the task?}
#' \item{class.levels [\code{character}]}{All possible classes.
#'   Only present for \dQuote{classif} and \dQuote{costsens}.}
#' \item{positive [\code{character(1)}]}{Positive class label for binary classification.
#'   Only present for \dQuote{classif}, NA for multiclass.}
#' \item{negative [\code{character(1)}]}{Negative class label for binary classification.
#'   Only present for \dQuote{classif}, NA for multiclass.}
#' }
#' @name TaskDesc
#' @rdname TaskDesc
NULL

makeTaskDesc = function(task, id, ...) {
  UseMethod("makeTaskDesc")
}

makeTaskDescInternal = function(task, type, id, target, ...) {
  data = task$env$data
  # get classes of feature cols
  cl = vapply(data, function(x) head(class(x), 1L), character(1L))
  cl = dropNamed(cl, target)
  n.feat = c(
    numerics = sum(cl %in% c("integer", "numeric")),
    factors = sum(cl == "factor"),
    ordered = sum(cl == "ordered")
  )
  makeS3Obj("TaskDesc",
    id = id,
    type = type,
    target = target,
    size = nrow(data),
    n.feat = n.feat,
    has.missings = anyMissing(data),
    has.weights = !is.null(task$weights),
    has.blocking = !is.null(task$blocking)
  )
}


