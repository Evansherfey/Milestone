//
//  ContentView.swift
//  Milestone
//
//  Created by Student on 10/14/24.
//

import SwiftUI

struct drawText: ViewModifier {
    let font = Font.system(size: 25, weight: .black, design: .default)
    
    func body(content: Content) -> some View {
        content
            .font(font)
        
    }
}


struct DrawHorizontalText: View {
    var text: String
    var textResult: String
    
    
    var body: some View {
        HStack {
            Text(text)
                .modifier(drawText())
                .foregroundColor(Color.green)
            
            Text(textResult)
                .modifier(drawText())
                .foregroundColor(Color.red)
        }
    }
}


struct DrawImageView: View  {
    var imageName: String
    
    var body: some View {
        Text("\(imageName)")
            .padding()
            .padding()
            .background(Color.yellow)
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.red, lineWidth: 2))
            .shadow(color: .blue, radius: 3)
            .font(.largeTitle)
    }
}




struct ContentView: View {
    @State var currentChoice = 0
    @State var winOrLose = Bool.random()
    @State var totalScore = 0
    @State var showingScore = false
    
    @State var randomComputeChoice = Int.random(in: 0...2)
    
    let possibleMoves = ["Rock", "Paper", "Scissors"]
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .orange]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 100) {
                Text("Rock Paper Scissors")
                    .modifier(drawText())
                VStack(spacing: 50) {
                    
                    DrawHorizontalText(text: "You score is: ", textResult: "\(totalScore)")
                    
                    DrawImageView(imageName: "\(possibleMoves[randomComputeChoice])")
                    
                    DrawHorizontalText(text: "You will: ", textResult: winOrLose ? "Win" : "Lose")
                    
                    HStack {
                        ForEach(0 ..< possibleMoves.count) { number in
                            Button(action: {
                                self.checkToWin(selectedName: self.possibleMoves[number])
                                
                            }) {
                                DrawImageView(imageName: "\(self.possibleMoves[number])")
                            }                        }
                    }
                }
                Spacer()
            }
        }.alert(isPresented: $showingScore) { () -> Alert in
            Alert(title: Text("You WIN"), message: Text("You score is \(self.totalScore)"), dismissButton: .default(Text("New Game")) {
                self.totalScore = 0
                self.winOrLose = Bool.random()
                self.randomComputeChoice = Int.random(in: 0...2)
                })
        }
    }
    
    func checkToWin(selectedName: String) {
        guard let index = possibleMoves.firstIndex(where: { return $0 == possibleMoves[randomComputeChoice]}) else { return }
        let prefixArray = possibleMoves.prefix(upTo: index)
        let suffixArray = possibleMoves.suffix(from: index)
        
        let wrappedArray  = suffixArray + prefixArray
        
        guard let computedIndex = wrappedArray.firstIndex(where: { return $0 == possibleMoves[randomComputeChoice]}) else { return }
        guard let selectedIndex = wrappedArray.firstIndex(where: { return $0 == selectedName }) else { return }
        
        if winOrLose {
            totalScore += computedIndex + 1 == selectedIndex ? 1 : 0
        } else {
            totalScore += !(computedIndex + 1 == selectedIndex) ? 1 : 0
        }
        
        self.winOrLose = Bool.random()
        self.randomComputeChoice = Int.random(in: 0...2)
        
        runNewGame()
    }
    
    func runNewGame() {
        if self.totalScore == 10 {
            self.showingScore = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
