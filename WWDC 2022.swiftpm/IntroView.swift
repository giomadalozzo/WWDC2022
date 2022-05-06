//
//  File.swift
//  WWDC 20222
//
//  Created by Giovanni Madalozzo on 24/04/22.
//

import Foundation
import SwiftUI

struct IntroView: View {
    @Binding var whichView: CurrentView
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Color(red: 58/255, green: 75/255, blue: 158/255)
                    .ignoresSafeArea()
                VStack{
                    Text("THE RESCUE").font(.custom("Arial-BoldMT", size: 80)).foregroundColor(Color.yellow).overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.yellow, lineWidth: 5)
                )
                    HStack{
                        Image("20_1").resizable().frame(width: 60, height: 50).padding(.top, 150)
                        Image("introBalloon").resizable().frame(width: 600, height: 300)
                    }.padding(.bottom, 100)
                    Button(action: {
                        self.whichView = .game
                    }) {
                        Text("Save the spies!").font(.custom("Arial-BoldMT", size: 20))
                    }
                    .padding()
                    .foregroundColor(Color(red: 58/255, green: 75/255, blue: 158/255))
                    .background(.white)
                    .cornerRadius(5)
                    .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.yellow, lineWidth: 5)
                            )
                    
                    Text("Recommended to play on landscape orientation :D").font(.custom("Arial-BoldMT", size: 18)).foregroundColor(Color.yellow).padding(.top, 100)
                }
            }
        }
    }
}

