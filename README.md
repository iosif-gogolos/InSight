# InSight – iOS Self-Assessment App

## Projektübersicht
**InSight** ist eine native iOS-Anwendung, die es Nutzer:innen ermöglicht, strukturierte Selbsteinschätzungen durchzuführen und diese persistent zu speichern.  
Das Projekt wurde im Rahmen des Kurses **Apple Mobile Solution Development II (DLAMSD02)** entwickelt.

- **Verfasser:** Iosif Gogolos  
- **Matrikelnummer:** 42304582  
- **Studiengang:** B.Sc. Softwareentwicklung  
- **Tutor:** Prof. Dr. Holger Klus  
- **Datum:** 01.09.2025  

---

## Projektziele
Die App verfolgt folgende Kernziele:
1. Interaktive Durchführung von Fragebogen-basierten Assessments  
2. Automatische Auswertung und Kategorisierung von Antworten  
3. Persistente Speicherung von Testergebnissen  
4. Export- und Sharing-Funktionalitäten  
5. Benutzerfreundliche Navigation und moderne Benutzeroberfläche  

---

## Technologien & Architektur
- **Programmiersprache:** Swift  
- **Frameworks:** SwiftUI, SwiftData  
- **Architekturpattern:** MVVM (Model-View-ViewModel)  
- **Design:** Human Interface Guidelines (Apple), Usability Engineering, User-Centered Design  

---

## 📱 Features
- **App-Struktur & Navigation**: Hierarchische NavigationStack-Struktur mit modularer Architektur  
- **Fragebogen-System**: 5-Punkt-Likert-Skala, JSON-basiertes Fragenmanagement  
- **Persistenz**: Speicherung via SwiftData (inkl. Query-System & Sortierung)  
- **Export & Sharing**: Custom UTType für Ergebnisausgabe (Share-Mechanismus in Planung)  
- **UI/UX**:  
  - SplashScreen mit Animation  
  - Intuitives Fragebogen-Interface  
  - Konsistentes Farbschema (Blau/Türkis)  
  - Dark-Mode-Unterstützung  
- **Testing & Qualitätssicherung**:  
  - Datenpersistenz  
  - Responsivität auf verschiedenen iOS-Geräten  
  - Eingabevalidierung  
  - Dark-Mode Kompatibilität  

---

## Datenmodell
- **Question-Modell**:  
  - `@Model` (SwiftData) + `Codable` (JSON)  
  - Lokale Persistierung & flexibler Datenaustausch  

- **TestSession-Modell**:  
  - Aggregiert alle Daten einer Testsitzung  
  - Automatische Generierung von Ergebnis-Zusammenfassungen  

---

## Herausforderungen & Lösungen
- **Navigation-Komplexität** → Callback-Mechanismus über Closure-Parameter  
- **Datenvalidierung** → Präventive Validierung + benutzerfreundliche Fehlermeldungen  
- **Performance** → SwiftData Query-System mit Sortierung  

---

## Fazit & Ausblick
**InSight** erfüllt alle definierten Anforderungen und ist als vollständig funktionsfähige iOS-App einsatzbereit.  
Das Projekt zeigt die Vorteile von SwiftUI, MVVM und iterativer Entwicklung in der Praxis.  

### Zukünftige Erweiterungen
- Cloud-Synchronisation (geräteübergreifende Nutzung)  
- Erweiterte Analysefunktionen (statistische Trends)  
- Benutzerdefinierte Fragebogen-Templates  
- Machine-Learning-Integration für personalisierte Empfehlungen  

---

## Literatur
- [Human Interface Guidelines – Apple Developer](https://developer.apple.com/design/human-interface-guidelines)  
- [Develop in Swift Explorations – Apple Books](https://books.apple.com/us/book/develop-in-swift-explorations/id6468968126)  
- WWDC Sessions (SwiftUI, SwiftData, Observation API)  
- T. Sillmann (2022). *Das Swift-Handbuch*. Hanser  

