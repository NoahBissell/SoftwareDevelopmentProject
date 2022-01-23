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
    

    var body : some View {
        NavigationView{
            VStack{
                Form{
                    Section(header: Text("All products")){
                        List(kitchen.products){ product in
                            Text(product.title)
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
