resource "google_compute_url_map" "https_default" {
  name = "${local.service_name}-https-urlmap"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    https_redirect         = true
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_default" {
  name    = "${local.service_name}-http-proxy"
  url_map = google_compute_url_map.https_default.id
}

resource "google_compute_global_forwarding_rule" "https_default" {
  name       = "${local.service_name}-https-fr"
  target     = google_compute_target_http_proxy.https_default.id
  ip_address = var.google_compute_global_address_id
  port_range = "80"
}