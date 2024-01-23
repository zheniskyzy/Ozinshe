//
//  MainPageViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 23.01.2024.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD
import SwiftyJSON

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    

    @IBOutlet weak var tableview: UITableView!
    var mainMovies: [MainMovies] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
        addNavBarImage()
        downloadMainMovies()
    }
    
    // почему- то картинка сжатая какая-то, скачивала все верно как обычно вроде
    func addNavBarImage(){
        let image = UIImage(named: "logoMainPage")!
        
        let logoImageView = UIImageView(image: image)
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        
        navigationItem.leftBarButtonItem = imageItem
    }

    func downloadMainMovies(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.MAIN_MOVIES_URL, method: .get, headers: headers).responseData { response in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        cell.setData(mainMovie: mainMovies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 288.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = mainMovies[indexPath.row].categoryId
        categoryTableViewController.categoryName = mainMovies[indexPath.row].categoryName
        
        navigationController?.show(categoryTableViewController, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
