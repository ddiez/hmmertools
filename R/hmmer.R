#' Initialize a HMMER docker image
#'
#' Initializes a HMMER docker image and calls specific methods
#'
#' @export
hmmer <- R6::R6Class("hmmer",
  inherit = biodevtools::biodev,
  public = list(
    image = "ddiez/hmmer",

    initialize = function(image = self$image, ...) {
      super$initialize(...)
      self$image <- image

      args <- paste("pull", self$image)
      system2(self$dockerbin, args)
    },

    hmmsearch = function(hmmfile = NULL, seqdb = NULL, args = "", outfile = "out.txt", help = FALSE) {
      if (help || grepl("-h", args)) {
        args <- paste("run", self$image, "hmmsearch", "-h")
        system2(self$dockerbin, args)
      } else {
        if (is.null(hmmfile)) stop("hmmfile is required.")
        if (is.null(seqdb)) stop("seqdb is required.")

        args <- paste("run", "-v", self$voldir, self$image, "hmmsearch", "--tblout", outfile, args, hmmfile, seqdb)
        system2(self$dockerbin, args, stdout = FALSE)
      }
    },

    hmmalign = function(hmmfile = NULL, seqfile = NULL, args = "", outfile = "out.txt", help = FALSE) {
      if (help || grepl("-h", args)) {
        args <- paste("run", self$image, "hmmalign", "-h")
        system2(self$dockerbin, args)
      } else {
        if (is.null(hmmfile)) stop("hmmfile is required.")
        if (is.null(seqfile)) stop("seqfile is required.")

        args <- paste("run", "-v", self$voldir, self$image, "hmmalign", args, hmmfile, seqfile)
        system2(self$dockerbin, args, stdout = outfile) # this approach overwrites with blank outfile if it fails (e.g. when file not found).
      }
    },

    hmmbuild = function(hmmfile = NULL, msafile = NULL, args = "", help = FALSE) {
      if (help || grepl("-h", args)) {
        args <- paste("run", self$image, "hmmbuild", "-h")
        system2(self$dockerbin, args)
      } else {
        if (is.null(hmmfile)) stop("hmmfile is required.")
        if (is.null(msafile)) stop("msafile is required.")

        args <- paste("run", "-v", self$voldir, self$image, "hmmbuild", args, hmmfile, msafile)
        system2(self$dockerbin, args)
      }
    },

    hmmscan = function(hmmdb = NULL, seqfile = NULL, args = "", help = FALSE) {
      if (help || grepl("-h", args)) {
        args <- paste("run", self$image, "hmmscan", "-h")
        system2(self$dockerbin, args)
      } else {
        if (is.null(hmmfile)) stop("hmmdb is required.")
        if (is.null(msafile)) stop("seqfile is required.")

        args <- paste("run", "-v", self$voldir, self$image, "hmmscan", args, hmmdb, seqfile)
        system2(self$dockerbin, args)
      }
    }
  ))

#' BiodockerHub constructor.
#'
#' @param ... arguments passed to constructor.
#' @export
BiodockerHub <- function(...) {
  hmmer$new(...)
}

setOldClass(c("Hmmer", "biodev", "R6"))

#' show
#'
#' @param object Hmmer object.
#'
#' @export
setMethod("show", "Hmmer", function(object)
{
  cat("class (show!):", class(object), "\n")

}) # this does not seem to work.

#' print
#'
#' @param x Hmmer object.
#' @param ... further arguments (ignored).
#'
#' @export
setMethod("print", "Hmmer", function(x, ...)
{
  cat("class (print!):", class(x), "\n")

}) # this does not seem to work.

#' hmmsearch
#'
#' @param object Hmmer object.
#' @param ... further arguments passed to hmmsearch().
#'
#' @aliases hmmsearch,Hmmer-method
#'
#' @export
setGeneric("hmmsearch", function(object, ...) standardGeneric("hmmsearch"))
setMethod("hmmsearch", "Hmmer", function(object, ...) object$hmmsearch(...))
