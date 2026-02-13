//
//  SearchScreenViewModel.swift
//  ChibliApp
//
//  Created by Olena Solovii on 13.02.2026.
//

import Foundation
import Observation


@Observable
class SearchScreenViewModel {

    var state: LoadingState<[Film]> = .idle
    
    private let service: ChibliService
    
    init(service: ChibliService = DefaultChibliService()) {
        self.service = service
    }
    
    func fetch(searchTerm: String) async {
        
        /// wait and check if there was no new task.
        /// When new task is there - the old one will be cancelled, so we just check for the cancelled state
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        
        
        guard !searchTerm.isEmpty else { return }

        state = .loading
        
        do {
            let models = try await service.searchFilm(for: searchTerm)
            self.state = .loaded(models)
        } catch let error as APIError {
            self.state = .error(error.customDescription ?? "Unknown APIError appeared. Please refer to [FilmsViewModel.fetch]")
        } catch {
            self.state = .error("Unknown error appeared. Please refer to [FilmsViewModel.fetch]")
        }
    }
    
    //MARK: - Private

    
}
