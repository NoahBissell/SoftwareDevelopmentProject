//
//  CardView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/26/22.
//

import SwiftUI

struct CardView: View {
    var image : String
    var title : String
    var description : String
    
    var body: some View {
        ZStack{
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                VStack (alignment: .center) {
                    Text(title)
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(Font.Weight.heavy)
//                    Text(description)
//                        .font(.body)
//                        .foregroundColor(.white)
//                        .fontWeight(.bold)
                }
                
            }
            .padding()
            
        }
        .cornerRadius(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1),  lineWidth: 1)
//        )
        .padding([.top, .horizontal, .bottom])
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(image: "BrowseRecipe Image", title: "Browse Recipes", description: "Broaden your horizons by giving some new foods or recipes a try.")
    }
}
