//
//  ViewController.swift
//  SchoolDemo
//
//  Created by dharmanshu on 22/12/20.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnLogin_Pressed(_ sender: UIButton) {
        let username = txtUsername.text! as String
        let password = txtPassword.text! as String
        AF.request("http://cloudseven7-001-site13.ctempurl.com/API/Student/Verify?username=\(username)&password=\(password)").responseJSON { (response) in
            
            var id : String!
            switch response.result {
            case .success(let value):
                let jsonDate = [value]
                for Data in jsonDate {
                    if let obj = Data as? [String: Any] {
                        let type = obj["message"] as! String
                        if type == "Data Found" {
                            if let obj = Data as? [String: Any] {
                                if let type = obj["data"] as? [AnyObject],type.count>0{
                                    let tList = type
                                    for x in 0..<tList.count {
                                        id = (tList[x]["sNo"] as! String)
                                        print("\(String(describing: id))")
                                    }
                                }
                            }
                            self.loadHomeScreen(Id: id)
                        }
                        else{
                            self.displayErrorMessage(message: "No user found!", Title: "Not Authorised")
                        }
                    }
                }
                break
            case .failure( _):
                break
            }
        }
    }
    
    func loadHomeScreen(Id:String){
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let DashboardViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        DashboardViewController.modalPresentationStyle = .fullScreen
        DashboardViewController.currentUser = Id
         self.present(DashboardViewController, animated: true, completion: nil)
     }
    
    func displayErrorMessage(message:String, Title:String) {
         let alertView = UIAlertController(title: Title, message: message, preferredStyle: .alert)
         let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
         }
         alertView.addAction(OKAction)
         if let presenter = alertView.popoverPresentationController {
             presenter.sourceView = self.view
             presenter.sourceRect = self.view.bounds
         }
         self.present(alertView, animated: true, completion:nil)
     }
}


extension UIViewController {
 class func displaySpinner(onView : UIView) -> UIView {
     let spinnerView = UIView.init(frame: onView.bounds)
     spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style: .whiteLarge)
     ai.startAnimating()
     ai.center = spinnerView.center
     DispatchQueue.main.async {
         spinnerView.addSubview(ai)
         onView.addSubview(spinnerView)
     }
     return spinnerView
 }
 class func removeSpinner(spinner :UIView) {
     DispatchQueue.main.async {
         spinner.removeFromSuperview()
     }
 }
}


