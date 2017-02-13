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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var movies: [NSDictionary]?
    
    var endPoint: String = ""
    
    var changedView = 0
    
    
    var smallImageURL: String = "https://image.tmdb.org/t/p/w45"
    
    var largeImageURL: String = "https://image.tmdb.org/t/p/original"
    

    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||VIEW DID LOAD||||||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableCollectionAndFlow()
        
        setNavigationBarProperties()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector(("refresh")), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        //Network Request: endpoint- now playing from Movies API
        makeNetworkRequest(refreshControl: refreshControl)
        
        tableView.reloadData()
    }
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||SET NAVIGATION PROPERTIES||||||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||
    
    func setNavigationBarProperties()
    {
        self.navigationItem.title = "FLICKZ"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "background_app"), for: .default)
            navigationBar.tintColor = UIColor.black//(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            let shadow = NSShadow()
            
            shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(2, 2)
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.black,//(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        
        }
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||
    //|||||||||||MAKE NETWORK REQUEST|||||||||
    //||||||||||||||||||||||||||||||||||||||||
    
    func makeNetworkRequest(refreshControl: UIRefreshControl?)
    {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request)
        {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data
            {
                
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                {
                    //print(dataDictionary)
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            
            self.tableView.reloadData()
            
            if let refreshControl = refreshControl
            {
                refreshControl.endRefreshing()
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
        
        }
        task.resume()
        
    }
    
    
    //|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||SETTING UP TABLE, COLLECTION, AND FLOW||||||||||
    //|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    
    func setUpTableCollectionAndFlow()
    {
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||REFRESH CONTROL ACTION|||||||||||
    //||||||||||||||||||||||||||||||||||||||||||||
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl)
    {
        makeNetworkRequest(refreshControl: refreshControl)
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||MEMORY WARNING?||||||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||||
    
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
        
        
        let posterPath = singleMovie["poster_path"] as? String
        
        
        
        let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageURL+posterPath!) as! URL)
        let largeImageRequest = NSURLRequest(url: NSURL(string: largeImageURL+posterPath!) as! URL)
        
        
        cell.posterView.setImageWith(
            smallImageRequest as URLRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                cell.posterView.alpha = 0.0
                cell.posterView.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    cell.posterView.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    cell.posterView.setImageWith(
                        largeImageRequest as URLRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            cell.posterView.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        

//        if let posterPath = singleMovie["poster_path"] as? String
//        {
//        let baseURL = "https://image.tmdb.org/t/p/w500"
//        let imageURL = NSURL(string: baseURL + posterPath)
//        //MovieCell component
//        cell.posterView.setImageWith(imageURL as! URL)
//        }
        
        //More MovieCell component
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        print(title)
        return cell
    
    }
    
        //avoid cell from staying selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||PREPARE FOR SEGUE||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "TableMovieCellSegue"
        {
            print("Sender Movie Cell")
            
            //Sends the correct element in the dictionary to the next View
            let cell1 = sender as! UITableViewCell
            let indexPath =  tableView.indexPath(for: cell1)
            
            let singleMovie = movies![indexPath!.row] //singleMovie is orginal
            
            let detailsViewController = segue.destination as! DetailsViewController
            
            detailsViewController.moviesDict = singleMovie //moviesDict is originally from detailsViewController

        }
        else if segue.identifier == "CollectionMovieCellSegue"
        {
            print ("Sender CollectionMovieCellViewCell")
            let cell2 = sender as! UICollectionViewCell
            let indexPath2 = collectionView.indexPath(for: cell2)
            
            let singleMovie2 = movies![indexPath2!.row] //singleMovie is orginal
            
            let detailsViewController2 = segue.destination as! DetailsViewController
            
            detailsViewController2.moviesDict = singleMovie2 //moviesDict is originally from detailsViewController
            
        }

    }
    
    //|||||||||||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||onTap FUNC TO SWITCH VIEWS||||||||||||||
    //|||||||||||||||||||||||||||||||||||||||||||||||||||
    
    @IBAction func onTap(_ sender: Any)
    {
        print("TAPPED ONCE")
        
        if(changedView == 0)
        {
            tableView.isHidden = true
            collectionView.isHidden = false
            changedView=1;
        }
        else
        {
            tableView.isHidden = false
            collectionView.isHidden = true
            changedView=0
        }
        
        self.collectionView.reloadData()
        
    }

}



//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||COLLECTION VIEW|||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let movies = movies
        {
            return movies.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionMovieCellViewCell
       
        let singleMovie = movies![indexPath.row]
        
        if let posterPath = singleMovie["poster_path"] as? String
        {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let imageURL = NSURL(string: baseURL + posterPath)
            //MovieCell component
            cell.biggerPosterImage.setImageWith(imageURL as! URL)
        }

        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    //Size for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (view.frame.width/2), height: 250)
    
    }

    
    
    
    
    
    
}














//|||||||||||||||||||||||||||||||||||
//|||||||||||CGSizeMake FIX||||||||||
//|||||||||||||||||||||||||||||||||||

//Quick fix for CGRectMake , CGPointMake, CGSizeMake in Swift3 & iOS10
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
//extension CGPoint{
//    init(_ x:CGFloat,_ y:CGFloat) {
//        self.init(x:x,y:y)
//    }
//}
//
//extension CGRect{
//    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
//        self.init(x:x,y:y,width:width,height:height)
//    }
//
//}


