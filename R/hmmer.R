#' Initialize a HMMER docker image
#'
#' Initializes a HMMER docker image and calls specific methods
#'
#' @export
hmmer <- R6::R6Class("hmmer",
  inherit = biodevtools::biodev,
  public = list(
    initialize = function(image = "ddiez/hmmer", ...) {
      super$initialize(image = image, ...)

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

        hmmpath <- private$norm_path(hmmfile, bind.dir = "hmm")
        seqpath <- private$norm_path(seqdb, bind.dir = "seq")

        args <- paste("run", "-v", hmmpath$volume, "-v", seqpath$volume, "-v", self$voldir, self$image, "hmmsearch", "--tblout", outfile, args, hmmpath$file, seqpath$file)
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

        hmmpath <- private$norm_path(hmmfile, bind.dir = "hmm")
        seqpath <- private$norm_path(seqfile, bind.dir = "seq")

        args <- paste("run", "-v", hmmpath$volume, "-v", seqpath$volume, "-v", self$voldir, self$image, "hmmalign", args, hmmpath$file, seqpath$file)
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

        seqpath <- private$norm_path(msafile, bind.dir = "seq")

        args <- paste("run", "-v", seqpath$volume, "-v", self$voldir, self$image, "hmmbuild", args, hmmfile, seqpath$file)
        system2(self$dockerbin, args)
      }
    },

    hmmpress = function(hmmfile = NULL, args = "", help = FALSE) {
      if (help || grepl("-h", args)) {
        args <- paste("run", self$image, "hmmpress", "-h")
        system2(self$dockerbin, args)
      } else {
        if (is.null(hmmfile)) stop("hmmfile is required.")

        hmmpath <- private$norm_path(hmmfile, bind.dir = "hmm")

        args <- paste("run", "-v", hmmpath$volume, "-v", self$voldir, self$image, "hmmpress", args, hmmpath$file)
        system2(self$dockerbin, args)
      }
    },

    hmmscan = function(hmmdb = NULL, seqfile = NULL, args = "", outfile = "out.txt", help = FALSE) {
      if (help || grepl("-h", args)) {
        args <- paste("run", self$image, "hmmscan", "-h")
        system2(self$dockerbin, args)
      } else {
        if (is.null(hmmdb)) stop("hmmdb is required.")
        if (is.null(seqfile)) stop("seqfile is required.")

        hmmpath <- private$norm_path(hmmdb, bind.dir = "hmm")
        seqpath <- private$norm_path(seqfile, bind.dir = "seq")

        args <- paste("run", "-v", hmmpath$volume, "-v", seqpath$volume, "-v", self$voldir, self$image, "hmmscan", args, hmmpath$file, seqpath$file)
        system2(self$dockerbin, args, stdout = outfile)
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

setOldClass(c("hmmer", "biodev", "R6"))

#' show
#'
#' @param object hmmer object.
#'
#' @export
setMethod("show", "hmmer", function(object)
{
  cat("class (show!):", class(object), "\n")

}) # this does not seem to work.

#' print
#'
#' @param x hmmer object.
#' @param ... further arguments (ignored).
#'
#' @export
setMethod("print", "hmmer", function(x, ...)
{
  cat("class (print!):", class(x), "\n")

}) # this does not seem to work.

#' hmmsearch
#'
#' @param object hmmer object.
#' @param ... further arguments passed to hmmsearch().
#'
#' @aliases hmmsearch,hmmer-method
#'
#' @export
setGeneric("hmmsearch", function(object, ...) standardGeneric("hmmsearch"))
setMethod("hmmsearch", "hmmer", function(object, ...) object$hmmsearch(...))
