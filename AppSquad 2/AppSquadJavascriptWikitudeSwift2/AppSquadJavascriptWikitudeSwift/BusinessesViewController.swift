//
//  BusinessesViewController.swift
//  SkinCare
//
//  Created by Pooja Shah on 5/4/17.
//  Copyright © 2017 Pooja Shah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate {
   
    @IBOutlet weak var tablesView: UITableView!
    
    var selectedDoctor : String?
    var indexOfSelectedDoctor = 0
    var businesses: [Business]!
    var locationManager: CLLocationManager!
    var long : Double = 0.0, lat : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager  = CLLocationManager()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else{
            print("Location service disabled");
        }
        
        //self.lat = (locationManager.location?.coordinate.latitude)!
        //self.long = (locationManager.location?.coordinate.longitude)!
        
        tablesView.delegate = self
        tablesView.dataSource = self
        
        //SEARCH USING  YELP API
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.lat = (self.locationManager.location?.coordinate.latitude)!
            self.long = (self.locationManager.location?.coordinate.longitude)!
            if(self.lat != 0.0 || self.long != 0.0) {
                let locationVal = String(self.lat) + "," + String(self.long)
                print("from business \(locationVal)")
                
                Business.searchWithTerm(term: "Dermatologists", locationVal: locationVal, completion: { (businesses: [Business]?, error: Error?) -> Void in
                    
                    self.businesses = businesses
                    self.tablesView.reloadData()
                    
                    if let businesses = businesses {
                        print("Total Found \(businesses.count)");
                    }
                    
                })
            } else{
                print("ERROR! Location value found nil")
                
            }
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        long = locValue.longitude;
        lat = locValue.latitude;
        
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // RETURNS NUMER OF ROWS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if businesses != nil{
            return businesses.count
        } else {
            return 0
        }
    }
    
    //RENDERS THE CELL
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablesView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    //SELECTED ROW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
        print(indexPath.row);
        indexOfSelectedDoctor = indexPath.row
        print("Selected val \(indexOfSelectedDoctor) \(businesses[indexOfSelectedDoctor].name as Any)");
    }
    
    
    //SEGUE
    @IBAction func sendDoctor(_ sender: Any) {
        selectedDoctor  = businesses[indexOfSelectedDoctor].name
        performSegue(withIdentifier: "selectedDoctorValue", sender: selectedDoctor)
        
    }
    
    //PREPARES THE SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedDoctorValue"{
            /*if let destination = segue.destination as? BookAppointmentController {
             destination.selectedDoctor  = businesses[indexOfSelectedDoctor].name
             }*/
            
            let tabBarC : UITabBarController = (segue.destination as? UITabBarController)!
            let desView: BookAppointmentController = tabBarC.viewControllers?.first as! BookAppointmentController
            
            desView.selectedDoctor = businesses[indexOfSelectedDoctor].name
            
        }
    }
    

    
}
