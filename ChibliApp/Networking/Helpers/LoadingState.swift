//
//  LoadingState.swift
//  ChibliApp
//
//  Created by Olena Solovii on 13.02.2026.
//

import Foundation

enum LoadingState<T> {
    
    case idle
    case loading
    case loaded(T)
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var data: T? {
        if case .loaded(let value) = self { return value }
        return nil
    }
    
    var error: String? {
        if case .error(let errorMessage) = self { return errorMessage }
        return "No message available"
    }
    
}
