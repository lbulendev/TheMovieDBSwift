//
//  MovieDetailViewCell.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

class MovieDetailViewCell : UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var originalTitleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var adultLabel: UILabel!
    @IBOutlet var videoLabel: UILabel!
    @IBOutlet var popularityLabel: UILabel!
    @IBOutlet var averageVoteLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.adjustsFontForContentSizeCategory = true
        releaseDateLabel.adjustsFontForContentSizeCategory = true
    }
}
