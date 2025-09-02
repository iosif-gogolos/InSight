//
//  QuestionView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI

struct QuestionView: View {
    @Binding var question: Question
    var progress: Double

    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: progress)
                .padding(.horizontal)
            Text(question.text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { value in
                    Button {
                        question.answerValue = value
                    } label: {
                        Text("\(value)")
                            .frame(width: 48, height: 48)
                            .background(question.answerValue == value ? Color("PrimaryTurquoise") : Color("SoftWhite"))
                            .foregroundColor(.primary)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color("AppLightGray"), lineWidth: 1))
                        
                        
                    }
                    .buttonStyle(.plain)
                    
                }
            }
            Spacer()
        }
        .padding()
        
    }
}

struct QuestionView_Previews: PreviewProvider {
    @State static var q = Question(text: "Preview Frage", domain: "Demo", answerValue: 0)
    static var previews: some View {
        QuestionView(question: $q, progress: 0.3)
    }
}
