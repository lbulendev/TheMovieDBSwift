//
//  FavViewController.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit
import CoreData

class FavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var favTableView: UITableView!
    var favMovieArray = [NSManagedObject]()
    let cellIdentifier: String = "UITableViewCell"

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let predicate = NSPredicate.init(format: "favorite = %@", "1")
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MovieDB")
        request.predicate = predicate
        
        do {
            favMovieArray = try managedContext.fetch(request) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.delegate = self
        favTableView.dataSource = self
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favMovieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UITableViewCell
                
        cell.textLabel?.text = favMovieArray[indexPath.row].value(forKey: "title") as? String
        cell.detailTextLabel?.text = favMovieArray[indexPath.row].value(forKey: "originalTitle") as? String
        
        return cell
    }
    
}
