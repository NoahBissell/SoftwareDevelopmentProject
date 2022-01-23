//
//  DataParsingTest.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/9/22.
//
import Foundation

class FetchData : ObservableObject {
    
    func getRecipes(completion: @escaping ([Result]) -> ()) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=dc7b6320294946cc8ef2be70d8e98db3") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(Response.self, from: data){
                DispatchQueue.main.async {
                    completion(response.results)
                }
            }
        }.resume()
    }
}



struct Result : Codable {
    var title : String?
}

struct Response : Codable {
    var results : [Result] = [Result]()
}

extension Result : Identifiable {
    var id: String {
        if let test = title {
            return test
        }
        else{
            return ""
        }
    }
}

class BarcodeSearch : ObservableObject {
    
    func getProduct(upc : String, completion: @escaping (Product) -> ()) {
        guard let url = URL(string: "https://api.spoonacular.com/food/products/upc/\(upc)?apiKey=dc7b6320294946cc8ef2be70d8e98db3") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            if let product = try? decoder.decode(Product.self, from: data){
                DispatchQueue.main.async {
                    completion(product)
                }
            }
        }.resume()
    }
}

struct Product : Codable, Identifiable {
    var id : Int
    var aisle : String?
    var title : String
    
    init(title : String = "Apple", id : Int = 0){
        self.title = title
        self.id = id
    }
}

class Kitchen : ObservableObject {
// ALL POSSIBLE CATEGORIES (if we want to sort them later)
    
//    Baking
//    Health Foods
//    Spices and Seasonings
//    Pasta and Rice
//    Bakery/Bread
//    Refrigerated
//    Canned and Jarred
//    Frozen
//    Nut butters, Jams, and Honey
//    Oil, Vinegar, Salad Dressing
//    Condiments
//    Savory Snacks
//    Milk, Eggs, Other Dairy
//    Ethnic Foods
//    Tea and Coffee
//    Meat
//    Gourmet
//    Sweet Snacks
//    Gluten Free
//    Alcoholic Beverages
//    Cereal
//    Nuts
//    Beverages
//    Produce
//    Not in Grocery Store/Homemade
//    Seafood
//    Cheese
//    Dried Fruits
//    Online
//    Grilling Supplies
//    Bread
    
    @Published var products : [Product]
    
    init(products : [Product] = [Product]()){
        self.products = products
        
    }
    
    func addProduct(product : Product){
        products.append(product)
    }
}



