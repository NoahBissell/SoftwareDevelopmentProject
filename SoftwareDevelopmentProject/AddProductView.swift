//
//  AddProductView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/22/22.
//

import SwiftUI
import CodeScanner
import AVFoundation
import struct Kingfisher.KFImage

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var kitchen : Kitchen
    @State var product : Product = Product()
    //    @State var classification : Classification = Classification(cleanTitle: "none", category: "none", breadcrumbs: [String]())
    
    @State var scannedCode = "0000"
    @State var isPresentingScanner = false
    @State var isPresentingSearch = false
    @State var query : String = ""
    @State var searchedProductList = [ProductResult]()
    
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [AVMetadataObject.ObjectType.ean13],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    
                    // convert EAN13 to UPC
                    self.scannedCode.removeFirst()
                    FetchData().getProductFromUPC(upc: scannedCode) { product in
                        self.product = product
                    }
                    FetchData().classifyProduct(product: product) { classification in
                        product.classification = classification
                    }
                }
            })
    }
    
    var searchSheet : some View {
        
        VStack{
            Spacer()
            
            // For some reason the keyboard dismisses after typing the first character, can't seem to figure out why
            Form{
                Section{
                    TextField(
                        "Search all recipes",
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
                        Button(productResult.title ?? "Error Loading Product"){
                            FetchData().getProductFromId(id: productResult.id) { product in
                                self.product = product
                            }
                            self.isPresentingSearch = false
                        }
                    }
                }
            }
            
        }
    }
    
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                Text("Product: \(product.title)")
                if let unwrappedClassification = product.classification{
                    Text("Title: \(unwrappedClassification.cleanTitle)")
                    Text("Category: \(unwrappedClassification.category)")
                    Text("Breadcrumbs: \(unwrappedClassification.breadcrumbs[0])")
                }
                
                Button("Scan from barcode"){
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner){
                    scannerSheet
                }
                
                Button("Search for a product"){
                    self.isPresentingSearch = true
                }
                .sheet(isPresented: $isPresentingSearch){
                    searchSheet
                }
                
            }
            .toolbar {
                Button (action: {
                    kitchen.addProduct(product: product)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Add product")
                })
                
            }
        }
        
    }
}


struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(kitchen: Kitchen())
    }
}
