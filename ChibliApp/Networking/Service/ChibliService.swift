//
//  ChibliService.swift
//  ChibliApp
//
//  Created by Olena Solovii on 02.02.2026.
//

import Foundation

protocol ChibliService {
    func fetchFilms() async throws -> [Film]
    func fetchPersonDetails() async throws -> Person
}

struct DefaultChibliService: ChibliService {
    
    func fetchFilms() async throws -> [Film] {
        
        //TODO: - URL not static
        guard let url = URL(string: "https://ghibliapi.vercel.app/films") else {
            throw APIError.invalidURL
        }
    
        do {
            let (data, response) =  try await URLSession.shared.data(from: url)
            
            guard let httpRespose = response as? HTTPURLResponse, (200...299).contains(httpRespose.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let models = try JSONDecoder().decode([Film].self, from: data)
            return models
            
        } catch let error as DecodingError {
            print("[FilmsViewModel] DecodingError \(error)")
            throw APIError.decodingError(error)
        } catch let error as URLError {
            print("[FilmsViewModel] URLError \(error)")
            throw APIError.networkError(error)
        }
    
    }
    
    func fetchPersonDetails() async throws -> Person {
        return Person(id: "", name: "", gender: "", age: "", eyeColor: "", hairColor: "", url: "", species: "", films: [])
    }
    
    
}

//MARK: - MOCK
struct MockChibliService: ChibliService {
    
    private struct SampleData: Decodable {
        let films: [Film]
        let people: [Person]
    }

    func fetchFilms() async throws -> [Film] {
        
        let data = try loadLocalJSON()
        
        return data
    }
    
    func fetchPersonDetails() async throws -> Person {
        return Person(id: "", name: "", gender: "", age: "", eyeColor: "", hairColor: "", url: "", species: "", films: [])
    }
    
    //MARK: - Private
    
    private func loadLocalJSON() throws -> [Film] {
        guard let url = Bundle.main.url(forResource: "SampleDataFilms", withExtension: "json") else {
            throw APIError.invalidURL
        }

        do {
            let data = try Data(contentsOf: url)
            let resultData = try JSONDecoder().decode([Film].self, from: data)
            return resultData
        } catch let error as DecodingError {
            print("[MockChibliService] DecodingError \(error)")
            throw APIError.decodingError(error)
        } catch {
            print("[MockChibliService] URLError \(error)")
            throw APIError.networkError(error)
        }
        
    }
    
    
}
