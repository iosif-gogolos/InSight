//
//  UTType+TestResults.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//
import UniformTypeIdentifiers

extension UTType {
    static var testResults = UTType(exportedAs: "com.iosifgogolos.insight.testResults")
}

// Zusätzlich für bessere Kompatibilität:
extension UTType {
    static var testInsight: UTType {
        UTType(exportedAs: "com.iosifgogolos.insight.testinsight")
    }
}
