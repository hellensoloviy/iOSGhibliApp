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
    
    private var currentSearchTerm: String? = nil
    
    private let service: ChibliService
    
    init(service: ChibliService = DefaultChibliService()) {
        self.service = service
    }
    
    func fetch(searchTerm: String) async {
        
        currentSearchTerm = searchTerm
        
        guard !searchTerm.isEmpty else {
            state = .idle
            return
        }

        state = .loading
        
        /// wait and check if there was no new task.
        /// When new task is there - the old one will be cancelled, so we just check for the cancelled state
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        
        
        do {
            let models = try await service.searchFilm(for: searchTerm)
            self.state = .loaded(models)
        } catch {
            setError(error, for: searchTerm)
        }
    }
    
    //MARK: - Private
    private func setError(_ error: Error, for searchTerm: String) {
        
        guard currentSearchTerm == searchTerm else { return }
        
        if let error = error as? APIError {
            self.state = .error(error.customDescription ?? "Unknown APIError appeared. Please refer to [FilmsViewModel.fetch]")
        } else {
            self.state = .error("Unknown error appeared. Please refer to [FilmsViewModel.fetch]")
        }
        
    }
    
}
