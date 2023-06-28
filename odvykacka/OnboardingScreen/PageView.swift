//
//  PageView.swift
//  odvykacka
//
//  Created by Filip Adámek on 20.06.2023.
//

import SwiftUI

struct PageView: View {
    var page: Page
    
    var body: some View {
        VStack(spacing: 20){
            Image("\(page.imageUrl)")
                .resizable()
                .scaledToFit()
                .cornerRadius(30)
                .padding()
            Text(page.name)
                .font(.title)
            Text(page.description)
                .font(.subheadline)
                .frame(width: 300)
                .multilineTextAlignment(.center)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(page: Page.samplePage)
    }
}
