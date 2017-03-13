//
//  MovieDBViewController.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/11/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

class MovieDBViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var movieTableView: UITableView!
    var store: MovieStore!
    var movieArray = [Movie]()
    let cellIdentifier: String = "MovieTableViewCell"

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
        movieTableView.contentInset = insets
        movieTableView.scrollIndicatorInsets = insets
        
        movieTableView.rowHeight = UITableViewAutomaticDimension
        movieTableView.estimatedRowHeight = 75
        
        // Create 1px high view; otherwise defaults to 30px or so]
        let emptyHeader = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1.0))
        movieTableView.tableHeaderView = emptyHeader
        
        store.fetchMovies {
            (moviesResult) -> Void in
            
            switch moviesResult {
            case let .success(movies):
                print("Successfully found \(movies.count) movies.")
                self.movieArray = movies
                self.movieTableView.reloadData()
            case let .failure(error):
                print("Error fetching recent movies: \(error)")
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.movie = movieArray[indexPath.row]
        detailVC.store = store
        navigationController?.pushViewController(detailVC, animated: false)
    }
    
// MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovieTableViewCell
        
        cell.titleLabel.text = movieArray[indexPath.row].title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString : String = formatter.string(from: movieArray[indexPath.row].releaseDate)
        cell.releaseDateLabel?.text = dateString
        store.fetchPosterImage(for: movieArray[indexPath.row], completion: { (posterImageResult) -> Void in

            switch posterImageResult {
            case let .success(image):
                cell.moviePosterImageView.image = image
            case let .failure(error):
                print("Error fetching recent movies: \(error)")
            }
        })
        cell.moviePosterImageView?.backgroundColor = UIColor.orange
        return cell
    }
    
}
