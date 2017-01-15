//
//  InformationViewController.swift
//  
//
//  Created by Sarah Gemperle on 1/7/17.
//
//

import UIKit
import AFNetworking

class InformationViewController: UIViewController {

    var summary: String?
    var movieTitle: String?
    var movieImage: URL?
    var movRating: String?
    var votes: String?
    var date: String?
    var genreList: String?
    
    @IBOutlet weak var currMovieImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var currMovieSummary: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var currMovieTitle: UILabel!
    @IBOutlet weak var infoSubView: UIView!
   
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var numVotes: UILabel!
    @IBOutlet weak var yearReleased: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                currMovieTitle.text = movieTitle!
       
        currMovieSummary.text = summary!
        currMovieSummary.sizeToFit()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoSubView.frame.origin.y + infoSubView.frame.size.height)
        
        navBar.title = movieTitle!
        
        rating.text = movRating! + " / 10"
        numVotes.text = "(" + votes! + " votes)"
        yearReleased.text = "(" + date!.substring(to: date!.index(date!.startIndex, offsetBy: 4)) + ")"
        
        let imageRequest = NSURLRequest(url: movieImage!)
        currMovieImage.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                    self.currMovieImage.alpha = 0.0
                    self.currMovieImage.image = image
                    UIView.animate(withDuration: 1, animations: { () -> Void in
                        self.currMovieImage.alpha = 1.0
                    })
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })

       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
