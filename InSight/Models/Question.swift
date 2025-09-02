//
//  Question.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import Foundation
import SwiftData

@Model
final class Question {
    var id: UUID
    var text: String
    var domain: String
    var answerValue: Int

    init(text: String, domain: String, answerValue: Int = 0) {
        self.id = UUID()
        self.text = text
        self.domain = domain
        self.answerValue = answerValue
    }
}
