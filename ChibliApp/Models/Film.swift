//
//  Film.swift
//  ChibliApp
//
//  Created by Hellen Soloviy on 01.02.2026.
//

import Foundation


/*
 For Model got from https://ghibliapi.vercel.app/films
 */

nonisolated /// opted out of the main actor. May need to investigate another solution. TBD
struct Film: Codable, Identifiable, Equatable, Hashable {
    
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String

    let releaseYear: String
    let score: String
    let duration: String //TODO: - type?
    
    let image: String
    let bannerImage: String
    
    let castList: [String]
    
    var scoreInt: Int {
        Int(score) ?? -1
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, description, director, producer
        
        case bannerImage = "movie_banner"
        case releaseYear = "release_date"
        case duration = "running_time"
        case score = "rt_score"
        case castList = "people"
    }
     
}


import Playgrounds
 
#Playground {
    let url = URL(string: "https://ghibliapi.vercel.app/films")!
    
    
    do {
        let (data, response) =  try await URLSession.shared.data(from: url)
        try JSONDecoder().decode([Film].self, from: data)
    } catch {
        print("Playground Film Error \(error)")
    }
}
