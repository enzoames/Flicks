//
//  DetailsViewController.swift
//  Flickz
//
//  Created by Enzo Ames on 2/4/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||LABELS AND VARIABLES|||||||||||
    //||||||||||||||||||||||||||||||||||||||||||
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    
    var moviesDict: NSDictionary! //emplicitly unwrapped dictionary. automatically unwrap if its an optional
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||VIEW DID LOAD||||||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = moviesDict["title"] as! String
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let overview = moviesDict["overview"] as! String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if let posterPath = moviesDict["poster_path"] as? String
        {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let imageURL = NSURL(string: baseURL + posterPath)
            posterImageView.setImageWith(imageURL as! URL)
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //||||||||||||||||||||||||||||||||||||||||||
    //|||||||||||PREPARE FOR SEGUE||||||||||||||
    //||||||||||||||||||||||||||||||||||||||||||


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}
