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
    initialize = function(image = self$image) {
      "Initializes docker image"
      cmd <- paste("docker pull", image)
      system(cmd)
    },
    hmmsearch = function(hmmfile = NULL, seqdb = NULL, args = "") {
      "Runs hmmsearch"
      cmd <- paste("docker run", self$image, "hmmsearch", args, hmmfile, seqdb)
      system(cmd)
    }
  ))
