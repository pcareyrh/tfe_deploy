resource "tls_private_key" "ca_tfe_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "ca_tfe_crt" {
  key_algorithm   = tls_private_key.ca_tfe_key.algorithm
  private_key_pem = tls_private_key.ca_tfe_key.private_key_pem
  is_ca_certificate = true

  # Certificate expires after 12 hours.
  validity_period_hours = 12

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
      "cert_signing",
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]

  dns_names = ["tfe.pcarey.xyz"]

  subject {
      common_name  = "tfe.pcarey.xyz"
      organization = "ACME Examples, Inc"
  }

  provisioner "local-exec" {
    command = "echo '${tls_self_signed_cert.ca_tfe_crt.cert_pem}' > '${var.ca_public_key_file_path}'"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A TLS CERTIFICATE SIGNED USING THE CA CERTIFICATE
# ---------------------------------------------------------------------------------------------------------------------

resource "tls_private_key" "tfe_key" {
  algorithm   = "RSA"
  rsa_bits    = "2048"

  # Store the certificate's private key in a file.
  provisioner "local-exec" {
    command = "echo '${tls_private_key.tfe_key.private_key_pem}' > '${var.private_key_file_path}'"
  }
}

resource "tls_cert_request" "tfe_csr" {
  key_algorithm   = tls_private_key.tfe_key.algorithm
  private_key_pem = tls_private_key.tfe_key.private_key_pem

  dns_names    = ["tfe.pcarey.xyz"]

  subject {
    common_name  = "tfe.pcarey.xyz"
    organization = "ACME Org"
  }
}

resource "tls_locally_signed_cert" "tfe_cert" {
  cert_request_pem = tls_cert_request.tfe_csr.cert_request_pem

  ca_key_algorithm   = tls_private_key.ca_tfe_key.algorithm
  ca_private_key_pem = tls_private_key.ca_tfe_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_tfe_crt.cert_pem

  validity_period_hours = 12
  allowed_uses          = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
      ]

  # Store the certificate's public key in a file.
  provisioner "local-exec" {
    command = "echo '${tls_locally_signed_cert.tfe_cert.cert_pem}' > '${var.public_key_file_path}'"
  }
}