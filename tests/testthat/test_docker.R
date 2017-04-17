context("Testing docker image")

test_that("pull", {
  h <- hmmer$new()
  expect_is(h, c("hmmer", "biodev", "R6"))
})
