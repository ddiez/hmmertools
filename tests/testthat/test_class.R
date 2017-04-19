context("Testing class")

test_that("BiodockerHub", {
  h <- BiodockerHub()
  expect_is(h, c("hmmer", "biodev", "R6"))
})
