#' Initialize a HMMER docker image
#'
#' Initializes a HMMER docker image and calls specific methods
#'
#' @usage
#' hmmer$new()
#'
#' @examples
#' h <- hmmer$new()
#' h$image
#' h$outdir
#' h$hmmsearch("model.hmm", "sequences.fa")
#'
#' @export
hmmer <- R6::R6Class("hmmer",
  public = list(
    image = "ddiez/hmmer",
    outdir = ".",
    homedir = NULL,
    voldir = NULL,
    dockerbin = "docker",

    initialize = function(image = self$image, dir = getwd()) {
      cmd <- paste("docker pull", image)
      system(cmd)

      self$image <- image
      self$homedir <- dir
      self$voldir <- paste0(self$homedir, ":", "/home/biodev")
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