//
//  ProductDetail.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/23/22.
//

import SwiftUI

struct ProductDetail: View {
    var product : Product
    var body: some View {
        VStack{
            if let unwrappedClassification = product.classification
            {
                Text(unwrappedClassification.category.capitalized)
                    .font(.caption.smallCaps())
                    .foregroundColor(.gray)
            }
//            Text("almonds")
//                .font(.caption.smallCaps())
//                .foregroundColor(.gray)
            Text(product.title)
        }
    }
}

struct ProductDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetail(product: Product())
    }
}
