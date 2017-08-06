//
//  Movie.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

class Movie {
    
    let title: String
    let movieID: String
    let posterURL: URL
    let releaseDate: Date
    let adult: Bool
    let backdropURL: URL
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: NSInteger
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let favorite: Bool
    
    init(title: String, movieID: String, posterURL: URL, releaseDate: Date, adult: Bool, backdropURL: URL, originalLanguage: String, originalTitle: String, overview: String, popularity: NSInteger, video: Bool, voteAverage : Double, voteCount : Int, favorite: Bool) {
        self.title = title
        self.movieID = movieID
        self.posterURL = posterURL
        self.releaseDate = releaseDate
        self.adult = adult
        self.backdropURL = backdropURL
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.favorite = favorite
    }
    
    init() {
        self.title = "Everest"
        self.movieID = "9999"
        self.posterURL = URL.init(string: "https://www.google.com")!
        self.releaseDate = Date.init()
        self.adult = false
        self.backdropURL = self.posterURL
        self.originalLanguage = "English"
        self.originalTitle = self.title
        self.overview = "No overview"
        self.popularity = 0
        self.video = false
        self.voteAverage = 0
        self.voteCount = 0
        self.favorite = false
    }
}
