resource "google_storage_bucket" "website" {
  name          = var.bucket_name # bucket name has to be unique
  location      = var.gcp_region
  force_destroy = true
  storage_class = "STANDARD"
  labels = {
    "key1" = "value1"
  }
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
  for_each = fileset(path.module, "website/*")
  name     = "${var.bucket_name}/${each.value}"
  source   = "${path.module}/${each.value}"
  bucket   = google_storage_bucket.website.name
}
