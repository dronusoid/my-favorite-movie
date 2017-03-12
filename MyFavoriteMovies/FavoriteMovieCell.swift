//
//  movieCell.swift
//  MyFavoriteMovies
//
//  Created by Андрей Тиньков on 11.03.17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteMovieCell: UITableViewCell {
  
  static let identifier = "FavoriteTableViewCell"
  
  let disposeBag = DisposeBag()
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  
  func configure(with movie: Movie) {
    //Cell configuration
    
    self.textLabel?.text = movie.title
    loadMoviePoster(from: movie.posterPath)
  }
  
  
  private func loadMoviePoster(from posterPath: String?) {
    // Get the poster image, then populate the image view
    
    // check that posterPath is not nil
    guard let posterPath = posterPath, posterPath != "" else {
      print("Poster path is empty")
      return
    }
    
    /* 1. Set the parameters */
    // There are none...
    
    /* 2. Build the URL */
    let baseURL = URL(string: appDelegate.config.baseImageURLString)!
    let url = baseURL.appendingPathComponent("w154")
      .appendingPathComponent(posterPath)
    
    /* 3. Configure the request */
    let request = URLRequest(url: url)
    
    /* 4. Make the request */
    let loadPoster = appDelegate.sharedSession.rx.data(request: request)
    
    loadPoster.subscribe(onNext: {
      data in
        /* 5. Parse the data */
        // No need, the data is already raw image data.
        
        /* 6. Use the data! */
        
        if let image = UIImage(data: data) {
          performUIUpdatesOnMain {
            self.imageView?.image = image
          }
        } else {
          print("Could not create image from \(data)")
        }
    }
      , onError: {
        error in
        print("There was an error with image request: \(error)")
    })
      .addDisposableTo(disposeBag)
  }
  
}
