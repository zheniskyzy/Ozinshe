//
//  SeasonsSeriesViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 02.02.2024.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD
import SwiftyJSON

class SeasonsSeriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var movie = Movie()
    var seasons: [Season] = []
    var currentSeason = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadSeasons()
      
    }
    
    func downloadSeasons() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.GET_SEASONS + String(movie.id), method: .get, headers: headers).responseData { response in
            
            print("\(String(describing: response.request))")  // original URL request
            print("\(String(describing: response.request?.allHTTPHeaderFields))")  // all HTTP Header Fields
            print("\(String(describing: response.response))") // HTTP URL response
            print("\(String(describing: response.data))")     // server data
            print("\(response.result)")   // result of response serialization
            print("\(String(describing: response.value))")   // result of response serialization
            
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let season = Season(json: item)
                        self.seasons.append(season)
                    }
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    
    // MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = "\(seasons[indexPath.row].number) сезон"
        
        let backView = cell.viewWithTag(1000)!
        backView.layer.cornerRadius = 8
        if currentSeason == seasons[indexPath.row].number - 1 {
            label.textColor = UIColor(displayP3Red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
            backView.backgroundColor = UIColor(displayP3Red: 151/255, green: 83/255, blue: 240/255, alpha: 1)
        } else {
            label.textColor = UIColor(displayP3Red: 55/255, green: 65/255, blue: 81/255, alpha: 1)
            backView.backgroundColor = UIColor(displayP3Red: 243/255, green: 244/255, blue: 246/255, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentSeason = seasons[indexPath.row].number - 1
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seasons.isEmpty {
            return 0
        }
        return seasons[currentSeason].videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let label = cell.viewWithTag(1001) as! UILabel
        label.text = "\(seasons[currentSeason].videos[indexPath.row].number)-ші бөлім"
        
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.layer.cornerRadius = 12
        
        // ютуб превью картинка 
        imageView.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(seasons[currentSeason].videos[indexPath.row].link)/hqdefault.jpg"), completed: nil)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let playerVC = storyboard?.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
        
        playerVC.video_link = seasons[currentSeason].videos[indexPath.row].link
        
        navigationController?.show(playerVC, sender: self)
    }
    
}


    
    
  
