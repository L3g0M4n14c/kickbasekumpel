# Release-Definition – KickbaseKumpel

> **Entwurf vom 2026-11-11.** Muss-Liste bitte zusammenstreichen und bestätigen.
> Maßstab: [Release-Checkliste](https://github.com/L3g0M4n14c/Gehirn/blob/main/05-playbooks/release-checkliste.md), **Stufe A**.

## Ziel

**TestFlight-Verteilung an Freunde.** Kein öffentlicher Store-Release, keine
Bezahlfunktion. Das passt auch zum Rechts-Check im Gehirn: Als nicht
kommerzielles Werkzeug im Freundeskreis ist das Risiko am kleinsten.

## Muss-Features für v1.0

| # | Feature | Fertig, wenn | Stand |
|---|---|---|---|
| 1 | Login mit Kickbase-Konto | Anmelden, Abmelden und Sitzung nach Neustart funktionieren auf dem iPhone | vorhanden, auf Gerät bestätigen |
| 2 | Team- und Marktübersicht | Eigener Kader und Transfermarkt der gewählten Liga laden fehlerfrei | vorhanden |
| 3 | Gebotsempfehlung | Empfehlung mit Begründung für jeden Marktspieler | vorhanden |
| 4 | Aufstellungs-Optimierung | Vorschlag mit erwarteten Punkten für den nächsten Spieltag | vorhanden |
| 5 | Verkaufs-Timing | Verkaufsempfehlung je Spieler im Kader | vorhanden |
| 6 | Liga-Wechsel | Mehrere Ligen eines Kontos lassen sich umschalten | prüfen |

## Nicht in v1

Alle zehn offenen Feature-Issues (#8, #11, #12, #14, #16, #19, #28, #29, #30, #31),
dazu alles aus `Ideen.md`, Paywall, Rebranding, Android-Store, Web als Produkt.

## Offene Blocker

- [ ] **Tote Bedienelemente entfernen oder ausblenden.** In den gerouteten Seiten
      unter `lib/presentation/pages/` und `lib/presentation/screens/` stehen 38
      `TODO`-Stellen, viele davon Buttons ohne Funktion (Einstellungen, Liga,
      Spieler-Detail, Passwort zurücksetzen).
- [ ] **KI-Kosten deckeln.** `firebase_vertexai` läuft auf dein Konto: Limit pro
      Nutzer und Budget-Alarm im Firebase-Projekt setzen.
- [ ] **iOS-Build bis TestFlight bestätigen.** iOS baut über Xcode Cloud
      (`ios/ci_scripts/`); der Stand dort ist von hier aus nicht einsehbar.
- [ ] Version und Build-Nummer für den ersten TestFlight-Build setzen (aktuell `1.0.0+1`).
- [ ] Test-Informationen in App Store Connect (Beschreibung, Feedback-Adresse);
      bei externen Testern Beta-Review einplanen.
- [ ] Kurzer Hinweis in der App: inoffiziell, keine Verbindung zu Kickbase.

## Bereits erfüllt

- CI auf `main` grün (Android-Verteilung, Web, Backend; Stand 2026-11-10)
- 62 Testdateien, dokumentierte Architektur
- Konto löschen ist in Auth-Schicht vorhanden
- Export-Compliance dokumentiert (`docs/EXPORT_COMPLIANCE.md`)
