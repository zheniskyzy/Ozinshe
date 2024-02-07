//
//  CategoryTableViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 21.01.2024.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class CategoryTableViewController: UITableViewController {

    var categoryAgeID = 0
    var categoryID = 0
    var genreID = 0
    var genreName = ""
    var categoryName = ""
    var movies:[Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = categoryName
     let MovieCellnib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        
        downlaodMoviesByCategory()
        downlaodMoviesByGenre()
        downlaodMoviesByAges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let MovieCellnib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.reloadData()
    }
    

    func downlaodMoviesByCategory(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        let parameters = ["categoryId": categoryID]
        
        AF.request(Urls.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                if json["content"].exists(){
                    if let array = json["content"].array{
                        for item in array{
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }
                        
                        
                        self.tableView.reloadData()
                     }
                    }else{
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }
                
                
            }else{
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    func downlaodMoviesByGenre(){
        SVProgressHUD.show()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        let parameters = ["genreId": genreID, "name": genreName] as [String : Any]

        AF.request(Urls.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{

                let json = JSON(response.data!)
                    print("JSON: \(json)")

                if json["content"].exists(){
                    if let array = json["content"].array{
                        for item in array{
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }


                        self.tableView.reloadData()
                     }
                    }else{
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }


            }else{
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    func downlaodMoviesByAges(){
        SVProgressHUD.show()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        let parameters = ["categoryAgeId": categoryAgeID]

        AF.request(Urls.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{

                let json = JSON(response.data!)
                    print("JSON: \(json)")

                if json["content"].exists(){
                    if let array = json["content"].array{
                        for item in array{
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }


                        self.tableView.reloadData()
                     }
                    }else{
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }


            }else{
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode{
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
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
       return movies.count
   }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
       // Configure the cell...
   
       cell.setData(movie: movies[indexPath.row])
       
       
       return cell
   }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       153
   }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
        
        movieinfoVC.movie  = movies[indexPath.row]
        
        navigationController?.show(movieinfoVC, sender: self)
    }
    
}
