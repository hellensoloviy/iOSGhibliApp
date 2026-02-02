//
//  FilmDetailsViewModel.swift
//  ChibliApp
//
//  Created by Olena Solovii on 02.02.2026.
//

import Foundation
import Observation

class FilmDetailsViewModel {
    
    enum State: Equatable {
        case idle
        case empty
        case loading
        case loaded([Person])
        case error(String)
    }
    
    var state: State = .idle
    
    private let service: ChibliService
    
    init(service: ChibliService = DefaultChibliService()) {
        self.service = service
    }
    
    func fetch(for film: Film) async {
             
        guard state != .idle else { return } /// maybe == .idle?
        state = .loading
        
        var loadedCast: [Person] = []
        
        do {
            try await withThrowingTaskGroup(of: Person.self) { group in
                for person in film.castList {
                    group.addTask {
                        try await self.service.fetchPersonDetails(from: person)
                    }
                }
                
                /// collect tasks result as they complete
                for try await person in group {
                    loadedCast.append(person)
                }
            }
            
            state = .loaded(loadedCast)
        } catch let error as APIError {
            self.state = .error(error.customDescription ?? "Unknown APIError appeared. Please refer to [FilmDetailsViewModel.fetch]")
        } catch {
            self.state = .error("Unknown error appeared. Please refer to [FilmDetailsViewModel.fetch]")
        }
        
    }
    
}


//import Playgrounds
//
//#Playground {
//
//    let vm = FilmDetailsView(service: MockChibliService())
//    
//    do {
//        let film = try await MockChibliService().fetchFilm()
//        await vm.viewModel.fetch(for: film)
//    } catch {
//        print("Playground FilmDetailsVM Error \(error)")
//    }
//    
//    print(vm.people)
//
//}
