//
//  DashboardViewController.swift
//  SchoolDemo
//
//  Created by dharmanshu on 22/12/20.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController {

    public var currentUser : String!
    @IBOutlet weak var ProfileImage: roundImageView!
    @IBOutlet weak var UIViewCard: UIView!
    @IBOutlet weak var txtWelcome: UILabel!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtClass: UILabel!
    @IBOutlet weak var txtFno: UILabel!
    @IBOutlet weak var txtFee: UILabel!
    @IBOutlet weak var txtAttendance: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIViewCard.layer.cornerRadius = 20.0
        UIViewCard.layer.shadowColor = UIColor.gray.cgColor
        UIViewCard.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        UIViewCard.layer.shadowRadius = 12.0
        UIViewCard.layer.shadowOpacity = 0.7
        
        do {
            let url = URL(string: "https://news.umanitoba.ca/wp-content/uploads/2019/03/IMG_9991-1200x800.jpg")!
            let data = try Data(contentsOf: url)
            self.ProfileImage.image = UIImage(data: data)
            self.ProfileImage.setRounded()
            
            
            
            AF.request("http://cloudseven7-001-site13.ctempurl.com/API/Dashboard/Getupdate?sno=\(123)").responseJSON { (response) in
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
                                            self.txtName.text = (tList[x]["studentName"] as! String)
                                            self.txtFno.text = (tList[x]["fatherPhone"] as! String)
                                            self.txtFee.text = (tList[x]["feePaid"] as! String)
                                            self.txtAttendance.text = (tList[x]["attendance"] as! String)
                                            //self.txtAttendance.text = (tList[x]["totalDays"] as! String)
                                            self.txtClass.text = (tList[x]["classCurrent"] as! String)
                                            self.txtAddress.text = (tList[x]["address"] as! String)
                                            //print("\(String(describing: studentName))")
                                            self.txtWelcome.text = "Welcome " + self.txtName.text!
                                        }
                                    }
                                }
                                //self.loadHomeScreen(Id: id)
                            }
                            else{
                                //self.displayErrorMessage(message: "No user found!", Title: "Not Authorised")
                            }
                        }
                    }
                    break
                case .failure( _):
                    break
                }
            }
        }
        catch{
            print(error)
        }
        
    }
}

class roundImageView: UIImageView {
    func setRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.shadowPath = UIBezierPath(rect: self.layer.bounds).cgPath
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.7
    }
}
