# Monolith

resource "zentral_mdm_artifact" "monolith-default-enrollment" {
  name      = "Monolith - Default enrollment"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "monolith-default-enrollment-1" {
  artifact_id = zentral_mdm_artifact.monolith-default-enrollment.id
  source = base64encode(
    templatefile(
      "${path.module}/mobileconfigs/monolith.default-enrollment.v1.mobileconfig",
      {
        fqdn   = var.fqdn,
        secret = zentral_monolith_enrollment.default.secret
      }
    )
  )
  macos   = true
  version = 1
}

resource "zentral_mdm_artifact" "managedsoftwareupdate-tcc" {
  name      = "managedsoftwareupdate - TCC"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "managedsoftwareupdate-tcc-1" {
  artifact_id = zentral_mdm_artifact.managedsoftwareupdate-tcc.id
  source      = filebase64("${path.module}/mobileconfigs/managedsoftwareupdate.tcc.v1.mobileconfig")
  macos       = true
  version     = 1
}

# Bootstrap package

resource "zentral_mdm_artifact" "bootstrap-pkg" {
  name                           = "Monolith - Bootstrap package"
  type                           = "Enterprise App"
  channel                        = "Device"
  platforms                      = ["macOS"]
  auto_update                    = false
  install_during_setup_assistant = true
  requires                       = [zentral_mdm_artifact.monolith-default-enrollment.id]
}

resource "zentral_mdm_enterprise_app" "bootstrap-pkg-2024-001" {
  artifact_id    = zentral_mdm_artifact.bootstrap-pkg.id
  package_uri    = "s3://zentral-pro-services-artifacts-eu-central-1/saas-public/bootstrap-2024.007.pkg"
  package_sha256 = "18b128e6e900ed42624ea9f574f7af8f3df8c6c8d0263981d6fee639c95b73f4"
  macos          = true
  version        = 1
}

resource "zentral_mdm_enterprise_app" "bootstrap-pkg-2026-001" {
  artifact_id    = zentral_mdm_artifact.bootstrap-pkg.id
  package_uri    = "s3://zentral-pro-services-artifacts-eu-central-1/saas-public/bootstrap-2026.009.pkg"
  package_sha256 = "21a449449fc89facab792682424b5d99c454f69d71a2b82bab62b7eb2947812e"
  macos          = true
  version        = 2
}

# All

resource "zentral_mdm_artifact" "servicemanagement" {
  name      = "All - Managed Login Items settings"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "servicemanagement-1" {
  artifact_id = zentral_mdm_artifact.servicemanagement.id
  source      = filebase64("${path.module}/mobileconfigs/all.servicemanagement.v1.mobileconfig")
  macos       = true
  version     = 2
}

# Google Santa

resource "zentral_mdm_artifact" "santa-tcc" {
  name      = "Santa - TCC"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "santa-tcc-1" {
  artifact_id = zentral_mdm_artifact.santa-tcc.id
  source      = filebase64("${path.module}/mobileconfigs/santa.tcc.v1.mobileconfig")
  macos       = true
  version     = 1
}

resource "zentral_mdm_artifact" "santa-system-extension-policy" {
  name      = "Santa - System Extension policy"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "santa-system-extension-policy-1" {
  artifact_id = zentral_mdm_artifact.santa-system-extension-policy.id
  source      = filebase64("${path.module}/mobileconfigs/santa.system-extension-policy.v1.mobileconfig")
  macos       = true
  version     = 1
}

resource "zentral_mdm_artifact" "santa-notificationsettings" {
  name      = "Santa - Notification settings"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "santa-notificationsettings-1" {
  artifact_id = zentral_mdm_artifact.santa-notificationsettings.id
  source      = filebase64("${path.module}/mobileconfigs/santa.notificationsettings.v1.mobileconfig")
  macos       = true
  version     = 1
}

resource "zentral_mdm_artifact" "santa-default-configuration" {
  name      = "Santa - Default configuration"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "santa-default-configuration-1" {
  artifact_id = zentral_mdm_artifact.santa-default-configuration.id
  source = base64encode(
    templatefile(
      "${path.module}/mobileconfigs/santa.default-configuration.v1.mobileconfig",
      {
        fqdn   = var.fqdn,
        secret = zentral_santa_enrollment.default.secret
      }
    )
  )
  macos   = true
  version = 1
}

# Osquery

resource "zentral_mdm_artifact" "osquery-tcc" {
  name      = "Osquery - TCC"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "osquery-tcc-1" {
  artifact_id = zentral_mdm_artifact.osquery-tcc.id
  source      = filebase64("${path.module}/mobileconfigs/osquery.tcc.v1.mobileconfig")
  macos       = true
  version     = 1
}

resource "zentral_mdm_artifact" "system-logging" {
  name      = "system logging - enable private data"
  type      = "Profile"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_profile" "system-logging-1" {
  artifact_id = zentral_mdm_artifact.system-logging.id
  source      = filebase64("${path.module}/mobileconfigs/system.logging.v1.mobileconfig")
  macos       = true
  version     = 1
}


# mobile apps


resource "zentral_mdm_artifact" "slack" {
  name      = "Slack mobile app (required)"
  type      = "Configuration"
  channel   = "Device"
  platforms = ["iOS", "iPadOS"]
}

resource "zentral_mdm_declaration" "slack-1" {
  artifact_id = zentral_mdm_artifact.slack.id
  source = jsonencode({
    Type        = "com.apple.configuration.app.managed",
    Identifier  = "cloud.zentral.petit-chou.configuration.slack",
    ServerToken = "1324DEB8-38C5-4792-9E77-805D97000FED",
    Payload = {
      AppStoreID = "618783545"
      UpdateBehavior = {
        AutomaticAppUpdates = "AlwaysOn"
      }
      InstallBehavior = {
        Install = "Required"
        License = {
          Assignment = "Device"
        }
      }
    }
  })
  ios     = true
  ipados  = true
  version = 1
}


resource "zentral_mdm_artifact" "arte" {
  name      = "Arte iOS app (optional)"
  type      = "Configuration"
  channel   = "Device"
  platforms = ["iOS", "iPadOS"]
}

resource "zentral_mdm_declaration" "arte-1" {
  artifact_id = zentral_mdm_artifact.arte.id
  source = jsonencode({
    Type        = "com.apple.configuration.app.managed",
    Identifier  = "cloud.zentral.petit-chou.configuration.arte",
    ServerToken = "FCE25E9E-8BD6-4513-94B3-CC80FF8C1238",
    Payload = {
      AppStoreID = "405028510"
      UpdateBehavior = {
        AutomaticAppUpdates = "AlwaysOn"
      }
      InstallBehavior = {
        Install = "Optional"
        License = {
          Assignment = "Device"
        }
      }
    }
  })
  ios     = true
  ipados  = true
  version = 1
}

resource "zentral_mdm_artifact" "arte-macos" {
  name      = "Arte macOS app (optional)"
  type      = "Configuration"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_declaration" "arte-macos-2" {
  artifact_id = zentral_mdm_artifact.arte-macos.id
  source = jsonencode({
    Type        = "com.apple.configuration.app.managed",
    Identifier  = "cloud.zentral.petit-chou.configuration-macos.arte",
    ServerToken = "AC0217CD-162E-44FA-8535-784EE5593495",
    Payload = {
      AppStoreID = "405028510"
      UpdateBehavior = {
        AutomaticAppUpdates = "AlwaysOn"
      }
      InstallBehavior = {
        Install = "Optional"
        License = {
          Assignment = "Device"
        }
      }
    }
  })
  macos   = true
  version = 1
}
