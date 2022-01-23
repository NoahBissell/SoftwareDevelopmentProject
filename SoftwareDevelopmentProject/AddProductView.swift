//
//  AddProductView.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/22/22.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var kitchen : Kitchen
    @State var product : Product = Product()
//    @State var classification : Classification = Classification(cleanTitle: "none", category: "none", breadcrumbs: [String]())
    
    @State var scannedCode = "0000"
    @State var isPresentingScanner = false
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [AVMetadataObject.ObjectType.ean13],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    
                    // convert EAN13 to UPC
                    self.scannedCode.removeFirst()
                    BarcodeSearch().getProduct(upc: scannedCode) { product in
                        self.product = product
                    }
                    FetchData().classifyProduct(product: product) { classification in
                        product.classification = classification
                    }
                }
            })
    }
    
    var body: some View {
        NavigationView{
            VStack{
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
//        .onAppear {
//            FetchData().classifyProduct(product: Product(id: 0, title: "Kroger Vitamin A & D Reduced Fat 2% Milk"), completion: { classification in
//                self.classification = classification
//            })
//        }
    }
}


struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
