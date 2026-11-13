resource "zentral_mdm_blueprint" "default" {
  name                            = "Default"
  collect_apps                    = "ALL"
  collect_certificates            = "ALL"
  collect_profiles                = "ALL"
  legacy_profiles_via_ddm         = true
  filevault_config_id             = zentral_mdm_filevault_config.default.id
  recovery_password_config_id     = zentral_mdm_recovery_password_config.default.id
  software_update_enforcement_ids = [zentral_mdm_software_update_enforcement.default.id, zentral_mdm_software_update_enforcement.default-27.id]
}

# FileVault

resource "zentral_mdm_filevault_config" "default" {
  name                         = "Default"
  escrow_location_display_name = "Zentral Cloud"
  at_login_only                = true
  bypass_attempts              = 0
  destroy_key_on_standby       = true
  show_recovery_key            = false
}

# Recovery password

resource "zentral_mdm_recovery_password_config" "default" {
  name = "Default"
}

# Software update enforcement

resource "zentral_mdm_software_update_enforcement" "default" {
  name           = "Default"
  platforms      = ["macOS"]
  max_os_version = "27"
  delay_days     = 7
  details_url    = "https://support.apple.com/en-us/122868"
}

resource "zentral_mdm_software_update_enforcement" "default-27" {
  name           = "macOS 27"
  platforms      = ["macOS"]
  max_os_version = "28"
  delay_days     = 7
}

# Bootstrap package

resource "zentral_mdm_blueprint_artifact" "bootstrap-pkg" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.bootstrap-pkg.id
  macos        = true
}

# All

resource "zentral_mdm_blueprint_artifact" "servicemanagement" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.servicemanagement.id
  macos        = true
}

# Santa

resource "zentral_mdm_blueprint_artifact" "santa-tcc" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.santa-tcc.id
  macos        = true
}

resource "zentral_mdm_blueprint_artifact" "santa-system-extension-policy" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.santa-system-extension-policy.id
  macos        = true
}

resource "zentral_mdm_blueprint_artifact" "santa-notificationsettings" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.santa-notificationsettings.id
  macos        = true
}

resource "zentral_mdm_blueprint_artifact" "santa-default-configuration" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.santa-default-configuration.id
  macos        = true
}

# Monolith

resource "zentral_mdm_blueprint_artifact" "monolith-default-enrollment" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.monolith-default-enrollment.id
  macos        = true
}

resource "zentral_mdm_blueprint_artifact" "managedsoftwareupdate-tcc" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.managedsoftwareupdate-tcc.id
  macos        = true
}

# Osquery

resource "zentral_mdm_blueprint_artifact" "osquery-tcc" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.osquery-tcc.id
  macos        = true
}

resource "zentral_mdm_blueprint_artifact" "system-logging" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.system-logging.id
  macos        = true
}

resource "zentral_mdm_blueprint_artifact" "arte-macos" {
  blueprint_id = zentral_mdm_blueprint.default.id
  artifact_id  = zentral_mdm_artifact.arte-macos.id
  macos        = true
}



# Buffet

resource "zentral_mdm_blueprint_artifact" "buffet-macos" {
  blueprint_id      = zentral_mdm_blueprint.default.id
  artifact_id       = zentral_mdm_artifact.buffet-macos.id
  macos             = true
  macos_min_version = "27"
}

resource "zentral_mdm_artifact" "buffet-macos" {
  name      = "Buffet - macOS"
  type      = "Configuration"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_declaration" "buffet-macos-1" {
  artifact_id = zentral_mdm_artifact.buffet-macos.id
  source = jsonencode({
    Type        = "com.apple.configuration.app.managed",
    Identifier  = "com.zentral.buffet-macos",
    ServerToken = "839FF4D8-EE1A-475A-9F4C-CEFE9DBCBEC0",
    Payload = {
      BundleID = "com.zentral.buffet"
      AppConfig = {
        AppConfigDictionary = {
          DataAssetReference = "ztl:${zentral_mdm_artifact.buffet-macos-config-dict.id}"
        }
      }
    }
  })
  macos   = true
  version = 1
}

resource "zentral_mdm_declaration" "buffet-macos-2" {
  artifact_id = zentral_mdm_artifact.buffet-macos.id
  source = jsonencode({
    Type        = "com.apple.configuration.app.managed",
    Identifier  = "com.zentral.buffet-macos",
    ServerToken = "3EC62500-1EFD-4E91-A058-EC2F88E16A45",
    Payload = {
      BundleID = "com.zentral.buffet"
      InstallBehavior = {
        Install = "Required"
        License = {
          Assignment = "Device"
        }
      }
      UpdateBehavior = {
        AutomaticAppUpdates = "AlwaysOn"
      }
      AppConfig = {
        AppConfigDictionary = {
          DataAssetReference = "ztl:${zentral_mdm_artifact.buffet-macos-config-dict.id}"
        }
      }
    }
  })
  macos   = true
  version = 2
}


resource "zentral_mdm_artifact" "buffet-macos-config-dict" {
  name      = "Buffet - Config Dict - macOS"
  type      = "Data Asset"
  channel   = "Device"
  platforms = ["macOS"]
}

resource "zentral_mdm_data_asset" "buffet-macos-config-dict-1" {
  artifact_id = zentral_mdm_artifact.buffet-macos-config-dict.id
  type        = "PLIST"
  source = base64encode(<<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>about</key>
    <dict>
      <key>markdown</key>
      <string># Acme Software Catalog (macOS)

Apps on this list are approved and paid for by Acme IT. Installing from here keeps
your device compliant — apps installed from elsewhere are **not** supported and may
be removed automatically.

## Installing an app

1. Tap the app you want.
2. Tap **Install**. The download starts immediately over Wi-Fi.
3. The app appears on your Home Screen when it finishes.

Large apps pause on cellular. Reconnect to Wi-Fi and the download resumes on its own.

## What IT can and cannot see

| Visible to IT             | Not visible to IT        |
| ------------------------- | ------------------------ |
| Managed apps and versions | Personal apps            |
| Device model and OS build | Photos, messages, email  |
| Serial number             | Location                 |
| Compliance status         | Safari history           |

> Personal data on a personally-owned device stays private. IT administers only the
> apps and profiles it installed.

## If an app is missing

Apps are assigned per team. If something you need is not listed, request it — do not
install it from the App Store and expect support.

- **Request an app:** [service desk](https://help.acme.example/apps/new)
- **Report a broken app:** [it-support@acme.example](mailto:it-support@acme.example)
- **Urgent, business-critical only:** +1 555 0100, 24/7

## Support hours

| Region        | Hours                | Response target |
| ------------- | -------------------- | --------------- |
| Europe        | 08:00–18:00 CET      | 4 business h    |
| Americas      | 09:00–19:00 ET       | 4 business h    |
| Asia-Pacific  | 09:00–18:00 SGT      | 8 business h    |

---

Acme IT · Catalog policy `v2.4` · Updated August 2026
      </string>
    </dict>
  </dict>
</plist>
  EOT
  )
  macos   = true
  version = 1
}