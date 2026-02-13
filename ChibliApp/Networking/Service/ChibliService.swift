//
//  ChibliService.swift
//  ChibliApp
//
//  Created by Olena Solovii on 02.02.2026.
//

import Foundation

protocol ChibliService: Sendable {
    func fetchFilms() async throws -> [Film]
    func fetchPersonDetails(from stringURL: String) async throws -> Person
    
    func searchFilm(for searchTerm: String) async throws -> [Film]

}

struct DefaultChibliService: ChibliService {
    
    func searchFilm(for searchTerm: String) async throws -> [Film] {
        let allFilms = try await self.fetchFilms()
        
        
        let searchResults = allFilms.filter { film in
            film.title.localizedCaseInsensitiveContains(searchTerm)
        }
        
        return searchResults
    }
    
    func fetchFilms() async throws -> [Film] {
        let result = try await fetch([Film].self, from: "https://ghibliapi.vercel.app/films")
        return result
    }
    
    func fetchPersonDetails(from stringURL: String) async throws -> Person {
        let result = try await fetch(Person.self, from: stringURL)
        return result
    }
    
    //MARK: - Private
    
    private func fetch<T>(_ type: T.Type, from urlString: String) async throws -> T where T: Decodable {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
    
        do {
            let (data, response) =  try await URLSession.shared.data(from: url)
            
            guard let httpRespose = response as? HTTPURLResponse, (200...299).contains(httpRespose.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let models = try JSONDecoder().decode(T.self, from: data)
            return models
            
        } catch let error as DecodingError {
            print("[DefaultChibliService] DecodingError \(error)")
            throw APIError.decodingError(error)
        } catch let error as URLError {
            print("[DefaultChibliService] URLError \(error)")
            throw APIError.networkError(error)
        }
        
    }
    
    
}

//MARK: - MOCK
struct MockChibliService: ChibliService {
    
    private struct SampleData: Decodable {
        let films: [Film]
        let people: [Person]
    }

    func searchFilm(for searchTerm: String) async throws -> [Film] {
        let allFilms = try loadLocalJSON()
        
        let searchResults = allFilms.filter { film in
            film.title.localizedCaseInsensitiveContains(searchTerm)
        }
        
        return searchResults
    }
    
    func fetchFilms() async throws -> [Film] {
        let data = try loadLocalJSON()
        
        return data
    }
    
    func fetchPersonDetails(from stringURL: String) async throws -> Person {
        return Person(id: "", name: "", gender: "", age: "", eyeColor: "", hairColor: "", url: "", species: "", films: [])
    }
    
    /// Film with cast present, Princess Mononoke
    func fetchFilm() -> Film {
        let film = try! loadFilm()
        return film
    }
    
    /// Film with no people present - animation
    func fetchFilm_NoPeople() async throws -> Film {
        let film = try loadFilm_NoPeople()
        return film
    }
    
    //MARK: - Private
    private func loadFilm() throws -> Film {
        guard let url = Bundle.main.url(forResource: "Film_2", withExtension: "json") else {
            throw APIError.invalidURL
        }

        do {
            let data = try Data(contentsOf: url)
            let resultData = try JSONDecoder().decode(Film.self, from: data)
            return resultData
        } catch let error as DecodingError {
            print("[MockChibliService] DecodingError \(error)")
            throw APIError.decodingError(error)
        } catch {
            print("[MockChibliService] URLError \(error)")
            throw APIError.networkError(error)
        }
        
    }
    
    private func loadFilm_NoPeople() throws -> Film {
        guard let url = Bundle.main.url(forResource: "Film_1", withExtension: "json") else {
            throw APIError.invalidURL
        }

        do {
            let data = try Data(contentsOf: url)
            let resultData = try JSONDecoder().decode(Film.self, from: data)
            return resultData
        } catch let error as DecodingError {
            print("[MockChibliService] DecodingError \(error)")
            throw APIError.decodingError(error)
        } catch {
            print("[MockChibliService] URLError \(error)")
            throw APIError.networkError(error)
        }
        
    }
    
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
