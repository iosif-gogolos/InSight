//
//  LaunchView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI

struct LaunchView: View {
    var onStartTest: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("PrimaryBlue"), Color("PrimaryTurquoise")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // App Icon und Titel
                VStack(spacing: 20) {
                    Image("StartIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 210, height: 200)
                    
                    Text("InSight")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("SoftWhite"))
                    
                    Text("Dein einfaches, interaktives Self-Assessment-Tool zur Selbsteinschätzung")
                        .foregroundColor(Color("SoftWhite"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Start Button
                Button(action: onStartTest) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Jetzt starten")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryTurquoise"))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}
