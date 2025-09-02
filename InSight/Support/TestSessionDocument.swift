//
//  TestSessionDocument.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct TestSessionDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.testResults] }

    var session: TestSession

    init(session: TestSession = TestSession(title: "Neues Ergebnis")) {
        self.session = session
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let codableSession = try JSONDecoder().decode(CodableTestSession.self, from: data)
            self.session = TestSession.fromCodable(codableSession)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let codableSession = session.toCodable()
        let data = try JSONEncoder().encode(codableSession)
        return .init(regularFileWithContents: data)
    }
}
