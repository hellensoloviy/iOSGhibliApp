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
    
    var state: LoadingState<[Film]> = .idle
    
    private let service: ChibliService
    
    init(service: ChibliService = DefaultChibliService()) {
        self.service = service
    }
    
    func fetch() async {
        guard !state.isLoading || state.error != nil else { return }
        state = .loading
        
        do {
            let models = try await service.fetchFilms()
            self.state = .loaded(models)
        } catch let error as APIError {
            self.state = .error(error.customDescription ?? "Unknown APIError appeared. Please refer to [FilmsViewModel.fetch]")
        } catch let error as CancellationError {
            self.state = .idle
        } catch {
            self.state = .error("Unknown error appeared. Please refer to [FilmsViewModel.fetch]")
        }
    }
    
    //MARK: - Private

    
}

