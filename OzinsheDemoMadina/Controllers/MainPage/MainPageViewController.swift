//
//  MainPageViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 23.01.2024.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieProtocol {
    
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var mainMovies: [MainMovies] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        addNavBarImage()
        downloadMainBanners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
        
    }
    
    // почему- то картинка сжатая какая-то, скачивала все верно как обычно вроде
    func addNavBarImage(){
        let image = UIImage(named: "logoMainPage")!
        
        let logoImageView = UIImageView(image: image)
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        
        navigationItem.leftBarButtonItem = imageItem
    }
    
    //MARK: - downloades
    //step 1
    
    func downloadMainBanners(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.MAIN_BANNERS_URL, method: .get, headers: headers).responseData { response in
            //            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array{
                    let movie = MainMovies()
                    movie.cellType = .mainBanner
                    for item in array{
                        let bannerMovie = BannerMovie(json: item)
                        movie.bannerMovie.append(bannerMovie)
                        
                    }
                    self.mainMovies.append(movie)
                    self.tableview.reloadData()
                }else{
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
                
                
            }
            self.downloadUserHistory()
        }
    }
    
    // step 2
    func downloadUserHistory(){
        //        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.USER_HISTORY_URL, method: .get, headers: headers).responseData { response in
            //            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array{
                    let movie = MainMovies()
                    movie.cellType = .userHistory
                    for item in array{
                        let historyMovie = Movie(json: item)
                        movie.movies.append(historyMovie)
                    }
                    if array.count > 0{
                        self.mainMovies.append(movie)
                    }
                    self.tableview.reloadData()
                }else{
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
                
                
            }
            self.downloadMainMovies()
        }
    }
    
    // step 3
    func downloadMainMovies(){
        //        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.MAIN_MOVIES_URL, method: .get, headers: headers).responseData { response in
            //            SVProgressHUD.dismiss()
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
                        let movie = MainMovies(json: item)
                        self.mainMovies.append(movie)
                    }
                    self.tableview.reloadData()
                }else{
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
                
                
            }
            self.downloadGenres()
        }
    }
    
    // step 4
    func downloadGenres(){
        //        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.GET_GENRES_URL, method: .get, headers: headers).responseData { response in
            //            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array{
                    let movie = MainMovies()
                    movie.cellType = .genre
                    for item in array{
                        let genre = Genre(json: item)
                        movie.genres.append(genre)
                    }
                    if self.mainMovies.count > 4{
                        if self.mainMovies[1].cellType == .userHistory{
                            self.mainMovies.insert(movie, at: 4)
                        }else{
                            self.mainMovies.insert(movie, at: 3)
                        }
                    }else{
                        self.mainMovies.append(movie)
                    }
                    
                    self.tableview.reloadData()
                }else{
                    var ErrorString = "CONNECTION_ERROR".localized()
                    if let sCode = response.response?.statusCode{
                        ErrorString = ErrorString + "\(sCode)"
                    }
                    ErrorString = ErrorString + "\(resultString)"
                    SVProgressHUD.showError(withStatus: "\(ErrorString)")
                }
                
                
            }
            self.downloadCategoryAges()
        }
    }
    
    // step 5
    func downloadCategoryAges(){
        //        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.GET_AGES_URL, method: .get, headers: headers).responseData { response in
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
                    let movie = MainMovies()
                    movie.cellType = .ageCategory
                    for item in array{
                        let ageCategory = CategoryAge(json: item)
                        movie.categoryAges.append(ageCategory)
                    }
                    if self.mainMovies.count > 8{
                        if self.mainMovies[1].cellType == .userHistory{
                            self.mainMovies.insert(movie, at: 8)
                        }else{
                            self.mainMovies.insert(movie, at: 7)
                        }
                    }else{
                        self.mainMovies.append(movie)
                    }
                    self.tableview.reloadData()
                }else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            }else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    //MARK: - tableview data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainMovies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // mainBanner
        if mainMovies[indexPath.row].cellType == .mainBanner{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainBannerCell", for: indexPath) as! MainBannerTableViewCell
            cell.setData(mainMovie: mainMovies[indexPath.row])
            cell.delegate = self
            
            return cell
        }
        
        // userHistory
        if mainMovies[indexPath.row].cellType == .userHistory{
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
            cell.setData(mainMovie: mainMovies[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        //Genre
        if mainMovies[indexPath.row].cellType == .genre || mainMovies[indexPath.row].cellType == .ageCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenreAgeCell", for: indexPath) as! GenreAgeTableViewCell
            cell.setData(mainMovie: mainMovies[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        cell.setData(mainMovie: mainMovies[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mainMovies[indexPath.row].cellType == .mainBanner{
            return 272.0
        }
        if mainMovies[indexPath.row].cellType == .userHistory{
            return 228.0
        }
        if mainMovies[indexPath.row].cellType == .genre || mainMovies[indexPath.row].cellType == .ageCategory{
            return 184.0
        }
        // mainMovie
        return 288.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainMovies[indexPath.row].cellType != .mainMovie{
            return
        }
        
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = mainMovies[indexPath.row].categoryId
        categoryTableViewController.categoryName = mainMovies[indexPath.row].categoryName
        
        navigationController?.show(categoryTableViewController, sender: self)
    }
    
    // кликабельность и переход
    func movieDidSelect(movie: Movie) {
        let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
        
        movieinfoVC.movie  = movie
        
        navigationController?.show(movieinfoVC, sender: self)
    }
    
    func genreDidSelect(genreId: Int, genreName: String) {
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.genreID = genreId
        categoryTableViewController.genreName = genreName

        navigationController?.show(categoryTableViewController, sender: self)
    }
    func ageCategoryDidSelect(categoryAgeId: Int) {
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryAgeID = categoryAgeId

        navigationController?.show(categoryTableViewController, sender: self)
    }
    
}
