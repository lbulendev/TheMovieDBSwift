//
//  MovieDetailViewController.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var store: MovieStore!
    var movie = Movie()
    @IBOutlet var movieDetailTableView: UITableView!

    
    required init?(coder aDecoder: NSCoder) {
        store = MovieStore()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        store = MovieStore()
        super.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navcontrollerHeight = self.navigationController?.navigationBar.frame.size.height
        
        let insets = UIEdgeInsets(top: -statusBarHeight-navcontrollerHeight!, left: 0, bottom: 0, right: 0)
        movieDetailTableView.contentInset = insets
        movieDetailTableView.scrollIndicatorInsets = insets
        
        movieDetailTableView.rowHeight = UITableViewAutomaticDimension
        movieDetailTableView.estimatedRowHeight = 800
        
        // Create 1px high view; otherwise defaults to 30px or so]
        let emptyHeader = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1.0))
        emptyHeader.backgroundColor = Constants.Colors.brownColor
        movieDetailTableView.tableHeaderView = emptyHeader
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
// MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.DetailCell, for: indexPath) as! MovieDetailViewCell
        
        cell.titleLabel.text = movie.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString : String = formatter.string(from: movie.releaseDate)
        cell.releaseDateLabel?.text = dateString
        cell.overviewLabel.text = movie.overview
        
        store.fetchPosterImage(for: movie, isPoster: true, completion: { (posterImageResult) -> Void in
            
            switch posterImageResult {
            case let .success(image):
                cell.posterImageView.image = image
            case let .failure(error):
                print("Error fetching movie poster: \(error)")
            }
        })
        
        store.fetchPosterImage(for: movie, isPoster: false, completion: { (posterImageResult) -> Void in
            
            switch posterImageResult {
            case let .success(image):
                cell.backdropImageView.image = image
            case let .failure(error):
                print("Error fetching movie backdrop: \(error)")
            }
        })

        cell.posterImageView?.backgroundColor = Constants.Colors.orangeColor
        cell.backdropImageView?.backgroundColor = Constants.Colors.greenColor
        
        cell.popularityLabel.text = String(format: "%d", movie.popularity)
        cell.averageVoteLabel.text = String(format: "%f", movie.voteAverage)
        
        switch movie.adult {
        case true:
            cell.adultLabel.text = "TRUE"
        case false:
            cell.adultLabel.text = "FALSE"
        }
        
        switch movie.video {
        case true:
            cell.videoLabel.text = "TRUE"
        case false:
            cell.videoLabel.text = "FALSE"
        }
        
        switch movie.favorite {
        case true:
            cell.favoriteButton.setTitle("Remove from Favorites?", for: [])
        case false:
            cell.favoriteButton.setTitle("Add to Favorites?", for: [])
        }
        cell.languageLabel.text = movie.originalLanguage
        return cell
    }
    
}
