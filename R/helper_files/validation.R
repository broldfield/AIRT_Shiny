validateCsv <- function() {
  csv <- uploaded_csv()
  removeNotification("csvValidToast")

  # Checks if every row is numeric. May need to be modified if using time. Unless it's always in seconds.
  isNumericOnly <- sapply(csv, is.numeric)

  # Resets Document if Validation Fails.
  if (any(!isNumericOnly)) {
    hide_all()
    user_upload(FALSE)
    showNotification(
      "Upload failed. All fields besides the Column Name must be Numeric.",
      duration = NULL,
      id = "csvValidToast"
    )
  } else {
    upload_valid(TRUE)
  }
}
