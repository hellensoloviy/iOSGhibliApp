//
//  Array+Safe.swift
//  ChibliApp
//
//  Created by Olena Solovii on 24.02.2026.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
