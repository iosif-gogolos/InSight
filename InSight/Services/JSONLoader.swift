//
//  JSONLoader.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import Foundation

struct RawQuestion: Codable {
    let id: Int
    let text: String
    let domain: String
}

struct QuestionsFile: Codable {
    let questions: [RawQuestion]
}

struct JSONLoader {
    static func loadQuestions(from resourceName: String) -> [Question]? {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let file = try decoder.decode(QuestionsFile.self, from: data)
            // Map raw -> Question (@Model instances). These will be plain objects until inserted into a ModelContext.
            let questions = file.questions.map { raw in
                Question(text: raw.text, domain: raw.domain)
            }
            return questions
        } catch {
            print("JSONLoader error: \(error)")
            return nil
        }
    }
}
