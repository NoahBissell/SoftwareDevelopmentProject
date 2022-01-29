//
//  KitchenView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/22/22.
//

import SwiftUI

struct KitchenView: View {
    @ObservedObject var kitchen : Kitchen
    @State var isAddViewActive = false
    @State var navigateTo : AnyView?
    
    func deleteProduct(at offsets: IndexSet){
        kitchen.removeProduct(at: offsets)
    }
    func deleteIngredient(at offsets: IndexSet){
        kitchen.removeIngredient(at: offsets)
    }
    
    var body : some View {
        NavigationView{
            VStack{
                Form{
                    Section(header: Text("All products")){
                        List {
                            ForEach(kitchen.products.indices, id: \.self){ index in
                                NavigationLink(
                                    destination: ProductView(product: $kitchen.products[index]),
                                    
                                    label: {
                                        ProductDetail(product: kitchen.products[index])
                                    })
                            }
                            .onDelete(perform: deleteProduct)
                        }
                    }
                    Section(header: Text("Ingredients")){
                        List {
                            ForEach(kitchen.ingredients.indices, id: \.self){ index in
                                NavigationLink(destination: IngredientView(ingredient: $kitchen.ingredients[index])) {
                                    Text(kitchen.ingredients[index].getName())
                                }
                                
                            }
                            .onDelete(perform: deleteIngredient)
                        }
                    }
                    
                }
            }
            .navigationTitle("My Kitchen")
            .toolbar {
                Menu {
                    Button("Add a product") {
                        navigateTo = AnyView(AddProductView(kitchen: kitchen))
                        isAddViewActive = true
                    }
                    Button("Add an ingredient"){
                        navigateTo = AnyView(AddIngredientView(kitchen: kitchen))
                        isAddViewActive = true
                    }
                    
                } label: {
                    Image(systemName: "plus")
                }
                .background(
                    NavigationLink(destination: navigateTo, isActive: $isAddViewActive){
                    EmptyView()
                })
                
            }
        }
    }
}

struct KitchenView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenView(kitchen: Kitchen())
    }
}
