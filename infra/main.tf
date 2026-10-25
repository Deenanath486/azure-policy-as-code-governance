data "azurerm_client_config" "current" {}

# Policy 1: Deny Public IP on NIC
resource "azurerm_policy_definition" "deny_public_ip" {
  name         = "deny-public-ip-nic"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Public IP on Network Interfaces"
  description  = "Denies creation or update of Network Interfaces configured with Public IP addresses."

  metadata = jsonencode({
    category = "Network"
    version  = "1.0.0"
  })

  policy_rule = file("${path.module}/../policies/custom/deny-public-ip-nic.json")
}

# Policy 2: Enforce Mandatory Tags
resource "azurerm_policy_definition" "enforce_tags" {
  name         = "enforce-mandatory-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce Mandatory Resource Tags"
  description  = "Enforces presence of tags (Environment, Owner, CostCenter)."

  metadata = jsonencode({
    category = "Governance"
    version  = "1.0.0"
  })

  policy_rule = file("${path.module}/../policies/custom/enforce-mandatory-tags.json")
}

# Policy 3: Require TLS 1.2+ on Storage
resource "azurerm_policy_definition" "require_tls12" {
  name         = "require-storage-tls12"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require Secure TLS 1.2+ and HTTPS for Storage Accounts"
  description  = "Enforces minimum TLS 1.2 and HTTPS traffic only on Azure Storage."

  metadata = jsonencode({
    category = "Storage"
    version  = "1.0.0"
  })

  policy_rule = file("${path.module}/../policies/custom/require-storage-tls12.json")
}

# Enterprise Security Baseline Initiative (Policy Set)
resource "azurerm_policy_set_definition" "enterprise_baseline" {
  name         = "enterprise-security-baseline"
  policy_type  = "Custom"
  display_name = "Enterprise Security & Compliance Baseline Initiative"
  description  = "Bundles foundational Azure security guardrails for production environments."

  metadata = jsonencode({
    category = "Governance"
  })

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_public_ip.id
    reference_id         = "DenyPublicIP"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.enforce_tags.id
    reference_id         = "EnforceTags"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_tls12.id
    reference_id         = "RequireStorageTLS"
  }
}
