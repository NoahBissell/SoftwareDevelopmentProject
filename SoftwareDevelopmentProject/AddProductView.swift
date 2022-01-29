//
//  AddProductView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/22/22.
//

import SwiftUI
import CodeScanner
import AVFoundation
import Kingfisher

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var kitchen : Kitchen
    @State var product : Product = Product()
    
    @State var scannedCode = "0000"
    @State var isPresentingScanner = false
    @State var isPresentingProductSearch = false
    @State var searchedProductList = [ProductResult]()
    @State var query = ""
    @State var searchedIngredientList = [IngredientResult]()
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [AVMetadataObject.ObjectType.ean13],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    
                    // convert EAN13 to UPC
                    self.scannedCode.removeFirst()
                    FetchData().getProductFromUPC(upc: scannedCode) { product in
                        self.product = kitchen.createProduct(product: product)
                        FetchData().classifyProduct(product: product) { classification in
                            self.product.classification = classification
                        }
                    }
                }
            })
    }
    
    var productSearchSheet : some View {
        
        VStack{
            Spacer()
            
            // For some reason the keyboard dismisses after typing the first character, can't seem to figure out why
            // Bug has gone away for me now, will keep this comment for reference
            Form{
                Section{
                    TextField(
                        "Search all grocery products",
                        text: $query)
                    
                    if(query.count > 0){
                        Button("Search"){
                            FetchData().searchProducts(query: query) { productList in
                                self.searchedProductList = productList
                            }
                        }
                    }
                    
                }
                Section{
                    List(searchedProductList){ productResult in
                        Button (action: {
                            FetchData().getProductFromId(id: productResult.id) { product in
                                self.product = kitchen.createProduct(product: product)
                                FetchData().classifyProduct(product: product) { classification in
                                    self.product.classification = classification
                                }
                                self.isPresentingProductSearch = false
                            }
                        }, label: {
                            HStack {
                                if(productResult.image != nil){
                                    KFImage(productResult.image!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                Text(productResult.title ?? "Error loading product")
                                Image(systemName: "arrow.right")
                            }
                        })
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    
    
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
            
                Stepper {
                    Text("Amount: \(product.quantity)")
                } onIncrement: {
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
            
            
            Button("Scan from barcode"){
                self.isPresentingScanner = true
            }
            .sheet(isPresented: $isPresentingScanner){
                scannerSheet
            }
            
            Button("Search for a product"){
                self.isPresentingProductSearch = true
            }
            .sheet(isPresented: $isPresentingProductSearch){
                productSearchSheet
            }
            
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if(product.title != "None") {
                    Button (action: {
                        kitchen.addProduct(product: product)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Add product")
                    })
                }
                else{
                    Text("Add product")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}


struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(kitchen: Kitchen())
    }
}
