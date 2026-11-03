resource "zentral_mdm_blueprint" "mobile" {
  name                    = "Mobile"
  collect_apps            = "ALL"
  collect_certificates    = "ALL"
  collect_profiles        = "ALL"
  default_location_id     = data.zentral_mdm_location.default.id
  legacy_profiles_via_ddm = true
}

data "zentral_mdm_location" "default" {
  name = "petit-chou.zentral.cloud"
}


# Mobile

resource "zentral_mdm_blueprint_artifact" "slack" {
  blueprint_id = zentral_mdm_blueprint.mobile.id
  artifact_id  = zentral_mdm_artifact.slack.id
  ios          = true
  ipados       = true
}

resource "zentral_mdm_blueprint_artifact" "arte" {
  blueprint_id = zentral_mdm_blueprint.mobile.id
  artifact_id  = zentral_mdm_artifact.arte.id
  ios          = true
  ipados       = true
}

# Buffet

resource "zentral_mdm_blueprint_artifact" "mobile-buffet" {
  blueprint_id       = zentral_mdm_blueprint.mobile.id
  artifact_id        = zentral_mdm_artifact.buffet.id
  ios                = true
  ios_min_version    = "26"
  ipados             = true
  ipados_min_version = "26"
}

resource "zentral_mdm_artifact" "buffet" {
  name      = "Buffet - App"
  type      = "Configuration"
  channel   = "Device"
  platforms = ["iOS", "iPadOS"]
}

resource "zentral_mdm_declaration" "buffet-1" {
  artifact_id = zentral_mdm_artifact.buffet.id
  source = jsonencode({
    Type        = "com.apple.configuration.app.managed",
    Identifier  = "com.zentral.buffet",
    ServerToken = "ad71c059-179f-4ecd-980a-5a55ff30ca3a",
    Payload = {
      BundleID = "com.zentral.buffet"
      AppConfig = {
        AppConfigDictionary = {
          DataAssetReference = "ztl:${zentral_mdm_artifact.buffet-config-dict.id}"
        }
      }
    }
  })
  ios     = true
  ipados  = true
  version = 1
}


resource "zentral_mdm_artifact" "buffet-config-dict" {
  name      = "Buffet - Config Dict"
  type      = "Data Asset"
  channel   = "Device"
  platforms = ["iOS", "iPadOS"]
}

resource "zentral_mdm_data_asset" "buffet-config-dict-1" {
  artifact_id = zentral_mdm_artifact.buffet-config-dict.id
  type        = "PLIST"
  source = base64encode(<<-EOT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>about</key>
    <dict>
      <key>markdown</key>
      <string># Acme Software Catalog

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
  ios     = true
  ipados  = true
  version = 1
}