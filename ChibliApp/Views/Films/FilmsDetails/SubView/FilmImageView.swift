//
//  FilmImageView.swift
//  ChibliApp
//
//  Created by Olena Solovii on 03.02.2026.
//

import SwiftUI

struct FilmImageView: View {
    
    var url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    init(urlPath: String) {
        self.url = URL(string: urlPath)
    }
    
    
    var body: some View {

        if #available(iOS 26.0, *) {
            AsyncImage(url: url) { phase in
                
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
                        .aspectRatio(contentMode: .fill)
                    
                case .failure(let error):
                    Label("The image could not be loaded. \nError: \(error.localizedDescription)", systemImage: "moon.dust")
                @unknown default:
                    fatalError("[FilmImageView] Something went wrong with the image loading.")
                }
            }
            .clipShape(.rect(corners: .concentric)) //TODO: - check on laters HIG for concentric
            
        } else {
            // Fallback on earlier versions
            
            AsyncImage(url: url) { phase in
                
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
                        .aspectRatio(contentMode: .fill)
                    
                case .failure(let error):
                    Label("The image could not be loaded. \nError: \(error.localizedDescription)", systemImage: "moon.dust")
                @unknown default:
                    fatalError("[FilmImageView] Something went wrong with the image loading.")
                }
            }
            .cornerRadius(20)
        }

    }
}

#Preview("Loaded") {
    
    /*
     "image": "https://image.tmdb.org/t/p/w600_and_h900_bestv2/rtGDOeG9LzoerkDGZF9dnVeLppL.jpg",
     "movie_banner": "https://image.tmdb.org/t/p/original/etqr6fOOCXQOgwrQXaKwenTSuzx.jpg",
     */
    
    let url = URL.convertAssetImage(named: "bannerImage")
//    let url = URL.convertAssetImage(named: "posterImage")
    FilmImageView(url: url)
    
}

#Preview("Empty") {
    
    let url = URL(string: "")
    FilmImageView(url: nil)
}

#Preview("Error") {
    
    FilmImageView(urlPath: "987")
}


