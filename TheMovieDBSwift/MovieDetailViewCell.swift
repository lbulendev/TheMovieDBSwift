//
//  MovieDetailViewCell.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit
import CoreData

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
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var backdropImageView: UIImageView!

    @IBAction func favoriteButtonclicked(_ sender: AnyObject) {
        if (sender.title(for: []) != "Add to Favorites?") {
            sender.setTitle("Add to Favorites?", for: [])
            updateRecordInDB(isFavorite: false)
        } else {
            sender.setTitle("Remove from Favorites?", for: [])
            updateRecordInDB(isFavorite: true)
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.adjustsFontForContentSizeCategory = true
        releaseDateLabel.adjustsFontForContentSizeCategory = true
    }
    
    func updateRecordInDB(isFavorite: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate.init(format: "title = %@", self.titleLabel.text!)
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MovieDB")
        request.predicate = predicate
        do {
            if let results = try managedContext.fetch(request) as? [NSManagedObject] {
                if results.count != 0 {
                    
                    let updatedMovie = results[0]
                    updatedMovie.setValue(isFavorite, forKeyPath: "favorite")
                    
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}
