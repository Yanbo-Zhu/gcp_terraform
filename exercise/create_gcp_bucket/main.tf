resource "google_storage_bucket" "website" {
  name          = var.bucket_name # bucket name has to be unique
  location      = var.region
  force_destroy = true
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}


resource "google_storage_object_access_control" "public_rule" {
  for_each =  google_storage_bucket_object.static_site_src
  bucket = each.value.bucket
  object = each.value.name
  role = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_object" "static_site_src" {
  for_each = fileset(var.source_path, "**/*.*")
  name     = "${var.bucket_name}/${each.value}"
  source   = "${var.source_path}/${each.value}"
  bucket   = google_storage_bucket.website.name
  content_type = mime_type(each.value)
}