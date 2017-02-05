//
//  MoviesViewController.swift
//  Flickz
//
//  Created by Enzo Ames on 2/3/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    //|||||||||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||OUTLETS AND VARIABLES|||||||||||||||||
    //|||||||||||||||||||||||||||||||||||||||||||||||||
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    let totalColors: Int = 100
    
    //||||||||||||||||||||||||||||||||||||
    //|||||||||||COLLECTION VIEW||||||||||
    //||||||||||||||||||||||||||||||||||||
    
    func colorForIndexPath(indexPath: NSIndexPath) -> UIColor {
        if indexPath.row >= totalColors {
            return UIColor.black	// return black if we get an unexpected row index
        }
        
        var hueValue: CGFloat = CGFloat(indexPath.row) / CGFloat(totalColors)
        return UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||VIEW DID LOAD||||||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        //Network Request: endpoint- now playing from Movies API
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
       
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data
            {
                
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    
                    self.tableView.reloadData()
                }
            }
            
                MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
        
        refreshControl.endRefreshing()
        print("refresh done")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //|||||||||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||TABLE VIEW FUNCTIONS||||||||||||||||||
    //|||||||||||||||||||||||||||||||||||||||||||||||||
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = movies
        {
            return movies.count
        }
        else{
            return 0
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let singleMovie = movies![indexPath.row] //exclamation point, I am positive there is a movie here
        
        let title = singleMovie["title"] as! String
        let overview = singleMovie["overview"] as! String
        
        if let posterPath = singleMovie["poster_path"] as? String
        {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let imageURL = NSURL(string: baseURL + posterPath)
        cell.posterView.setImageWith(imageURL as! URL)
        }
        
        //CELL COMPONENTS
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        
        print(title)
        return cell
    
    }
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||PREPARE FOR SEGUE||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //Sends the correct element in the dictionary to the next View
        let cell2 = sender as! UITableViewCell
        let indexPath =  tableView.indexPath(for: cell2)
        
        let singleMovie = movies![indexPath!.row] //singleMovie Comes is orginal
        
        let detailsViewController = segue.destination as! DetailsViewController
        
        detailsViewController.moviesDict = singleMovie //moviesDict is originally from detailsViewController
        
    }

    
    
    

}






