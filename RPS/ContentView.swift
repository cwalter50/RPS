//
//  ContentView.swift
//  RPS
//
//  Created by Christopher Walter on 4/15/20.
//  Copyright © 2020 Christopher Walter. All rights reserved.
//

// This was a challenge posed in 100 days of swiftui
// https://www.hackingwithswift.com/guide/ios-swiftui/2/3/challenge

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}



struct PictureText: View {
    var imageName: String

    var body: some View {
        VStack {
            Text(imageName)
                .bold()
                .font(.headline)
            Image(imageName)
                .resizable()
                .renderingMode(.original)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                .shadow(color: .black, radius: 2)
                .frame(width: UIScreen.screenWidth / 4, height: UIScreen.screenWidth / 4, alignment: .center)

        }
        
    }
}

struct ContentView: View {
    
    @State private var options: [String] = ["ROCK", "PAPER", "SCISSORS"]
    
    @State private var shouldWin = Bool.random() // this will keep track of wether the player whould win or lose in RPS.
    @State private var currentChoice = Int.random(in: 0..<3) // this will be 0, 1 or 2. It will link to a variable in options.
    
    @State var winTotal = 0 // this will keep track of how many wins.
    @State var rounds = 0 // this will keep track of total rounds played
    
    // this is for the alert
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    func askQuestion() {
        currentChoice = Int.random(in: 0..<options.count)
        shouldWin = Bool.random()
    }
    
    func buttonTapped(_ number: Int)
    {
        let compChoice = options[currentChoice]
        let playerChoice = options[number]
        // logic to check for winner
        if shouldWin == true
        {
            if (compChoice == "ROCK" && playerChoice == "PAPER") || (compChoice == "PAPER" && playerChoice == "SCISSORS") || (compChoice == "SCISSORS" && playerChoice == "ROCK")
            {
                scoreTitle = "Correct Choice! \(playerChoice) beats \(compChoice)"
                winTotal += 1
            }
            else
            {
                scoreTitle = "Wrong! \(playerChoice) does NOT beat \(compChoice)"
            }
        }
        else
        {
           if (compChoice == "ROCK" && playerChoice == "SCISSORS") || (compChoice == "PAPER" && playerChoice == "ROCK") || (compChoice == "SCISSORS" && playerChoice == "PAPER")
            {
                scoreTitle = "Correct Choice! \(playerChoice) loses to \(compChoice)"
                winTotal += 1
            }
           else
           {
                scoreTitle = "Wrong! \(playerChoice) does NOT lose to \(compChoice)"
            }
        }
        rounds += 1
        showingScore = true

    }
    
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [.white,.yellow,.orange]), center: UnitPoint.center, startRadius: 20, endRadius: 500)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("Computer Choice")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                PictureText(imageName: "\(options[currentChoice])")
                Spacer()
                Text(shouldWin ? "Pick the choice to WIN": "Pick the choice to LOSE")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                    
                HStack {
                    Spacer()
                    ForEach(0..<3) { number in
                        Button(action: {
                            self.buttonTapped(number)
                        }) {
                            PictureText(imageName: self.options[number])
//                            Text("\(self.options[number])")
                        }
                        Spacer()

                    }
                }
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text("You are \(winTotal)/\(rounds)"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                    })
            }
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
