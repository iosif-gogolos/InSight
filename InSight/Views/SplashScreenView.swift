//
//  SplashScreenView.swift
//  InSight
//
//  Created by Iosif Gogolos on 02.09.25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale: Double = 0.8
    @State private var logoOpacity: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color("PrimaryBlue"), Color("PrimaryTurquoise")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("InSight")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("SoftWhite"))
                    .opacity(logoOpacity)
                
                
                Image("StartIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
            
                VStack(spacing: 4) {
                    Text("Iosif Gogolos")
                        .font(.headline)
                        .foregroundColor(Color("SoftWhite"))
                    
                    Text("Productions")
                        .font(.subheadline)
                        .foregroundColor(Color("SoftWhite").opacity(0.8))
                }
                .opacity(logoOpacity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            // Nach 2.5 Sekunden zur Hauptapp wechseln
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            MainTabView()  // Korrigiert von MainAppView() zu MainTabView()
        }
    }
}
