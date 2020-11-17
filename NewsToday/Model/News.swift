//
//  News.swift
//  NewsToday
//
//  Created by Macbook Air 13 on 06.11.2020.
//

import Foundation

class News{
    
    struct Returned: Codable {
        var status: String
        var totalResults: Int
        var articles: [Articles]
        
        enum CodingKeys: String, CodingKey {
            case status, totalResults, articles
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.status = try container.decode(String.self, forKey: .status)
            self.totalResults = try container.decode(Int.self, forKey: .totalResults)
            self.articles = try container.decode([Articles].self, forKey: .articles).sorted { $0.publishedAt > $1.publishedAt
            }
            
        }
        
    }
    
    struct Articles:Codable {
        var source: Source
        var author: String?
        var title: String
        var description: String?
        var url: String
        var urlToImage: String?
        var publishedAt: String
        var content: String?
        
    }
    
    struct Source: Codable {
        var name: String?
    }
    
    //MARK: - Reference
    
    var articleArray: [Articles] = []
    var sourceArray: [Source] = []
    
    
    var result: News.Returned?
    var category = "business"
    var country = "us"
    
    func urlString() -> String {
        return "http://newsapi.org/v2/top-headlines?country=\(self.country)&category=\(self.category)&apiKey=12258eebf98940058e2d367e9291f620"
    }
    // MARK: - Parsing
    
    func getData(completed: @escaping ()->()){
        
        guard let url = URL(string: urlString()) else {
            print("Error: Could not found url - \(urlString())")
            return
        }
        print("url - \(urlString())")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            }
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                
                self.result = returned
            } catch {
                print("JSON ERROR \(error)")
            }
            completed()
        }
        task.resume()
    }
}
