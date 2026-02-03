//
//  Person.swift
//  ChibliApp
//
//  Created by Hellen Soloviy on 01.02.2026.
//


/*
 For Model got from https://ghibliapi.vercel.app/films --> https://ghibliapi.vercel.app/people/fe93adf2-2f3a-4ec4-9f68-5422f1b87c01
 */


import Foundation

struct Person: Codable, Identifiable, Equatable, Hashable {
    
    let id: String
    let name: String
    let gender: String
    let age: String
    
    let eyeColor: String
    let hairColor: String
    
    let url: String
    let species: String
    
    let films: [String]

    
    enum CodingKeys: String, CodingKey {
        case id, name, gender, species, age, url, films
        
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
    }
    
}

//import Playgrounds
//
//#Playground {
//    let url = URL(string: "https://ghibliapi.vercel.app/people/fe93adf2-2f3a-4ec4-9f68-5422f1b87c01")!
//
//
//    do {
//        let (data, response) =  try await URLSession.shared.data(from: url)
//        try JSONDecoder().decode(Person.self, from: data)
//    } catch {
//        print("Playground Film Error \(error)")
//    }
//}
