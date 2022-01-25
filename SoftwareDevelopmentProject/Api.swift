//
//  DataParsingTest.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/9/22.
//
import Foundation

class FetchData : ObservableObject {
    
    //API keys for reference
    //dc7b6320294946cc8ef2be70d8e98db3
    //be19bc5826a04fed982556734c3056b7
    //b216ab7db3b144f6af3d732e19080f8a
    //6e1210515a994e818b19fb25a2319a23
    //4753c32caf9640faa169ec11b07ad4fd
    let apiKey : String = "6e1210515a994e818b19fb25a2319a23"
    
    
    func getRecipes(completion: @escaping ([RecipeResult]) -> ()) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)") else {return}
        
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
    
    func getRecipesFromIngredients(ingredients: [Ingredient], completion: @escaping ([RecipeResult]) -> ()) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)") else {return}
        
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

        guard let url = URL(string: "https://api.spoonacular.com/food/products/classify?apiKey=\(apiKey)&locale=en_US") else {
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
        let httpQuery = query.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "https://api.spoonacular.com/food/products/search?apiKey=\(apiKey)&query=\(httpQuery)") else {return}
        
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
        guard let url = URL(string: "https://api.spoonacular.com/food/products/upc/\(upc)?apiKey=\(apiKey)") else {return}
        
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
        guard let url = URL(string: "https://api.spoonacular.com/food/products/\(id)?apiKey=\(apiKey)") else {return}
        
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
    
    func searchIngredients(query : String, completion: @escaping ([IngredientResult]) -> ()){
        let httpQuery = query.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/search?apiKey=\(apiKey)&query=\(httpQuery)") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(IngredientResponse.self, from: data){
                DispatchQueue.main.async {
                    completion(response.ingredients)
                }
            }
        }.resume()
    }
    
    func getIngredientFromId(id : Int, completion : @escaping (Ingredient) -> ()){
        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/\(id)/information?apiKey=\(apiKey)") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            if let ingredient = try? decoder.decode(Ingredient.self, from: data){
                DispatchQueue.main.async {
                    completion(ingredient)
                }
            }
        }.resume()
    }
}

struct StringObject : Codable {
    var title : String
}

// RECIPE STUFF
struct RecipeResult : Codable, Identifiable {
    var title : String?
    var id : Int = 0
}
struct RecipeResponse : Codable {
    var results : [RecipeResult] = [RecipeResult]()
}
struct Recipe : Codable, Identifiable {
    var title : String?
    var id : Int = 0
    var image : URL?
    var summary : String?
    
}

// PRODUCT STUFF
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
    var image : URL?
    // from classification
    var classification : Classification?
}
struct Classification : Codable {
    var cleanTitle : String
    var category : String
    var breadcrumbs : [String]
}


//INGREDIENT STUFF
struct IngredientResult : Codable, Identifiable {
    var title : String?
    var id : Int = 0
    var image : URL?
}
struct IngredientResponse : Codable {
    var ingredients : [IngredientResult] = [IngredientResult]()
}
struct Ingredient : Codable, Identifiable {
    var id : Int = 0
    var title : String?
    var image : URL?
}


class Kitchen : ObservableObject {
    
    @Published var products : [Product]
    @Published var recipes : [Recipe]
    
    init(products : [Product] = [Product](), recipes : [Recipe] = [Recipe]()){
        self.products = products
        self.recipes = recipes
        
    }
    
    func addProduct(product : Product){
        products.append(product)
    }
    
//    func addProducts(product: Product, quantity : Int){
//        if let num = products[product]{
//            products.updateValue(num + 1, forKey: product)
//        }
//        else{
//            products[product] = 0
//        }
//    }
}
