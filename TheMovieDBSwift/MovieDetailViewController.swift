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
    let cellIdentifier: String = "MovieDetailViewCell"
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
        
        // -20 to move the header back up 20
        let insets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        movieDetailTableView.contentInset = insets
        movieDetailTableView.scrollIndicatorInsets = insets
        
        movieDetailTableView.rowHeight = UITableViewAutomaticDimension
        movieDetailTableView.estimatedRowHeight = 800
        
        // Create 1px high view; otherwise defaults to 30px or so]
        let emptyHeader = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1.0))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovieDetailViewCell
        
        cell.titleLabel.text = movie.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString : String = formatter.string(from: movie.releaseDate)
        cell.releaseDateLabel?.text = dateString
        cell.overviewLabel.text = movie.overview
        store.fetchPosterImage(for: movie, completion: { (posterImageResult) -> Void in
            
            switch posterImageResult {
            case let .success(image):
                cell.posterImageView.image = image
            case let .failure(error):
                print("Error fetching recent movies: \(error)")
            }
        })

        cell.posterImageView?.backgroundColor = UIColor.orange
        
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
        
        cell.languageLabel.text = movie.originalLanguage
        return cell
    }
}
