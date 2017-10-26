//
//  AppointmentViewController.swift
//  AppSquadJavascriptWikitudeSwift
//
//  Created by Pooja Shah on 5/15/17.
//  Copyright © 2017 Sneha Kasetty Sudarshan. All rights reserved.
//

import Foundation


import UIKit
import HealthKit
import SwiftyJSON

class AppointmentViewController: UIViewController, UITableViewDelegate
{
    
    
    
    var jsonString : JSON?
    var name: String?
    var doctor: String?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var docLabel: UILabel!
    @IBOutlet weak var tableViewCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getAppointments(completion: { (json: JSON) -> () in
            print(json)
            self.jsonString = json
            for i in 0..<json.count {
                let name = json[i]["doctor"].string
                
                print(name as Any)
            }
            
            self.tableViewCell.reloadData()
        })
        
    }
    
    
    func getAppointments(completion: @escaping (JSON) -> ()){
        let target = "http://54.193.47.19:8070/patients"
    
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        NSLog("DataManager| using loginURL: " + target)
    
        let url:URL = URL(string: target)!
        //let session = URLSession.shared
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
        
            guard let data = data, let _:URLResponse = response  , error == nil else {
                NSLog("DataManager| error :")
                print(response as Any)
                return
            }
           
            let json = JSON(data: data)
            completion(json)
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return (jsonString?.count)!
    }
    
    
    

   
}
