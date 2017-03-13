//
//  FavViewController.swift
//  TheMovieDBSwift
//
//  Created by Larry Bulen on 3/12/17.
//  Copyright © 2017 Larry Bulen. All rights reserved.
//

import UIKit

class FavViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var favTableView: UITableView!
    var favMovieArray = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favMovieArray.append(Movie())        
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favMovieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "UITableViewCell"
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = favMovieArray[indexPath.row].title
        cell.detailTextLabel?.text = favMovieArray[indexPath.row].movieID
        
        return cell
    }
    
}
