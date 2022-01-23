//
//  KitchenView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/22/22.
//

import SwiftUI

struct KitchenView: View {
    @EnvironmentObject var kitchen : Kitchen
    @State var isPresentingAddProduct : Bool = false
    
    func delete(at offsets: IndexSet){
        kitchen.products.remove(atOffsets: offsets)
    }
    
    var body : some View {
        NavigationView{
            VStack{
                Form{
                    Section(header: Text("All products")){
                        List {
                            ForEach(kitchen.products){ product in
                                NavigationLink(
                                    destination: ProductView(product: product),
                                               
                                    label: {
                                    ProductDetail(product: product)
                                })
                                
//                                if let unwrappedClassification = product.classification
//                                {
//                                    Text(unwrappedClassification.category)
//                                }
//                                else{
//                                    Text(product.aisle ?? product.title)
//                                }
                            }
                            .onDelete(perform: delete)
                        }
                        
                    }
                    
                }
            }
            .navigationTitle("My Kitchen")
            .toolbar {
                NavigationLink(destination: AddProductView()) {
                    Image(systemName: "plus")
                }
                
            }
        }.environmentObject(kitchen)
    }
}

struct KitchenView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenView()
    }
}
