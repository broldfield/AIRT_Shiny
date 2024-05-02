validateCsv <- function() {
  csv <- uploadedCsv()
  removeNotification("csvValidToast")

  # Checks if every row is numeric. May need to be modified if using time. Unless it's always in seconds.
  isNumericOnly <- sapply(csv, is.numeric)

  # Resets Document if Validation Fails.
  if (any(!isNumericOnly)) {
    hideAll()
    userUpload(FALSE)
    showNotification(
      "Upload failed. All fields besides the Column Name must be Numeric.",
      duration = NULL,
      id = "csvValidToast"
    )
  } else {
    uploadValid(TRUE)
  }
}
