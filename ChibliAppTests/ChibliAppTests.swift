//
//  ChibliAppTests.swift
//  ChibliAppTests
//
//  Created by Hellen Soloviy on 01.02.2026.
//

import Testing
import Foundation

@testable import ChibliApp

struct ChibliAppTests {
    
    actor MockChibliService: ChibliService {

        var mockFilms: [Film]
        var shouldThrowError: Bool
        var fetchDelay: Duration
        
        var fetchCallCount = 0
        var lastSearchQuery: String? = nil
        
        init(mockFilms: [Film] = [], shouldThrowError: Bool = false, fetchDelay: Duration = .zero) {
            self.mockFilms = mockFilms
            self.shouldThrowError = shouldThrowError
            self.fetchDelay = fetchDelay
            
            if mockFilms.isEmpty {
                self.mockFilms = try! loadLocalJSON()
            }
        }

        func searchFilm(for searchTerm: String) async throws -> [Film] {
            
            fetchCallCount += 1
            lastSearchQuery = searchTerm
            
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            try Task.checkCancellation()
            
            let allFilms = try loadLocalJSON()
            let searchResults = allFilms.filter {
                $0.title.localizedCaseInsensitiveContains(searchTerm)
            }
            
            return searchResults
        }
        
        func fetchFilms() async throws -> [Film] {
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            let data = try loadLocalJSON()
            
            return data
        }
        
        func fetchPersonDetails(from stringURL: String) async throws -> Person {
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            return Person(id: "", name: "", gender: "", age: "", eyeColor: "", hairColor: "", url: "", films: [])
        }
        
        func loadLocalJSON() throws -> [Film] {
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

    

    @MainActor
    @Test func testInitialState() async throws {
        let service = MockChibliService()
        let searchVM = SearchScreenViewModel(service: service)
        
        #expect(searchVM.state.data == nil)
        
        if case .idle = searchVM.state {
            
        } else {
            Issue.record("Expected idle state")
        }
    }
    
    @MainActor
    @Test("Search with query filters results")
    func testSearchWithQuery() async throws {
        let service = MockChibliService()
        let searchVM = SearchScreenViewModel(service: service)
        
        await searchVM.fetch(searchTerm: "Totoro")
        
        #expect(searchVM.state.data?.count == 1)
        #expect(searchVM.state.data?.first?.title == "My Neighbor Totoro")


    }
    
    @MainActor
    @Test("Search with query filters results - No results")
    func testSearchWithQuery_noResults() async throws {
        let service = MockChibliService()
        let searchVM = SearchScreenViewModel(service: service)
        
        await searchVM.fetch(searchTerm: "T9876")
        
        #expect(searchVM.state.data?.count == 0)
    }
    
    @MainActor
    @Test("Search with query filters results - No results")
    func testSearchWithQuery_errorState() async throws {
        let service = MockChibliService(shouldThrowError: true)
        let searchVM = SearchScreenViewModel(service: service)
        
        await searchVM.fetch(searchTerm: "T9876")
        
        #expect(searchVM.state.error != nil)
    }
    
    @MainActor
    @Test("Task cancellation after API call prevents state update")
    func testCancellationAfterAPICall() async throws {
        let service = MockChibliService(fetchDelay: .microseconds(100))
        let searchVM = SearchScreenViewModel(service: service)
        
        let task = Task {
            await searchVM.fetch(searchTerm: "Toto")
        }
        
        try? await Task.sleep(for: .milliseconds(550))
        task.cancel()
        
        await task.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 1)
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "Toto")
        
        #expect(searchVM.state.error != nil)
    }
    
    @MainActor
    @Test("Test that task is not fetching too frequently")
    func testDebounceTiming() async throws {
        let service = MockChibliService(fetchDelay: .microseconds(100))
        let searchVM = SearchScreenViewModel(service: service)
        
        let task = Task {
            await searchVM.fetch(searchTerm: "Toto")
        }
        
        /// cancel before debounce timing is over
        try? await Task.sleep(for: .milliseconds(350))
        task.cancel()
        
        await task.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 0)
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == nil)
        
        #expect(searchVM.state == .idle)
    }

    @MainActor
    @Test("Test multiple rapid searches, need to execute only the last one")
    func testDebounceWithMultipleSearches() async throws {
        let service = MockChibliService()
        let searchVM = SearchScreenViewModel(service: service)
        
        
        //simulate searches
        let searches = ["T", "To", "Todo", "To", "Toto", "Totor", "Totoro"]
        var tasks: [Task<Void, Never>] = []
        
        for search in searches {
            tasks.last?.cancel()
            
            let task = Task {
                await searchVM.fetch(searchTerm: search)
            }
            
            tasks.append(task)
            
            /// add delay between searches. Should be shorted than 500 debaunce time
            try? await Task.sleep(for: .milliseconds(50))
        }
        
        await tasks.last?.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 1, "Only the last one should be executed")
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "Totoro", "The last one should be here")
        
        #expect(searchVM.state.data?.count == 1)
        #expect(searchVM.state.data?.first?.title == "My Neighbor Totoro")
    }

    @MainActor
    @Test("Test multiple slow searches, need to execute all")
    func testDebounceWithMultipleSlowSearches() async throws {
        let service = MockChibliService()
        let searchVM = SearchScreenViewModel(service: service)
        
        
        //simulate searches
        let searches = ["T", "Toto", "Totoro"]
        var tasks: [Task<Void, Never>] = []
        
        for search in searches {
            tasks.last?.cancel()
            
            let task = Task {
                await searchVM.fetch(searchTerm: search)
            }
            
            tasks.append(task)
            
            /// add delay between searches. Should be shorted than 500 debaunce time
            try? await Task.sleep(for: .milliseconds(550))
        }
        
        await tasks.last?.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 3, "All searches should be executed")
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "Totoro", "The last one should be here")
        
        #expect(searchVM.state.data?.count == 1)
        #expect(searchVM.state.data?.first?.title == "My Neighbor Totoro")
    }
    
}
