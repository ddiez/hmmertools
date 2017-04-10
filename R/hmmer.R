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

      cmd <- paste(self$dockerbin, "pull", self$image)
      system(cmd)
    },

    hmmsearch = function(hmmfile = NULL, seqdb = NULL, args = NULL, outfile = "out.txt", logfile = "/dev/null") {
      args <- paste("--tblout", outfile, args)
      cmd <- paste(self$dockerbin, "run", "-v", self$voldir, self$image, "hmmsearch", args, hmmfile, seqdb, "1>", logfile)
      system(cmd)
    },

    hmmalign = function(hmmfile = NULL, seqfile = NULL, args = "") {
      cmd <- paste(self$dockerbin, "run", "-v", self$voldir, self$image, "hmmalign", args, hmmfile, seqfile)
      system(cmd)
    },

    hmmbuild = function(hmmfile = NULL, msafile = NULL, args = "") {
      cmd <- paste(self$dockerbin, "run", "-v", self$voldir, self$image, "hmmbuild", args, hmmfile, msafile)
      system(cmd)
    },

    hmmscan = function(hmmdb = NULL, seqfile = NULL, args = "") {
      cmd <- paste(self$dockerbin, "run", "-v", self$voldir, self$image, "hmmscan", args, hmmdb, seqfile)
      system(cmd)
    }
  ))
