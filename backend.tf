terraform {
  backend "gcs" {
    bucket = "tf-arc-state-file"
  }
}