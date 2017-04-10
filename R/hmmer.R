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

      # In some GUI stdout may not be printed. This could be better alternative:
      # (and print based on biodev:verbose = TRUE)
      #args <- paste("pull", self$image)
      #out <- system2(self$dockerbin, args, stdout = TRUE)
      #cat(paste(out, collapse = "\n"))
    },

    hmmsearch = function(hmmfile = NULL, seqdb = NULL, args = NULL, outfile = "out.txt", logfile = "/dev/null") {
      args <- paste("run", "-v", self$voldir, self$image, "hmmsearch", "--tblout", outfile, args, hmmfile, seqdb)
      out <- system2(self$dockerbin, args, stdout = TRUE)

      status <- attributes(out)$status
      out <- paste(out, collapse = "\n")
      if (!is.null(status) && status == 1)
        cat(out)
      else
        cat(out, file = logfile)
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
