//
//  Evaluation.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import Foundation

/// Berechnet Durchschnittswerte pro Domain, gibt Top-2 Stärken (Strings) und Schwächste Domain als Vorschlag zurück.
func evaluateDomains(from questions: [Question]) -> (strengths: [String], suggestions: [String], perDomain: [String: Double]) {
    var map = [String: [Int]]()
    for q in questions {
        map[q.domain, default: []].append(q.answerValue)
    }

    var perDomain = [String: Double]()
    for (d, vals) in map {
        perDomain[d] = vals.isEmpty ? 0.0 : Double(vals.reduce(0, +)) / Double(vals.count)
    }

    // Sortiere Domains absteigend nach Score (Array von (key, value))
    let sorted = perDomain.sorted { $0.value > $1.value }

    // Top 2 als Stärken (formatierte Strings)
    let strengths = sorted.prefix(2).map { "\($0.key) (\(String(format: "%.1f", $0.value)))" }

    // Schwächste Domain bestimmen (als String-Array oder leer)
    let weakestKey = sorted.last?.0 ?? ""
    let suggestions = weakestKey.isEmpty ? [] : [weakestKey]

    return (strengths, suggestions, perDomain)
}

