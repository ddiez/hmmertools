context("Testing hmmsearch method")

test_that("pull", {
  h <- BiodockerHub()
  seqdb <- system.file("files", "uniprot.fasta", package = "hmmertools")
  hmmfile <- system.file("files", "Ras.hmm", package = "hmmertools")
  out <- hmmsearch(h, hmmfile = hmmfile, seqdb = seqdb, outfile = "out.txt")
  expect_true(out == 0)
})
