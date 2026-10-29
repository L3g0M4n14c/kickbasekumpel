# Export-Compliance / App-Verschlüsselung (App Store Connect)

> **Zielgruppe**: Release-Verantwortliche
> **Zweck**: Beantwortung der Verschlüsselungsfragen bei jeder App-Übermittlung
> **Gültig ab**: Version 1.0.0 (Build 1)

---

## 📋 Kurzfassung

| Frage in App Store Connect | Antwort für Kickbasekumpel |
| --- | --- |
| Welche Art von Verschlüsselungsalgorithmen verwendest du? | **Standardmäßige Verschlüsselungsalgorithmen statt oder zusätzlich zu der im Betriebssystem von Apple verwendeten bzw. zugänglichen Verschlüsselung** |
| Proprietäre / nicht standardisierte Algorithmen? | **Nein** |
| Dokumentation (CCATS) nötig? | **Nein** |
| `ITSAppUsesNonExemptEncryption` | **`NO`** (in `ios/Runner/Info.plist` gesetzt) |

Damit entfällt das Beantworten der Verschlüsselungsfragen bei jedem weiteren Upload.

---

## 🔍 Warum diese Antwort?

Die App enthält **keine eigene Krypto-Implementierung**. Verschlüsselung entsteht
ausschließlich durch Bibliotheken, die etablierte Standardverfahren (IETF-Standards)
verwenden:

| Fundstelle | Verwendete Verschlüsselung | Standard? |
| --- | --- | --- |
| `package:http` / `dart:io` (`lib/data/services/http_client_wrapper.dart`, `kickbase_api_client.dart`) | TLS 1.2/1.3 (BoringSSL im Flutter-Engine-Bundle) zu `https://api.kickbase.com`, `https://www.ligainsider.de` | Ja (RFC 8446 / 5246) |
| `firebase_core`, `firebase_auth`, `cloud_firestore` | TLS/gRPC (BoringSSL), AES für lokalen Firestore-Cache, Keychain für Auth-Zustand | Ja (NIST/IETF) |
| `flutter_secure_storage` (`lib/data/services/token_storage.dart`) | iOS Keychain → Krypto des Apple-Betriebssystems | Ja (OS) |
| `cached_network_image` | HTTPS-Abruf von Bildern | Ja (RFC 8446) |
| `shared_preferences` | unverschlüsselte Plist/UserDefaults – **keine** Krypto | – |

Wichtig: Dart bringt seinen eigenen TLS-Stack (BoringSSL) mit und nutzt nicht
`URLSession`. Deshalb ist die Formulierung „**statt oder zusätzlich zu** der
Betriebssystem-Verschlüsselung“ korrekt – nicht „keinen der oben genannten“
(Option 4 gilt nur, wenn ausschließlich OS-eigene Krypto verwendet wird, z. B. bei
reinen `URLSession`-Apps).

Proprietäre oder nicht veröffentlichte Verfahren (Option 1/3) kommen im Code nicht
vor: keine eigene AES/RSA-Implementierung, keine Obfuskation als „Verschlüsselung“,
kein `dart:io`-`SecurityContext` mit abgeschalteter Zertifikatsprüfung.

---

## 📊 Apples Zuordnung (Referenz)

Apple dokumentiert in
[Export compliance documentation for encryption](https://developer.apple.com/help/app-store-connect/reference/export-compliance-documentation-for-encryption):

| Verwendete Verschlüsselung | Erforderliche Dokumentation |
| --- | --- |
| Nur Krypto des Apple-Betriebssystems | Keine |
| Branchenstandard, der **nicht** im Apple-Betriebssystem enthalten ist | Französische Verschlüsselungserklärung (nur bei Vertrieb in Frankreich) |
| Proprietäre, nicht standardisierte Verfahren | CCATS + französische Erklärung |

Für Kickbasekumpel gilt Zeile 2 (BoringSSL/Firebase-Krypto sind Standardverfahren,
die nicht Teil von iOS sind) → **kein CCATS**, keine Dokumentation zum Upload.

Ergänzend: [Complying with Encryption Export Regulations](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations)
– „the use of encryption that’s built into the operating system […] is exempt from
export documentation upload requirements“.

---

## ⚠️ Wann muss die Antwort überprüft werden?

Die Fragen erneut beantworten, sobald sich eine der folgenden Dinge ändert:

- Aufnahme einer eigenen Krypto-Implementierung (z. B. `cryptography`-Package,
  eigene AES-Verschlüsselung von Local-Storage-Dateien, verschlüsselte Backups)
- Verschlüsselung von nutzerseitigen Inhalten „Ende-zu-Ende“ (dann ist das
  Mass-Market-Exemption in der Regel nicht mehr einschlägig)
- Hinzufügen eines VPN-/Krypto-Kernprodukts
- Wechsel des TLS-Stacks auf eine Eigenimplementierung

Dann `ITSAppUsesNonExemptEncryption` auf `YES` setzen und die Dokumentation
(CCATS bzw. Self-Classification-Report) in App Store Connect hochladen.

---

## 🔗 Verwandte Ressourcen

- [ARCHITECTURE.md](../ARCHITECTURE.md) – Technologie-Stack
- [CI_CD_SETUP.md](CI_CD_SETUP.md) – Release-Pipeline (Fastlane / TestFlight)
