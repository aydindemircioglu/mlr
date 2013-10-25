#' @S3method makeRLearner regr.rpart
makeRLearner.regr.rpart = function() {
  makeRLearnerRegr(
    cl = "regr.rpart",
    package = "rpart",
    par.set = makeParamSet(
      makeIntegerLearnerParam(id="minsplit", default=20L, lower=1L),
      makeIntegerLearnerParam(id="minbucket", lower=1L),
      makeNumericLearnerParam(id="cp", default=0.01, lower=0, upper=1),
      makeIntegerLearnerParam(id="maxcompete", default=4L, lower=0L),
      makeIntegerLearnerParam(id="maxsurrogate", default=5L, lower=0L),
      makeDiscreteLearnerParam(id="usesurrogate", default=2L, values=0:2),
      makeDiscreteLearnerParam(id="surrogatestyle", default=0L, values=0:1),
      # we use 30 as upper limit, see docs of rpart.control
      makeIntegerLearnerParam(id="maxdepth", default=30L, lower=1L, upper=30L),
      makeIntegerLearnerParam(id="xval", default=10L, lower=0L)
    ), 
    par.vals = list(xval=0L),
    missings = TRUE,
    numerics = TRUE,
    factors = TRUE,
    se = FALSE,
    weights = TRUE
  )
}

#' @S3method trainLearner regr.rpart
trainLearner.regr.rpart = function(.learner, .task, .subset, .weights,  ...) {
  d = getTaskData(.task, .subset)
  if (missing(.weights)) {
    f = getTaskFormula(.task)
    rpart(f, data=d, ...)
  } else  {
    f = as.formula(getTaskFormulaAsString(.task))
    rpart(f, data=d, weights=.weights, ...)
  }
}

#' @S3method predictLearner regr.rpart
predictLearner.regr.rpart = function(.learner, .model, .newdata, ...) {
  predict(.model$learner.model, newdata=.newdata, ...)
}