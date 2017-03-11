//
//  movieCell.swift
//  MyFavoriteMovies
//
//  Created by Андрей Тиньков on 11.03.17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class FavoriteMovieCell: UITableViewCell {
  
  static let identifier = "FavoriteTableViewCell"
  
  func configure(with movie: Movie) {
    
    self.textLabel?.text = movie.title
//    self.imageView?.image = UIImage(named: "Film Icon")
//    self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
  }
  
  /*
  func loadMoviePoster() {
    /* TASK: Get the poster image, then populate the image view */
    if let posterPath = movie.posterPath {
      
      /* 1. Set the parameters */
      // There are none...
      
      /* 2. Build the URL */
      let baseURL = URL(string: appDelegate.config.baseImageURLString)!
      let url = baseURL.appendingPathComponent("w154").appendingPathComponent(posterPath)
      
      /* 3. Configure the request */
      let request = URLRequest(url: url)
      
      /* 4. Make the request */
      let task = appDelegate.sharedSession.dataTask(with: request) { (data, response, error) in
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
          print("There was an error with your request: \(error)")
          return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
          print("Your request returned a status code other than 2xx!")
          return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
          print("No data was returned by the request!")
          return
        }
        
        /* 5. Parse the data */
        // No need, the data is already raw image data.
        
        /* 6. Use the data! */
        if let image = UIImage(data: data) {
          performUIUpdatesOnMain {
            cell?.imageView!.image = image
          }
        } else {
          print("Could not create image from \(data)")
        }
      }
      
      /* 7. Start the request */
      task.resume()
    }
  }*/
  
}
