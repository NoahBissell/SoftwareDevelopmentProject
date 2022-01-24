//
//  DataParsingTest.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/9/22.
//
import Foundation

class FetchData : ObservableObject {
    
    func getRecipes(completion: @escaping ([RecipeResult]) -> ()) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=dc7b6320294946cc8ef2be70d8e98db3") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(RecipeResponse.self, from: data){
                DispatchQueue.main.async {
                    completion(response.results)
                }
            }
        }.resume()
    }
    
    func classifyProduct(product : Product, completion: @escaping (Classification) -> ()) {
        // If you encounter errors, it might be a problem with passing in a product object and not just a wrapped string
        guard let encoded = try? JSONEncoder().encode(StringObject(title: product.title)) else {
            print("Failed 1")
            return
        }

        guard let url = URL(string: "https://api.spoonacular.com/food/products/classify?apiKey=dc7b6320294946cc8ef2be70d8e98db3&locale=en_US") else {
            print("Failed 2")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        
        URLSession.shared.uploadTask(with: request, from: encoded) { (data, response, errors) in
            guard let data = data else {
                print("Failed 3")
                return
            }
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(Classification.self, from: data){
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }.resume()
    }
    
    func searchProducts(query : String, completion: @escaping ([ProductResult]) -> ()){
        guard let url = URL(string: "https://api.spoonacular.com/food/products/search?apiKey=dc7b6320294946cc8ef2be70d8e98db3&query=\(query)") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(ProductResponse.self, from: data){
                DispatchQueue.main.async {
                    completion(response.products)
                }
            }
        }.resume()
    }
    
    func getProductFromUPC(upc : String, completion: @escaping (Product) -> ()) {
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
    
    func getProductFromId(id : Int, completion : @escaping (Product) -> ()){
        guard let url = URL(string: "https://api.spoonacular.com/food/products/\(id)?apiKey=dc7b6320294946cc8ef2be70d8e98db3") else {return}
        
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

struct StringObject : Codable {
    var title : String
}

struct Classification : Codable {
    var cleanTitle : String
    var category : String
    var breadcrumbs : [String]
}

struct RecipeResult : Codable, Identifiable {
    var title : String?
    var id : Int = 0
}

struct RecipeResponse : Codable {
    var results : [RecipeResult] = [RecipeResult]()
}

struct ProductResult : Codable, Identifiable {
    var title : String?
    var id : Int = 0
}

struct ProductResponse : Codable {
    var products : [ProductResult] = [ProductResult]()
}

struct Product : Codable, Identifiable {
    var id : Int = 0
    var aisle : String?
    var title : String = "Apples"
    
    // from classification
    var classification : Classification?
    
}

class Kitchen : ObservableObject {
// ALL POSSIBLE AISLES (if we want to sort them later)
    
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
