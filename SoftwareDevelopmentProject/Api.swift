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
    
    
    func searchRecipes(query : String, completion: @escaping ([RecipeResult]) -> ()) {
//        let httpQuery = query.replacingOccurrences(of: "%", with: "%25").replacingOccurrences(of: " ", with: "%20")
        let httpQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? query
//        print("HERE: \(httpQuery)")
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)&sort=popularity&query=\(httpQuery)") else {return}
        
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
    
    func getRandomRecipes(completion: @escaping ([RecipeResult]) -> ()) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=\(apiKey)&number=10") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(RandomRecipeResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.recipes)
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError)")
            }
        }.resume()
    }
    
    func getRecipesFromIngredients(ingredients: [Ingredient], completion: @escaping ([RecipeResult]) -> ()) {
        var ingredientString = ""
        for ingredient in ingredients {
            ingredientString += "\(ingredient.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? ingredient.name),"
        }
        ingredientString.removeLast()
        
        ingredientString = ingredientString.addingPercentEncoding(withAllowedCharacters: []) ?? ingredientString
        print("HERE: \(ingredientString)")
        guard let url = URL(string: "https://api.spoonacular.com/recipes/findByIngredients?apiKey=\(apiKey)&ingredients=\(ingredientString)&ranking=2") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode([RecipeResult].self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError)")
            }
        }.resume()
    }
    
    func getRecipeFromId(id : Int, completion: @escaping (Recipe) -> ()) {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/information?apiKey=\(apiKey)") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            do{
                let recipe = try decoder.decode(Recipe.self, from: data)
                DispatchQueue.main.async {
                    completion(recipe)
                    
                }
            }catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError)")
            }
        }.resume()
    }
    
    func classifyProduct(product : Product, completion: @escaping (Classification) -> ()) {
//        let title = product.title.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? product.title
        guard let encoded = try? JSONEncoder().encode(StringObject(title: product.title))
        else {
            print("Failed 1")
            return
        }
//        print("HERE: \(title)")
        
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
            do{
            let response = try decoder.decode(Classification.self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError)")
            }
        }.resume()
    }
    
    func searchProducts(query : String, completion: @escaping ([ProductResult]) -> ()){
        let httpQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? query
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
            do{
                let product = try decoder.decode(Product.self, from: data)
                DispatchQueue.main.async {
                    completion(product)
                    
                }
            }catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError)")
            }
        }.resume()
    }
    
    func searchIngredients(query : String, completion: @escaping ([IngredientResult]) -> ()){
        let httpQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? query
        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/search?apiKey=\(apiKey)&query=\(httpQuery)") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            do{
                let response = try decoder.decode(IngredientResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results)
                }
                
            }
            catch let jsonError as NSError {
                print("JSON decode faild: \(jsonError)")
            }
        }.resume()
    }
    
    func getIngredientFromId(id : Int, completion : @escaping (Ingredient) -> ()){
        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/\(id)/information?apiKey=\(apiKey)&amount=1") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            do{
                let ingredient = try decoder.decode(Ingredient.self, from: data)
                DispatchQueue.main.async {
                    completion(ingredient)
                }
            }
            
            catch let jsonError as NSError{
                print("JSON decode faild: \(jsonError)")
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
    var image : URL?
    var id : Int = 0
}
struct RecipeResponse : Codable {
    var results : [RecipeResult] = [RecipeResult]()
}
struct RandomRecipeResponse : Codable {
    var recipes : [RecipeResult] = [RecipeResult]()
}
struct Recipe : Codable, Identifiable {
    var title : String?
    var id : Int = 0
    var image : URL?
    var summary : String?
    var readyInMinutes : Int?
    var instructions : String?
    var extendedIngredients : [ExtendedIngredient] = [ExtendedIngredient]()
}
// for loading ingredients in a recipe
struct ExtendedIngredient : Codable, Identifiable {
    var id : Int = 0
    var name : String = "None"
    var image : String?
    var amount : Float = 1
    var unit : String = ""
   
    
    // accessor for name to make sure it's capitalized
    func getName() -> String {
        return name.capitalized
    }
    func getImageURL() -> URL? {
        var url = ""
        if let str = image {
            url = "https://spoonacular.com/cdn/ingredients_250x250/\(str)"
        }
        return URL(string: url)
    }
    
}


