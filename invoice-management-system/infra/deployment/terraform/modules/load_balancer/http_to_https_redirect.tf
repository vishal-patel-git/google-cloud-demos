resource "google_compute_region_url_map" "https_default" {
  name = "${local.lb_name}-https-urlmap"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    https_redirect         = true
    strip_query            = false
  }
}

resource "google_compute_region_target_http_proxy" "https_default" {
  name    = "${local.lb_name}-http-proxy"
  url_map = google_compute_region_url_map.https_default.id
}

resource "google_compute_forwarding_rule" "https_default" {
  name                  = "${local.lb_name}-https-fr"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_region_target_http_proxy.https_default.id
  ip_address            = var.google_compute_address_id
  network               = var.trust_network_name
  port_range            = "80"
  network_tier          = "STANDARD"
}