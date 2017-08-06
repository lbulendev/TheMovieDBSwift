//
//  Constants.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 8/6/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

struct Constants {
    struct CellIdentifiers {
        static let MovieCell: String = "MovieTableViewCell"
        static let DetailCell: String = "MovieDetailViewCell"
        static let FavCell: String = "FavTableViewCell"
    }
    
    struct Colors {
        static let brownColor = UIColor(0x8C6636, 1.0)
        static let greenColor = UIColor(0x00FF00, 1.0)
        static let orangeColor = UIColor(0xE47F1D, 1.0)
    }
}
extension UIColor {
    convenience init(_ color: Int, _ alpha: CGFloat) {
        let newRed = CGFloat((color & 0xFF0000) >> 16)/255.0
        let newGreen = CGFloat((color & 0xFF00) >> 8)/255.0
        let newBlue = CGFloat((color & 0xFF))/255.0
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