// PRODUCT STUFF
struct ProductResult : Codable, Identifiable {
    var title : String?
    var id : Int = 0
    var image : URL?
}
struct ProductResponse : Codable {
    var products : [ProductResult] = [ProductResult]()
}
struct Product : Codable, Identifiable {
    var id : Int = 0
    var title : String = "None"
    var breadcrumbs : [String]?
    //    var imageType : String?
    var image : URL?
    //    var badges : [String]?
    //    var importantBadges : [String]?
    //    var ingredientCount : Int?
    //    var generatedText : String?
    //    var ingredientList : String?
    //    var ingredients : [Nutrient]?
    //    var likes : Int?
    var aisle : String?
    //    var nutrition : Nutrition?
    //    var price : Float?
    //    var servings : Serving?
    //    var spoonacularScore : Float?
    
    var classification : Classification?
    
    // I have two quantities here because the JSONDecoder was crashing if I made this var not optional
    // "storedQuantity" is for storing and changing the value, "quantity" is for accessing the value
    var storedQuantity : Int?
    init(){
        storedQuantity = 1
    }
    var quantity : Int {
        get {
            storedQuantity ?? 0
        }
    }
}
struct Classification : Codable {
    var cleanTitle : String
    var category : String
    var breadcrumbs : [String]
}


//INGREDIENT STUFF
struct IngredientResult : Codable, Identifiable {
    var name : String?
    var id : Int = 0
    var image : URL?
}
struct IngredientResponse : Codable {
    var results : [IngredientResult] = [IngredientResult]()
}
struct Ingredient : Codable, Identifiable {
    var id : Int = 0
    var name : String = "None"
    var image : String?
    var amount : Float = 1
    var unit : String = ""
    var possibleUnits : [String] = [String]()
    
    // accessor for name to make sure it's capitalized
    func getName() -> String {
        return name.capitalized
    }
    func getImageURL() -> URL? {
        var url = ""
        if let str = image {
            url = "https://spoonacular.com/cdn/ingredients_250x250/\(str)"
        }
        return URL(string: url)
    }
}


class Kitchen : ObservableObject {
    
    @Published var products : [Product]
    @Published var ingredients : [Ingredient]
    @Published var recipes : [Recipe]
    
    init(products : [Product] = [Product](), recipes : [Recipe] = [Recipe](), ingredients : [Ingredient] = [Ingredient]()){
        self.products = products
        self.recipes = recipes
        self.ingredients = ingredients
    }
    
    // Use this function when initializing a new product in order to make sure storedQuantity is always 1
    func createProduct(product : Product) -> Product {
        var returnProduct = product
        returnProduct.storedQuantity = 1
        return returnProduct
    }
    func addProduct(product : Product){
        products.append(product)
    }
    func removeProduct(at offsets: IndexSet){
        products.remove(atOffsets: offsets)
    }
    
    func addIngredient(ingredient : Ingredient){
        ingredients.append(ingredient)
    }
    func removeIngredient(at offsets: IndexSet){
        ingredients.remove(atOffsets: offsets)
    }
    
    func addRecipe(recipe : Recipe){
        recipes.append(recipe)
    }
    func removeRecipe(at offsets: IndexSet){
        recipes.remove(atOffsets: offsets)
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

extension String {
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized // If input is in llamaCase
    }
    func removeHtmlTags() -> String {
        var str = self
        if let range = self.range(of: "Try <a"){
            str.removeSubrange(range.lowerBound..<self.endIndex)
        }
        else if let range = self.range(of: "liked <a"){
            str.removeSubrange(range.lowerBound..<self.endIndex)
        }
        else if let range = self.range(of: "<a> href"){
            str.removeSubrange(range.lowerBound..<self.endIndex)
        }
        return str.replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
    }
    
}

//extension String: Identifiable {
//    public typealias ID = Int
//    public var id: Int {
//        return hash
//    }
//}
