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
        if let unwrappedClassification = product.classification
        {
            Text(unwrappedClassification.category)
        }
        else{
            Text(product.title)
        }
    }
}

struct ProductDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetail(product: Product())
    }
}
