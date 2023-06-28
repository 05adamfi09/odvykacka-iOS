//
//  SplashScreenView.swift
//  odvykacka
//
//  Created by Filip Adámek on 21.06.2023.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var size = 0.8
    @State private var opacity = 0.5
        
    var body: some View {
                    VStack {
                        VStack {
                            Image(uiImage: UIImage( named: "splash_screen")!)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                            Text("Odvykačka")
                                .font(Font.custom("Baskerville-Bold", size: 26))
                                .foregroundColor(.black.opacity(0.80))
                        }
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.size = 0.9
                                self.opacity = 1.00
                            }
                        }
                    }
                    
                }
            
        }



