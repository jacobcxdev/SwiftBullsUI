//
//  ContentView.swift
//  SwiftBullsUI
//
//  Created by Jacob Clayden on 09/07/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var rTarget = Double.random(in: 0..<1)
    @State var gTarget = Double.random(in: 0..<1)
    @State var bTarget = Double.random(in: 0..<1)
    @State var rGuess = 0.5
    @State var gGuess = 0.5
    @State var bGuess = 0.5
    @State var showAlert = false
    @State var showInfo = false
    @State var rounds = 0
    @State var score = 0
    @State var average = 0
    
    var body: some View {
        return VStack {
            HStack {
                VStack {
                    Rectangle()
                        .foregroundColor(Color(red: rTarget, green: gTarget, blue: bTarget, opacity: 1))
                        .cornerRadius(10)
                    Text("Match this colour!")
                        .foregroundColor(Color(red: rTarget, green: gTarget, blue: bTarget))
                        .bold()
                        .scaledToFill()
                        .padding()
                        .background(Color(white: (rTarget + gTarget + bTarget) / 3 > 0.5 ? 1 - ((rTarget + gTarget + bTarget) / 3 - 0.5) * 2 : 1))
                        .cornerRadius(10)
                }
                VStack {
                    Rectangle()
                        .foregroundColor(Color(red: rGuess, green: gGuess, blue: bGuess, opacity: 1))
                        .cornerRadius(10)
                    HStack {
                        Text("R: \(Int(rGuess * 255))")
                            .foregroundColor(.init(red: rGuess, green: 0, blue: 0))
                            .scaledToFill()
                            .padding(5)
                            .background(Color(white: rGuess > 0.5 ? 1 - (rGuess - 0.5) * 2 : 1))
                            .cornerRadius(10)
                        Text("|")
                            .foregroundColor(.init(red: rGuess, green: gGuess, blue: 0))
                            .scaledToFill()
                            .padding(1)
                            .background(Color(white: (rGuess + gGuess) / 2 > 0.5 ? 1 - ((rGuess + gGuess) / 2 - 0.5) * 2 : 1))
                            .cornerRadius(10)
                        Text("G: \(Int(gGuess * 255))")
                            .foregroundColor(.init(red: 0, green: gGuess, blue: 0))
                            .scaledToFill()
                            .padding(5)
                            .background(Color(white: gGuess > 0.5 ? 1 - (gGuess - 0.5) * 2 : 1))
                            .cornerRadius(10)
                        Text("|")
                            .foregroundColor(.init(red: 0, green: gGuess, blue: bGuess))
                            .scaledToFill()
                            .padding(1)
                            .background(Color(white: (gGuess + bGuess) / 2 > 0.5 ? 1 - ((gGuess + bGuess) / 2 - 0.5) * 2 : 1))
                            .cornerRadius(10)
                        Text("B: \(Int(bGuess * 255))")
                            .foregroundColor(.init(red: 0, green: 0, blue: bGuess))
                            .scaledToFill()
                            .padding(5)
                            .background(Color(white: bGuess > 0.5 ? 1 - (bGuess - 0.5) * 2 : 1))
                            .cornerRadius(10)
                    }.padding(.vertical, 12)
                        .font(.system(size: 12))
                }
            }.padding()
                .frame(minHeight: 0, maxHeight: .infinity)

            VStack {
                ColourSlider(value: $rGuess, textColor: .red)
                ColourSlider(value: $gGuess, textColor: .green)
                ColourSlider(value: $bGuess, textColor: .blue)
            }

            HStack {
                Button(action: {
                    self.rounds = 0
                    self.score = 0
                    self.average = 0
                    self.rTarget = Double.random(in: 0..<1)
                    self.gTarget = Double.random(in: 0..<1)
                    self.bTarget = Double.random(in: 0..<1)
                }) {
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                }.padding()

                Text("| Rounds: \(rounds) |")

                Button(action: {
                    self.score = self.computeScore()
                    self.showAlert = true
                }) {
                    Text("Hit Me!")
                        .foregroundColor(Color(red: rGuess, green: gGuess, blue: bGuess))
                        .bold()
                        .scaledToFill()
                        .padding()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Score"), message: Text("Your score for this round is \(score)!\n\nYou guessed:\nR: \(Int(rGuess * 255)) | G: \(Int(gGuess * 255)) | B: \(Int(bGuess * 255))\n\nThe true colour was:\nR: \(Int(rTarget * 255)) | G: \(Int(gTarget * 255)) | B: \(Int(bTarget * 255))\n\nThe difference is:\nR: \(Int((rTarget - rGuess) * 255).magnitude) | G: \(Int((gTarget - gGuess) * 255).magnitude) | B: \(Int((bTarget - bGuess) * 255).magnitude)"), dismissButton: .default(Text("Okay")) {
                        self.average = self.average * self.rounds + self.score
                        self.rounds += 1
                        self.average /= self.rounds
                        self.rTarget = Double.random(in: 0..<1)
                        self.gTarget = Double.random(in: 0..<1)
                        self.bTarget = Double.random(in: 0..<1)
                        })
                }
                    .background(Color(white: (rGuess + gGuess + bGuess) / 3 > 0.5 ? 1 - ((rGuess + gGuess + bGuess) / 3 - 0.5) * 2 : 1))
                    .cornerRadius(50)

                Text("| x̄ Pts.: \(average) |")

                Button(action: {
                    self.showInfo = true
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .alert(isPresented: $showInfo) {
                    Alert(title: Text("Instructions"), message: Text("Attempt to match the colour in the box on the right with the colour in the box on the left. You can do so by adjusting each of the three sliders. Finally, press the \"Hit Me!\" button to submit."))
                }.padding()
            }
            .scaledToFill()
        }
    }
    
    func computeScore() -> Int {
        let rDiff = rGuess - rTarget
        let gDiff = gGuess - gTarget
        let bDiff = bGuess - bTarget
        let diff = sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff)
        return Int((1 - diff) * 100 + 0.5)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(rGuess: 0.5, gGuess: 0.5, bGuess: 0.5)
    }
}
#endif

struct ColourSlider : View {
    @Binding var value: Double
    var textColor: Color
    var body: some View {
        return HStack {
            Text("0")
                .foregroundColor(textColor)
            Slider(value: $value, in: 0...1)
            Text("255")
                .foregroundColor(textColor)
        }.padding()
    }
}
