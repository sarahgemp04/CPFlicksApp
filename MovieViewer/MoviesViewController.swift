//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Sarah Gemperle on 1/6/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

        @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
        @IBOutlet weak var collectionView: UICollectionView!
        var movies: [NSDictionary]?
        var genreDic: [NSDictionary]?
        var endpoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
      
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.collectionView.reloadData()
                }
            }
        }
        
        task.resume()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.collectionView.reloadData()
                    refreshControl.endRefreshing()

                    
                    
                }
            }
        }
                task.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies {
            print("TOTAL MOVIES COUNT IS:  \(movies.count)")
            return movies.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let color = UIColor.init(red:  0,
                                 green: 0,
                                 blue: 0,
                                 alpha: 0)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = color
        cell.selectedBackgroundView = backgroundView
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageURL = (string: baseUrl + posterPath)
            
            let imageRequest = NSURLRequest(url: NSURL(string: imageURL)! as URL)
            cell.posterView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animate(withDuration: 1, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            

        }
        
        cell.movieTitle.text = title
        
                //cell.posterView.setImageWith(imageURL as! URL)
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toInformation") {
            
            //Determine cell pushed and set its indexPath to let indexPath.
            let cell = sender as! UICollectionViewCell;
            let indexPath = collectionView.indexPath(for: cell);
            
            //Access destintation view controller
            let destination = segue.destination as! InformationViewController
            
            //access the movie dictionary for the specific movie at the indexPath tapped on.
            let movie = movies![(indexPath!.row)]
           
            //Define InformationViewController's global variables appropriately to the movie tapped's information.
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let posterPath = movie["poster_path"] as! String
            let imageURL = NSURL(string: baseUrl + posterPath)
            
            destination.movieImage = imageURL as? URL
            destination.movieTitle = movie["title"] as? String
            destination.summary = movie["overview"] as? String
            destination.movRating = (movie["vote_average"]! as AnyObject).stringValue
            destination.votes = (movie["vote_count"]! as AnyObject).stringValue
            destination.date = movie["release_date"] as? String

        }
    
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
