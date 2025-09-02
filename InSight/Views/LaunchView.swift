//
//  LaunchView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("PrimaryBlue"), Color("PrimaryTurquoise")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            VStack(spacing: 24) {
                Image("StartIcon").resizable().frame(width: 210, height: 200)
                Text("InSight").font(.largeTitle.bold()).foregroundColor(Color("SoftWhite"))
                Text("Dein einfaches, interaktives Self-Assessment-Tool zur Selbsteinschätzung").foregroundColor(Color("SoftWhite"))
                NavigationLink {
                    QuestionFlowView()
                } label: {
                    Text("-> Jetzt starten")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color("PrimaryTurquoise"))
                .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}
