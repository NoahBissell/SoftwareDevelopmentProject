//
//  CardView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/26/22.
//

import SwiftUI
import Kingfisher

struct CardView: View {
    var image : String
    var kfImage : URL?
    var title : String
    var description : String
    
    var body: some View {
        VStack{
            if(kfImage != nil){
                KFImage(kfImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            else{
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            HStack {
                VStack (alignment: .leading) {
                    Text(title)
                        .foregroundColor(.primary)
                        .font(.title)
                        .fontWeight(Font.Weight.heavy)
                    Text(description)
                        .foregroundColor(.primary)
                        .font(.caption)
                        .fontWeight(.thin)
                }
                
            }
            .padding()
            
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 90/255, green: 90/255, blue: 90/255, opacity: 0.1),  lineWidth: 1)
        )
        .padding([.top, .horizontal, .bottom])
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(image: "BrowseRecipe Image", title: "Browse Recipes", description: "Broaden your horizons by giving some new foods or recipes a try.")
    }
}
