//
//  FavoriteTableViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 09.01.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class FavoriteTableViewController: UITableViewController {
    
    var favorites: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let MovieCellnib = UINib(nibName: "MovieCell", bundle: nil)
           tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
        downloadFavorites()
    }
    
    func configureView(){
        navigationItem.title = "FAVORITE".localized()
    }
    
    func downloadFavorites(){
        SVProgressHUD.show()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.FAVORITE_URL, method: .get, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    if let array = json.array{
                        for item in array{
                            let movie = Movie(json: item)
                            self.favorites.append(movie)
                        }
                        self.tableView.reloadData()
                    }else{
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }
                
                
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        // Configure the cell...
    
        cell.setData(movie: favorites[indexPath.row])
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        153
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
        
        movieinfoVC.movie  = favorites[indexPath.row]
        
        navigationController?.show(movieinfoVC, sender: self)
    }
}
