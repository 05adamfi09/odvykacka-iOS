//
//  MotivationView.swift
//  odvykacka
//
//  Created by Filip Adámek on 30.05.2023.
//

import SwiftUI

struct MotivationView: View {
    
    @StateObject var viewModel: MainViewModel
    
    
    @Binding var isPresented: Bool
    
    var citates = [
        "Just one small positive thought in the morning can change your whole day.",
        "Opportunities don't happen, you create them.",
        "Love your family, work super hard, live your passion.",
        "It is never too late to be what you might have been.",
        "Don't let someone else's opinion of you become your reality.",
        "If you’re not positive energy, you’re negative energy.",
        "I am not a product of my circumstances. I am a product of my decisions.",
        "Do the best you can. No one can do more than that.",
        "If you can dream it, you can do it.",
        "Do what you can, with what you have, where you are.",
        "Don’t let yesterday take up too much of today.",
        "To know how much there is to know is the beginning of learning to live."
    
    ]
    

    
    var body: some View {
        NavigationView(){
            
                    ZStack(){
                        Image(uiImage: (viewModel.getUser()?.motivationPicture ?? UIImage(named: "motivation_basic")) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                         StrokeText(text: citates.randomElement() ?? "You must be strong!", width: 0.5, color: .black)
                         .foregroundColor(.white)
                         .font(.title)
                         
                    }
                    
                    
                    
                    .toolbar{
                        ToolbarItemGroup(placement: .navigationBarTrailing){
                            Button{
                                isPresented.toggle()
                            } label: {
                                Text("Close")
                            }
                        }
                    }
                
        }
            
    }
    
    
    
    
    
}
