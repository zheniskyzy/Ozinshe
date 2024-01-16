//
//  PersonalInfoViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 15.01.2024.
//

import UIKit


class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var numberTextfield: UITextField!
    @IBOutlet weak var birthdateTextfield: UITextField!
 
    @IBOutlet weak var yournameLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    let defaults = UserDefaults.standard
    var personInfo = PersonInfo()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
        saveButton.addTarget(self, action: #selector(closeView), for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let name = defaults.object(forKey: "name") as? String {
              nameTextfield.text = name
            }
        
        if let email = defaults.object(forKey: "email") as? String{
            emailTextfield.text = email
        }
        
        if let number = defaults.object(forKey: "number") as? String{
            numberTextfield.text = number
        }
        
        if let birthday = defaults.object(forKey: "birthday") as? String{
            birthdateTextfield.text = birthday
        }
    }
    
    
    @IBAction func saveinfoButton(_ sender: Any) {
        
        let name = nameTextfield.text ?? ""
        personInfo.name = name
        
        let email = emailTextfield.text ?? ""
        personInfo.email = email
        
        let number = numberTextfield.text ?? ""
        personInfo.number = number
        
        let birthday = birthdateTextfield.text ?? ""
        personInfo.birthday = birthday
        
        defaults.set(name, forKey: "name")
        defaults.set(email,forKey: "email")
        defaults.set(number, forKey: "number")
        defaults.set(birthday, forKey: "birthday")
        
    }
    
    
    
    
    @objc func closeView() {
           self.dismiss(animated: true, completion: nil)
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
