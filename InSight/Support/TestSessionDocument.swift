//
//  TestSwssionDocument.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct TestSessionDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.testResults] }

    var session: TestSession

    // Standard: leeres Dokument
    init(session: TestSession = TestSession(title: "Neues Ergebnis")) {
        self.session = session
    }

    // Laden aus Datei
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let decoded = try JSONDecoder().decode(TestSession.self, from: data)
            self.session = decoded
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    // Speichern in Datei
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(session)
        return .init(regularFileWithContents: data)
    }
}
