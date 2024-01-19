//
//  PersonalInfoViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 15.01.2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var numberTextfield: UITextField!
    @IBOutlet weak var birthdateTextfield: UITextField!
 
    @IBOutlet weak var yournameLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        configureViews()
        saveButton.addTarget(self, action: #selector(closeView), for: .touchDown)
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.PROFILE_GET_URL, method: .get, encoding: JSONEncoding.default, headers: headers).responseData { response in
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
//                if let birthDate = json["birthDate"].string {
//                    self.birthdateTextfield.text = birthDate
//                    print(birthDate)
//                }
                self.nameTextfield.text = json["name"].string
                self.emailTextfield.text = json["user"]["email"].string
                self.numberTextfield.text = json["phoneNumber"].string
                
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
   
    
    @IBAction func saveinfoButton(_ sender: Any) {
       
//        let birthDate = birthdateTextfield.text ?? ""
       
        let phoneNumber = numberTextfield.text ?? ""
        let name = nameTextfield.text ?? ""
        
        
        let parameters = ["name": name, "phoneNumber": phoneNumber]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.PROFILE_UPDATE_URL, method: .put, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            var resultString = ""
            if let data = response.data{
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200{
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                self.nameTextfield.text = json["name"].string
                self.emailTextfield.text = json["user"]["email"].string
                self.numberTextfield.text = json["phoneNumber"].string
                
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
    
    
    
    
    @objc func closeView() {
        self.navigationController?.popViewController(animated: true)
       }
    
    func configureViews(){
        yournameLabel.text = "YOUR_NAME".localized()
        birthdateLabel.text = "BIRTH_DATE".localized()
        saveButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
        title = "PERSONAL_INFO".localized()
        
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
