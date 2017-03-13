//
//  MovieDBAPI.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import Foundation

enum MovieDBError: Error {
    case invalidJSONData
}

struct MovieDBAPI {
    private static let baseURLString = "http://api.themoviedb.org/3/discover/movie"
    private static let apiKey = "ab41356b33d100ec61e6c098ecc92140"
    
//    http://api.themoviedb.org/3/discover/movie?api_key=ab41356b33d100ec61e6c098ecc92140&sort_by=popularity.desc

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static var upcomingMoviesURL: URL {
        return movieDBURL(parameters: ["sort_by": "popularity.desc"])
    }
    
    private static func movieDBURL(parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }

    static func movies(fromJSON data: Data) -> MoviesResult {
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let movieArray = jsonDictionary["results"] as? [[String:Any]] else {
                
                    // The JSON structure doesn't match our expectations
                    return .failure(MovieDBError.invalidJSONData)
            }
            
            var finalMovies = [Movie]()
            for movieJSON in movieArray {
                if let movie = movie(fromJSON: movieJSON) {
                    finalMovies.append(movie)
                }
            }
            
            if finalMovies.isEmpty && !movieArray.isEmpty {
                // No movies?
                return .failure(MovieDBError.invalidJSONData)
            }
            return .success(finalMovies)
        } catch let error {
            return .failure(error)
        }
    }

    private static func movie(fromJSON json: [String : Any]) -> Movie? {
//        let movieID = "123"
        guard
            let movieIdNum = json["id"] as? NSInteger,
            let title = json["title"] as? String,
            let adult = json["adult"] as? Bool,
            let originalTitle = json["original_title"] as? String,
            let originalLanguage = json["original_language"] as? String,
            let overview = json["overview"] as? String,
            let posterURLString = json["poster_path"] as? String,
            let backdropURLString = json["backdrop_path"] as? String,
            let backdropURL = URL(string: backdropURLString),
            let popularity = json["popularity"] as? NSInteger,
            let voteCount = json["vote_count"] as? NSInteger,
            let voteAverage = json["vote_average"] as? Double,
            let video = json["video"] as? Bool,
            let releaseDateString = json["release_date"] as? String,
            let releaseDate = dateFormatter.date(from: releaseDateString) else {
                
                // Don't have enough information to construct a Movie
                return nil
        }
        
        var posterURL = URL.init(string: "")
        if (posterURLString.characters.count > 0) {
            posterURL = URL(string: "https://image.tmdb.org/t/p/w1280" + posterURLString)!
        }
        let movieID = String(movieIdNum)
        return Movie(title: title, movieID: movieID, posterURL: posterURL!, releaseDate: releaseDate, adult: adult, backdropURL: backdropURL, originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: popularity, video: video, voteAverage: voteAverage, voteCount: voteCount)
    }
}
