//
//  DataParsingTest.swift
//  SoftwareDevelopmentProject
//
//  Created by Noah Bissell on 1/9/22.
//

class FetchData : ObservableObject {
    @Published var responses = Response()
    
    init(){
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=dc7b6320294946cc8ef2be70d8e98db3") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, errors) in
            guard let data = data else {return}
            
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(Response.self, from: data){
                DispatchQueue.main.async {
                    self.responses = response
                }
            }
            else{
                print("cant decode json")
            }
        }.resume()
    }
}

import Foundation

struct Result : Codable {
    var title : String?
}

struct Response : Codable {
    var results : [Result] = [Result]()
}

extension Result : Identifiable {
    var id: String {return title!}
}
