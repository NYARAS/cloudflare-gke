output "service_account_email" {
  description = "Service account email (for single use)."
  value       = google_service_account.service_account.email
}
