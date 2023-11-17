resource "tls_private_key" "reg_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address   = "vishal.patel@yoppworks.com"
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "req" {
#   key_algorithm   = "RSA"
  private_key_pem = tls_private_key.cert_private_key.private_key_pem
  subject {
    common_name = "*.certlb.cloudns.org"
    organization = var.company_name
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  certificate_request_pem   = tls_cert_request.req.cert_request_pem
  pre_check_delay = "120"

  dns_challenge {
    provider = "gcloud"
    config = {
      GCE_SERVICE_ACCOUNT_FILE = "service_account.json"
      GCE_PROJECT              = "lb-cert"
      GCE_POLLING_INTERVAL = 120
      GCE_PROPAGATION_TIMEOUT = 120
    }
  }
}









# resource "tls_private_key" "private_key" {
#   algorithm = "RSA"
# }

# resource "acme_registration" "reg" {
#   account_key_pem = tls_private_key.private_key.private_key_pem
#   email_address = "vishal.patel@yoppworks.com"
# #   email_address   = var.email

# }

# resource "random_password" "cert" {
#   length  = 24
#   special = true
# }

# resource "acme_certificate" "certificate" {
#   account_key_pem         = "${acme_registration.reg.account_key_pem}"
#   certificate_request_pem = "${tls_cert_request.csr.cert_request_pem}"
#   certificate_p12_password = random_password.cert.result

#   min_days_remaining      = 7 # set this values depending how many after you would like to renew it.

#   dns_challenge {
#     provider = "gcloud"

#     config {
#       GCE_PROJECT              = "lb-cert"
#       GCE_POLLING_INTERVAL     = "10"
#       GCE_PROPAGATION_TIMEOUT  = "180"
#       GCE_TTL                  = "60"

#       GCE_SERVICE_ACCOUNT_FILE = "${file("./service_account.json")}"
#     }
#   }
# }