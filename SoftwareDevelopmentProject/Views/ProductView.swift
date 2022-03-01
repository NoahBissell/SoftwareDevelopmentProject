//
//  ProductView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/23/22.
//

import SwiftUI
import struct Kingfisher.KFImage

struct ProductView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var product: Product
    
    var body: some View {
        
        VStack(spacing: 20){
            Text("Product: \(product.title)")
            if let unwrappedClassification = product.classification{
//                Text("Title: \(unwrappedClassification.cleanTitle)")
                Text("Category: \(unwrappedClassification.category)")
            }
            if(product.image != nil){
                KFImage(product.image)
            }
            
                Stepper("Amount: \(product.quantity)")
                {
                    if(product.quantity < 25){
                        if(product.storedQuantity != nil){
                            product.storedQuantity! += 1
                        }
                    }
                } onDecrement: {
                    if(product.quantity > 0){
                        if(product.storedQuantity != nil){
                            product.storedQuantity! -= 1
                        }
                    }
                }
            
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                    Button (action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    })
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: .constant(Product()))
    }
}
