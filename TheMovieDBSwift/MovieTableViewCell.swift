//
//  MovieTableViewCell.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

class MovieTableViewCell : UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var movieBackgroundImageView: UIImageView!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.adjustsFontForContentSizeCategory = true
        releaseDateLabel.adjustsFontForContentSizeCategory = true
    }
}
