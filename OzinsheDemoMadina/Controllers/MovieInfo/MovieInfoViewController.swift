//
//  MovieInfoViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 01.02.2024.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SDWebImage


class MovieInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fullDescriptionButton: UIButton!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var descriptionGradientView: GradientView!
    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var seasonsButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    @IBOutlet weak var screenshotCollectionView: UICollectionView!
    
    @IBOutlet weak var addToFavoriteLabel: UILabel!
    @IBOutlet weak var sharingLabel: UILabel!
    @IBOutlet weak var directorLabel1: UILabel!
    @IBOutlet weak var producerLabel1: UILabel!
    @IBOutlet weak var screenshotsLabel: UILabel!
    
    @IBOutlet weak var similarTVLabel: UILabel!
    

    var movie = Movie()
    var similarMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setData()
        configureViews()
        
        downloadSimilar()
        configureViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configureViews()
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureViews(){
        
        addToFavoriteLabel.text = "ADD_TO_FAVORITE".localized()
        sharingLabel.text = "SHARE".localized()
        fullDescriptionButton.setTitle("READ_MORE".localized(), for: .normal)
        directorLabel1.text = "DIRECTOR".localized()
        producerLabel1.text = "PRODUCER".localized()
        seasonsLabel.text = "DEPARTMENTS".localized()
        screenshotsLabel.text = "SCREENSHOTS".localized()
        similarTVLabel.text = "SIMILAR_TV".localized()
        
        // backgroundView
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // изначально что бы было 4 линии
        descriptionLabel.numberOfLines = 4
       
        screenshotCollectionView.dataSource = self
        screenshotCollectionView.delegate = self
        
        if movie.movieType == "MOVIE" {
            seasonsLabel.isHidden = true
            seasonsButton.isHidden = true
            arrowImageView.isHidden = true
        }else{
            seasonsButton.setTitle("\(movie.seasonCount) сезон, \(movie.seriesCount) серия", for: .normal)
        }
        
        if descriptionLabel.maxNumberOfLines < 5 {
            fullDescriptionButton.isHidden = true
        }
        if movie.favorite{
            favoriteButton.setImage(UIImage(named: "favoriteSelectedButton"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(named: "favoriteButton"), for: .normal)
        }
    }
        func setData() {
            posterImageView.sd_setImage(with: URL(string: movie.poster_link), completed: nil)
            nameLabel.text = movie.name
            detailLabel.text = "\(movie.year)"
            
            for item in movie.genres {
                detailLabel.text = detailLabel.text! + " • " + item.name
            }
            
            descriptionLabel.text = movie.description
            
            directorLabel.text = movie.director
            
            producerLabel.text = movie.producer
        }
    
    
    @IBAction func showMore(_ sender: Any) {
        
        if movie.movieType == "MOVIE" {
            let playerVC = storyboard?.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
            
            playerVC.video_link = movie.video_link
        
            
            navigationController?.show(playerVC, sender: self)
        } else {
            let seasonsVC = storyboard?.instantiateViewController(withIdentifier: "SeasonsSeriesViewController") as! SeasonsSeriesViewController
            
            seasonsVC.movie = movie
            
            navigationController?.show(seasonsVC, sender: self)
        }
        
    }
    
        func downloadSimilar() {
            SVProgressHUD.show()
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
            ]
            
            AF.request(Urls.GET_SIMILAR + String(movie.id), method: .get, headers: headers).responseData { response in
                
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
                            let movie = Movie(json: item)
                            self.similarMovies.append(movie)
                        }
                        self.similarCollectionView.reloadData()
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
        
        
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playMovie(_ sender: Any) {
        if movie.movieType == "MOVIE" {
            let playerVC = storyboard?.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
            
            playerVC.video_link = movie.video_link
        
            
            navigationController?.show(playerVC, sender: self)
        } else {
            let seasonsVC = storyboard?.instantiateViewController(withIdentifier: "SeasonsSeriesViewController") as! SeasonsSeriesViewController
            
            seasonsVC.movie = movie
            
            navigationController?.show(seasonsVC, sender: self)
        }
    }
    
    @IBAction func addToFavorite(_ sender: Any) {
        var method = HTTPMethod.post
        if movie.favorite {
            method = .delete
        }
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        
        let parameters = ["movieId": movie.id] as [String : Any]
        
        AF.request(Urls.FAVORITE_URL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
 
                
                self.movie.favorite.toggle()
                
                self.configureViews()
                
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
    
    
    @IBAction func shareMovie(_ sender: Any) {
        let text = "\(movie.name) \n\(movie.description)"
        let image = posterImageView.image
        let shareAll = [text, image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        // вспылающее окно где можно отправить либо скопировать и тд
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func fullDescription(_ sender: Any) {
        
        if descriptionLabel.numberOfLines > 4 {
            descriptionLabel.numberOfLines = 4
            fullDescriptionButton.setTitle("Толығырақ", for: .normal)
            descriptionGradientView.isHidden = false
        } else {
            descriptionLabel.numberOfLines = 30
            fullDescriptionButton.setTitle("Жасыру", for: .normal)
            descriptionGradientView.isHidden = true
        }
        
    }
    
    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.similarCollectionView {
            return similarMovies.count
        }
        return movie.screenshots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarCollectionView {
            let similarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
            
            let imageview = similarCell.viewWithTag(1000) as! UIImageView
            imageview.sd_setImage(with: URL(string: similarMovies[indexPath.row].poster_link), placeholderImage: nil, context: [.imageTransformer: transformer])
            imageview.layer.cornerRadius = 8
            
            //movieNameLabel
            let movieNameLabel = similarCell.viewWithTag(1001) as! UILabel
            movieNameLabel.text = similarMovies[indexPath.row].name
            
            let movieGenreNameLabel = similarCell.viewWithTag(1002) as! UILabel
            if let genrename = similarMovies[indexPath.row].genres.first {
                movieGenreNameLabel.text = genrename.name
            } else {
                movieGenreNameLabel.text = ""
            }
            
            return similarCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //imageview
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.layer.cornerRadius = 8
        
        imageview.sd_setImage(with: URL(string: movie.screenshots[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.similarCollectionView {
            let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
            
            movieinfoVC.movie  = similarMovies[indexPath.row]
            
            navigationController?.show(movieinfoVC, sender: self)
        }
    }
    
    
    
    
}
