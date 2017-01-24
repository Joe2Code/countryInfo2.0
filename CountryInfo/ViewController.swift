//
//  ViewController.swift
//  CountryInfo
//
//  Created by Joseph Mennemeier on 12/9/16.
//  Copyright © 2016 Joseph Mennemeier. All rights reserved.
//
// Rest API provided by Fayder Florez from https://github.com/fayder/restcountries
//

import UIKit
import Alamofire
import SwiftyJSON

// NOTE: Add search bar with filtering results

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
  
    // Variables for country data and for potential search bar updates
    var sortedCountryData = [Country]()
    var filteredSearchCountryData = [Country]()
    
    // IBOutlets for the ViewController
    @IBOutlet weak var nameLabel: RoundedCorner!
    @IBOutlet weak var tableViewforMainVC: UITableView!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var subRegionLabel: UILabel!
    @IBOutlet weak var callingCodeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    
    //  // URL of the JSON REST data
    let callURL = "https://restcountries.eu/rest/v1/all"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registering the tableView reuseIdentifier and calling the 3D touch functionality, delagate and data sources
        self.tableViewforMainVC.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableViewforMainVC.delegate = self
        self.tableViewforMainVC.dataSource = self
        
        // Setting the filtered results and JSON function calls
            // filteredNames = sortedCountryData as! [String]
            // searchBar.showsCancelButton = false
        // threeDActions()
        getAlamoJSON()

        // Completing the viewDidLoad by reloading the tableData
        self.tableViewforMainVC.reloadData()
    }
    
//  // Function for Alamofire and getting the JSON data ready
    func getAlamoJSON() {
        
        // Alamofire request with optional response, data, and result.
        Alamofire.request(callURL).responseJSON { response in
            
//            // Optional printing for troubleshooting the Alamofire request
//             print("Request: \(response.request)")
//             print("Response: \(response.response)")
//             print("Data: \(response.data)")
//             print("Result: \(response.result)")
            
            
            // Getting a value from the response result
            if let value = response.result.value {
                
                
                // Getting the actual JSON data itself
                let json = JSON(value)
                    // Optional printing for troubleshooting the JSON data
                    // print("JSON: \(json)")
                
                // Parsing out the JSON data from their respected arrays
                for item in json.array! {
                    let name = item["name"].stringValue
                    let capital = item["capital"].stringValue
                    let subregion = item["subregion"].stringValue
                    let callingCode = item["callingCodes"][0].stringValue
                    let timeZone = item["timezones"][0].stringValue
                    let currency = item["currencies"][0].stringValue
                    
                        // Optional printing for results of JSON names
                            // print(name)
                    
                    self.sortedCountryData.append(Country(name: name, capital: capital, subregion: subregion, callingCode: callingCode, timeZone: timeZone, currency: currency))
                    
                    self.tableViewforMainVC.reloadData()
                    self.nameLabel.text = "Please select a country"
                    }
            }
        }
    }
    
    // Creating the data of user default settings to be available for the user via a dynamic 3D touch action on the home screen
    func setUserDefault() {
        var callingCode = ""
        var currency = ""
        if let getCallingCode = UserDefaults.standard.object(forKey: "callingCode") {
            callingCode = getCallingCode as! String
        }
        if let getCurrency = UserDefaults.standard.object(forKey: "currency") {
            currency = getCurrency as! String
        }
        let localizedSubtitle = "Code: \(callingCode) Cur: \(currency)"
        if let getName = UserDefaults.standard.object(forKey: "name") as? String {
            print(getName)
            let shortcutType = "com.josephmennemeier.simpleCountry.saved"
            let shortcutItem = UIApplicationShortcutItem(type: shortcutType, localizedTitle: "\(getName)", localizedSubtitle: "\(localizedSubtitle)", icon: UIApplicationShortcutIcon(type: .bookmark)  , userInfo: nil)
            
            UIApplication.shared.shortcutItems = [shortcutItem]
        }
    }
    
    // Saving the country name, calling code, and currency of the country as UserDefaults setting to be called for a dynamic 3D home screen action, presented by the function setUserDefault() in viewWillAppear
    func savedUserDefault() {
        
        // Declaring the constants for the storage
        let nameUserSetting = savedName
        let callingCodeUserSetting = savedCallingCode
        let currencyUserSetting = savedCurrency
        
        // Saving the information to the persistent storage
        UserDefaults.standard.set(nameUserSetting, forKey: "name")
        UserDefaults.standard.set(callingCodeUserSetting, forKey: "callingCode")
        UserDefaults.standard.set(currencyUserSetting, forKey: "currency")
        
        print("Saved country is \(nameUserSetting) with a calling code of \(callingCodeUserSetting) and currency of \(currencyUserSetting)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUserDefault()
    }
    
    // Calling the number of sections in the TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Getting the number of rows for the tableView according to the number of countries
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedCountryData.count
        
        // Furture potential update for search bar
//            if searchBar.text != "" {
//                    return filteredSearchCountryData.count
//                } else {
//                    return sortedCountryData.count
//                }
    }
    
    // Getting the cells in each row with the correct country names
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableViewforMainVC.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
       
        cell.textLabel?.text = sortedCountryData[indexPath.row].name
//         if searchBar.text != "" {
//            cell.textLabel?.text = filteredSearchCountryData[indexPath.row].name
//        } else {
//            cell.textLabel?.text = sortedCountryData[indexPath.row].name
//        }
        return cell
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        tableViewforMainVC.reloadData()
//    }
    
    // Effects of selecting the row at their indexPath, changing the labels as a result
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameLabel.text = sortedCountryData[indexPath.row].name
        capitalLabel.text = sortedCountryData[indexPath.row].capital
        subRegionLabel.text = "Country in \(sortedCountryData[indexPath.row].subregion)"
        callingCodeLabel.text = "Calling Code: \(sortedCountryData[indexPath.row].callingCode)"
        timeZoneLabel.text = "Main Time Zone: \(sortedCountryData[indexPath.row].timeZone)"
        currencyLabel.text = "Currency Type: \(sortedCountryData[indexPath.row].currency)"
        
        savedName = sortedCountryData[indexPath.row].name
        savedCallingCode = sortedCountryData[indexPath.row].callingCode
        savedCurrency = sortedCountryData[indexPath.row].currency
        
        print("You tapped cell number \(indexPath.row)")
        print("Newest entry is \(savedName), with a calling code of \(savedCallingCode) and currency of \(savedCurrency)")
        
        savedUserDefault()
        setUserDefault()
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
