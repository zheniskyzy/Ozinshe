//
//  SearchViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 21.01.2024.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD



class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}


class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    
   
    

    @IBOutlet weak var searchTextField: TextFieldWithPadding!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var tableViewToLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewCollectionConstraint: NSLayoutConstraint!
    
    var categories: [Category] = []
    var movies: [Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        downloadCategories()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        searchTextField.placeholder = "SEARCH".localized()
        topLabel.text = "CATEGORIES".localized()
        navigationItem.title = "SEARCH".localized()
        
    }
    
    // MARK: - Configure Views
    
    func configureViews(){
        
       
        
        //collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 100
        collectionView.collectionViewLayout = layout
        
        //searchTextField
        searchTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
        searchTextField.layer.cornerRadius = 12.0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        //tableView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let MovieCellnib = UINib(nibName: "MovieCell", bundle: nil)
           tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        
    }
    
    
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        
        downloadSearchMovies()
    }
    
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func clearTextField(_ sender: Any) {
        searchTextField.text = ""
        downloadSearchMovies()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        downloadSearchMovies()
        
    }
    
    
    // MARK: - downloadCategories
    func downloadCategories(){
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.CATEGORIES_URL, method: .get, headers: headers).responseData { response in
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
                            let category = Category(json: item)
                            self.categories.append(category)
                        }
                        self.collectionView.reloadData()
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

    //MARK: - downloadSearchMovies
    func downloadSearchMovies(){
    
        if searchTextField.text!.isEmpty{
            topLabel.text = "Санаттар"
            collectionView.isHidden = false
            tableViewToLabelConstraint.priority = .defaultLow
            tableViewCollectionConstraint.priority = .defaultHigh
            tableView.isHidden = true
            movies.removeAll()
            tableView.reloadData()
            clearButton.isHidden = true
            return
        }else{
            topLabel.text = "SEARCH_RESULT".localized()
            collectionView.isHidden = true
            tableViewToLabelConstraint.priority = .defaultHigh
            tableViewCollectionConstraint.priority = .defaultLow
            tableView.isHidden = false
            clearButton.isHidden = false
        }
        SVProgressHUD.show()
        
        let parameters = ["search": searchTextField.text!]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        AF.request(Urls.SEARCH_MOVIES_URL, method: .get,parameters: parameters, headers: headers).responseData { response in
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
                        self.movies.removeAll()
                        self.tableView.reloadData()
                        for item in array{
                            let movie = Movie(json: item)
                            self.movies.append(movie)
                        }
                        self.tableView.reloadData()
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
    
    
    
    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = categories[indexPath.row].name
        
        let backgroundview = cell.viewWithTag(1000)
        backgroundview?.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = categories[indexPath.row].id
        categoryTableViewController.navigationItem.title = categories[indexPath.row].name
        navigationController?.show(categoryTableViewController, sender: self)
        
        
    
    }
    
    //MARK: - tableView
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        // Configure the cell...
    
        cell.setData(movie: movies[indexPath.row])
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        153
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
