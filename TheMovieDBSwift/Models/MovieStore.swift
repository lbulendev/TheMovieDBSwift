//
//  MovieStore.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

enum MoviesResult {
    case success([Movie])
    case failure(Error)
}

enum ImageError: Error {
    case imageCreationError
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

class MovieStore {
    
    var movieArray = [Movie]()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func processMovieRequest(data: Data?, error: Error?) -> MoviesResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return MovieDBAPI.movies(fromJSON: jsonData)
    }
    
    func fetchMovies(completion: @escaping (MoviesResult) -> Void) {
        
        let url = MovieDBAPI.upcomingMoviesURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            let result = self.processMovieRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        })
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(ImageError.imageCreationError)
                }
        }
        
        return .success(image)
    }

    func fetchPosterImage(for movie: Movie, isPoster: Bool, completion: @escaping (ImageResult) -> Void) {
        
        let imageURL = isPoster ? movie.posterURL: movie.backdropURL
        var request = URLRequest(url: imageURL)
        request.timeoutInterval = 600
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
}

