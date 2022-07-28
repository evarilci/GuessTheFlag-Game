//
//  SplashScreenView.swift
//  GuessTheFlag
//
//  Created by Eymen Varilci on 28.07.2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
  
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack{
                VStack {
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear() {
                    withAnimation(.easeIn(duration: 1.0)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
