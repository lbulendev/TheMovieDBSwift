//
//  MovieDBViewController.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/11/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//
import UIKit
import CoreData

class MovieDBViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var movieTableView: UITableView!
    var store: MovieStore!
    var movieDB = [NSManagedObject]()
    let cellIdentifier: String = "MovieTableViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        store = MovieStore()
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        store = MovieStore()
        super.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MovieDB")
        
        do {
            movieDB = try managedContext.fetch(request) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
                self.saveMoviesToDB(movies: movies)
                self.movieTableView.reloadData()
            case let .failure(error):
                
                print("Error fetching recent movies: \(error)")
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.movie = createMovieInstance (movie: movieDB[indexPath.row])
        detailVC.store = store
        navigationController?.pushViewController(detailVC, animated: false)
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieDB.count
    }
    
    func fetchMovies() {
        
    }
    
    func createMovieInstance (movie: NSManagedObject) -> Movie {
        let returnMovie = Movie(title: (movie.value(forKeyPath: "title") as? String)!,
                                movieID: (movie.value(forKeyPath: "movieID") as? String)!,
                                posterURL: URL(string: (movie.value(forKeyPath: "posterURLString") as? String)!)!,
                                releaseDate: (movie.value(forKeyPath: "releaseDate") as? Date)!,
                                adult: (movie.value(forKeyPath: "adult") as? Bool)!,
                                backdropURL: URL(string: (movie.value(forKeyPath: "backdropURLString") as? String)!)!,
                                originalLanguage: (movie.value(forKeyPath: "originalLanguage") as? String)!,
                                originalTitle: (movie.value(forKeyPath: "originalTitle") as? String)!,
                                overview: (movie.value(forKeyPath: "overview") as? String)!,
                                popularity: (movie.value(forKeyPath: "popularity") as? NSInteger)!,
                                video: (movie.value(forKeyPath: "video") as? Bool)!,
                                voteAverage : (movie.value(forKeyPath: "voteAverage") as? Double)!,
                                voteCount : (movie.value(forKeyPath: "voteCount") as? Int)!,
                                favorite : (movie.value(forKeyPath: "favorite") as? Bool)!)
        
        return returnMovie
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovieTableViewCell
        
        let movie = createMovieInstance(movie: movieDB[indexPath.row])
        cell.titleLabel.text = movie.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString : String = formatter.string(from: movie.releaseDate)
        cell.releaseDateLabel?.text = dateString
        store.fetchPosterImage(for: movie, isPoster: true, completion: { (posterImageResult) -> Void in
            
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
    
    func saveMoviesToDB(movies: [Movie]) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "MovieDB",
                                       in: managedContext)!
        
        for movie in movies {
            
            let predicate = NSPredicate.init(format: "movieID = %@", movie.movieID)
            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MovieDB")
            request.predicate = predicate
            do {
                let results = try managedContext.fetch(request)
                switch results.count {
                case 0:
                    do {
                        let eachMovie = NSManagedObject(entity: entity,
                                                        insertInto: managedContext)
                        
                        eachMovie.setValue(movie.title, forKeyPath: "title")
                        eachMovie.setValue(movie.movieID, forKeyPath: "movieID")
                        eachMovie.setValue(movie.releaseDate, forKeyPath: "releaseDate")
                        eachMovie.setValue(movie.posterURL.absoluteString, forKeyPath: "posterURLString")
                        eachMovie.setValue(movie.releaseDate, forKeyPath: "releaseDate")
                        eachMovie.setValue(movie.adult, forKeyPath: "adult")
                        eachMovie.setValue(movie.adult, forKeyPath: "favorite")
                        eachMovie.setValue(movie.backdropURL.absoluteString, forKeyPath: "backdropURLString")
                        eachMovie.setValue(movie.originalLanguage, forKeyPath: "originalLanguage")
                        eachMovie.setValue(movie.originalTitle, forKeyPath: "originalTitle")
                        eachMovie.setValue(movie.overview, forKeyPath: "overview")
                        eachMovie.setValue(movie.popularity, forKeyPath: "popularity")
                        eachMovie.setValue(movie.video, forKeyPath: "video")
                        eachMovie.setValue(movie.voteAverage, forKeyPath: "voteAverage")
                        eachMovie.setValue(movie.voteCount, forKeyPath: "voteCount")
                        
                        try managedContext.save()
                        movieDB.append(eachMovie)
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                default:
                    print("Found duplicate movie") // Do nothing for now.
                }
            } catch let error as NSError {
                print("Could not connect to sqlite db. Error: \(error.userInfo)")
            }
            
        }
    }
    
}
