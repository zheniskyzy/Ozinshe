//
//  ProfileViewController.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 10.01.2024.
//

import UIKit
import Localize_Swift

class ProfileViewController: UIViewController, LanguageProtocol{

    @IBOutlet weak var myProfileLabel: UILabel!
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var personalInfoButtton: UIButton!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var conditionsButton: UIButton!
    @IBOutlet weak var announcementsButton: UIButton!
    @IBOutlet weak var darkmodeButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      configureViews()
    }
    
    
    func configureViews(){
        myProfileLabel.text = "MY_PROFILE".localized()
        languageButton.setTitle("LANGUAGE".localized(), for: .normal)
        personalInfoButtton.setTitle("PERSONAL_INFO".localized(), for: .normal)
        changeLabel.text = "CHANGE".localized()
        changePasswordButton.setTitle("CHANGE_PASSWORD".localized(), for: .normal)
        conditionsButton.setTitle("TERMS_AND_CONDITIONS".localized(), for: .normal)
        announcementsButton.setTitle("ANNOUNCEMENTS".localized(), for: .normal)
        darkmodeButton.setTitle("DARK_MODE".localized(), for: .normal)
        
        
        if Localize.currentLanguage() == "ru"{
            languageLabel.text = "Русский"
        }
        if Localize.currentLanguage() == "kk"{
            languageLabel.text = "Қазақша"
        }
        if Localize.currentLanguage() == "en"{
            languageLabel.text = "English"
        }
    }
    
    @IBAction func personalinfoShow(_ sender: Any) {
        let personalinfoVC = storyboard?.instantiateViewController(withIdentifier: "PersonalInfoViewController") as! PersonalInfoViewController
//        present(personalinfoVC, animated: true, completion: nil)
        navigationController?.show(personalinfoVC, sender: self)
        
    }
    
    @IBAction func languageShow(_ sender: Any) {
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.modalPresentationStyle = .overFullScreen
        languageVC.delegate = self
        present(languageVC, animated: true,completion: nil)
    }
    
    @IBAction func Exist(_ sender: Any) {
        let existVC = storyboard?.instantiateViewController(withIdentifier: "ExistViewController") as! ExistViewController
        existVC.modalPresentationStyle = .overFullScreen
        present(existVC, animated: true,completion: nil)
        
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
        let changePassVC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        navigationController?.show(changePassVC, sender: self)
    }
    
    
    func languageDidChange() {
        configureViews()
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
