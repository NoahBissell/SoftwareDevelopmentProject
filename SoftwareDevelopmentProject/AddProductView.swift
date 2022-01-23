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
                }
            })
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Product: \(product.title)")
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
                    Text("Add")
                })
                
            }
        }
    }
}


struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
