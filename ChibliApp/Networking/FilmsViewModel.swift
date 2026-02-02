//
//  FilmsViewModel.swift
//  ChibliApp
//
//  Created by Olena Solovii on 01.02.2026.
//

import Foundation
import Observation


@Observable
class FilmsViewModel {
    
    enum State: Equatable {
        case idle
        case empty
        case loading
        case loaded([Film])
        case error(String)
    }
    
    
    var models: [Film] = []
    var state: State = .idle
    
    
    func fetch() async {
        guard state == .idle else { return }
        state = .loading
        
        do {
            let models = try await fetchFilms()
            self.state = .loaded(models)
        } catch let error as APIError {
            self.state = .error(error.customDescription ?? "Unknown APIError appeared. Please refer to [FilmsViewModel.fetch]")
        } catch {
            self.state = .error("Unknown error appeared. Please refer to [FilmsViewModel.fetch]")
        }
    }
    
    //MARK: - Private
    private func fetchFilms() async throws -> [Film] {
        
        //TODO: - URL not static
        guard let url = URL(string: "https://ghibliapi.vercel.app/films") else {
            throw APIError.invalidURL
        }
    
        do {
            let (data, response) =  try await URLSession.shared.data(from: url)
            
            guard let httpRespose = response as? HTTPURLResponse, (200...299).contains(httpRespose.statusCode) else {
                throw APIError.invalidResponse
            }
            
            models = try JSONDecoder().decode([Film].self, from: data)
        } catch let error as DecodingError {
            print("[FilmsViewModel] DecodingError \(error)")
            throw APIError.decodingError(error)
        } catch let error as URLError {
            print("[FilmsViewModel] URLError \(error)")
            throw APIError.networkError(error)
        }
    
        return models
    }
    
}

