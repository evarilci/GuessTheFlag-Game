//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Eymen Varilci on 26.07.2022.
//

import SwiftUI

struct FlagImage: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 8)
            
    }
}

extension View {
    
    func flagImageStyle() -> some View {
        modifier(FlagImage())
    }
}

struct ContentView: View {
    @State private var isCorrect = false
    @State private var isWrong = false
    @State private var fadeOutOpacity = false
    @State private var selectedNumber = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameOver = false
    @State private var currentRound = 0
    @State private var maxRound = 9
    @State private var countries = ["Estonia",
                                    "France",
                                    "Germany",
                                    "Ireland",
                                    "Italy",
                                    "Monaco",
                                    "Nigeria",
                                    "Poland",
                                    "Russia",
                                    "Spain",
                                    "UK",
                                    "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the Flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.bold))
                        Text(countries[correctAnswer])
                            .foregroundColor(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) {number in
                        Button {
                            
                            withAnimation {
                                flagTapped(number)
                                
                            }
                            
                            
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .flagImageStyle()
                                
                        }
                        .rotation3DEffect(.degrees(self.isCorrect && self.correctAnswer == number ? 360 : 0), axis: (x: 0, y: 1, z:0))
                        .opacity(self.fadeOutOpacity && !(correctAnswer == number) ? 0.25 : 1)
                        .rotation3DEffect(.degrees(self.isWrong && self.selectedNumber == number ? 90 : 0), axis: (x:1, y: 0, z: 0))
                    }
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Current Round is \(currentRound) of \(maxRound + 1)")
                    .foregroundColor(.white)
                    .font(.body.bold())
                Spacer()
                
                
                
            }
            .padding()
        }
        .alert(isPresented: $showingScore) {
            if gameOver {
                return Alert(title: Text("Game over"),
                             message:Text("Your score is \(score)"),
                             dismissButton: .default(Text("Restart")){
                    self.reset() // reset game here
                })
            } else {
                return Alert(title: Text(scoreTitle),
                             message:Text("Your score is \(score)"),
                             dismissButton: .default(Text("Continue")){
                    self.askQuestion()
                })
            }
        }
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        currentRound = 0
    }
    
    func flagTapped(_ number: Int) {
        selectedNumber = number
        if number == correctAnswer {
            
            withAnimation {
                score += 1
                scoreTitle = "Correct!"
                isCorrect = true
                fadeOutOpacity = true
            }
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])."
            fadeOutOpacity = true
            isWrong = true
        }
        
        gameOver = currentRound == maxRound
        // score = 0        // reset this at the "Restart" call
        // currentRound = 0 // reset this at the "Restart" call
        
        if currentRound < maxRound {
            currentRound += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showingScore = true
        }
       // showingScore = true
            
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isCorrect = false
        fadeOutOpacity = false
        isWrong = false
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
