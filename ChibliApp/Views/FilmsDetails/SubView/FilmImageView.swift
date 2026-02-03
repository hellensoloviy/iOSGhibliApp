//
//  FilmImageView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 03.02.2026.
//

import SwiftUI

struct FilmImageView: View {
    
    var urlPath: String
    
    var body: some View {

        AsyncImage(url: URL(string: urlPath)) { phase in
            
            switch phase {
            case .empty:
                Color.cyan.opacity(0.2)
                    .overlay {
                        ProgressView()
                            .controlSize(.large)
                    }
                    
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure(let error):
                Label("The image could not be loaded. \nError: \(error.localizedDescription)", systemImage: "moon.dust")
            @unknown default:
                fatalError("[FilmImageView] Something went wrong with the image loading.")
            }
        }

    }
}

#Preview("Loaded") {
    
    /*
     "image": "https://image.tmdb.org/t/p/w600_and_h900_bestv2/rtGDOeG9LzoerkDGZF9dnVeLppL.jpg",
     "movie_banner": "https://image.tmdb.org/t/p/original/etqr6fOOCXQOgwrQXaKwenTSuzx.jpg",
     */
    
    let image = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/rtGDOeG9LzoerkDGZF9dnVeLppL.jpg"
    let banner = "https://image.tmdb.org/t/p/original/etqr6fOOCXQOgwrQXaKwenTSuzx.jpg"
    
    FilmImageView(urlPath: banner)
}

#Preview("Empty") {
    FilmImageView(urlPath: "")
}

#Preview("Error") {
    FilmImageView(urlPath: "987")
}


