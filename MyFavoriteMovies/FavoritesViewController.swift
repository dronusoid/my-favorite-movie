//
//  FavoritesTableViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - FavoritesViewController: UIViewController

class FavoritesViewController: UIViewController {
  
  // MARK: Properties
  
  var appDelegate: AppDelegate!
  let movies: Variable<[Movie]> = Variable([])
  let disposeBag = DisposeBag()
  
  @IBOutlet var favoritesTableView: UITableView!
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // get the app delegate
    appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // create and set logout button
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .reply,
      target: self,
      action: #selector(logout))
    
    setupTableCells()
  }
  
  
  private func setupTableCells() {
    
    movies.asObservable()
      .bindTo(favoritesTableView
        .rx
        .items(cellIdentifier: FavoriteMovieCell.identifier,
               cellType: FavoriteMovieCell.self)) {
                row, movie, cell in
                cell.configure(with: movie)
    }
    .addDisposableTo(disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    loadFavoriteMoviesFromServer()
  }
  
  
  func loadFavoriteMoviesFromServer() {
    /* TASK: Get movies from favorite list from server */
    
    /* 1. Set the parameters */
    let methodParameters = [
      Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey,
      Constants.TMDBParameterKeys.SessionID: appDelegate.sessionID!
    ]
    
    /* 2/3. Build the URL, Configure the request */
    let request = NSMutableURLRequest(url: appDelegate.tmdbURLFromParameters(
      methodParameters as [String:AnyObject],
      withPathExtension: "/account/\(appDelegate.userID!)/favorite/movies"))
    
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    /* 4. Make the request */
    let task = appDelegate.sharedSession.dataTask(with: request as URLRequest) {
      
      (data, response, error) in
      
      /* GUARD: Was there an error? */
      guard (error == nil) else {
        print("There was an error with your request: \(error)")
        return
      }
      
      /* GUARD: Did we get a successful 2XX response? */
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
        statusCode >= 200 && statusCode <= 299 else {
          print("Your request returned a status code other than 2xx!")
          return
      }
      
      /* GUARD: Was there any data returned? */
      guard let data = data else {
        print("No data was returned by the request!")
        return
      }
      
      /* 5. Parse the data */
      let parsedResult: [String:AnyObject]!
      do {
        parsedResult = try JSONSerialization.jsonObject(with: data,
                                                        options: .allowFragments)
          as! [String:AnyObject]
      } catch {
        print("Could not parse the data as JSON: '\(data)'")
        return
      }
      
      /* GUARD: Did TheMovieDB return an error? */
      if let _ = parsedResult[Constants.TMDBResponseKeys.StatusCode] as? Int {
        print("TheMovieDB returned an error. See the ",
              "'\(Constants.TMDBResponseKeys.StatusCode)'",
          "and '\(Constants.TMDBResponseKeys.StatusMessage)' in \(parsedResult)")
        return
      }
      
      /* GUARD: Is the "results" key in parsedResult? */
      guard let results = parsedResult[Constants.TMDBResponseKeys.Results]
        as? [[String:AnyObject]] else {
          print("Cannot find key '\(Constants.TMDBResponseKeys.Results)'",
            "in \(parsedResult)")
          return
      }
      
      /* 6. Use the data! */
      self.movies.value = Movie.moviesFromResults(results)
      
    }
    
    /* 7. Start the request */
    task.resume()
  }
  
  
  // MARK: Logout
  
  func logout() {
    dismiss(animated: true, completion: nil)
  }
  
}
