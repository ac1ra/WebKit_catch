//
//  API_exchanges_VC.swift
//  WebKit_catch
//
//  Created by ac1ra on 09/10/2018.
//  Copyright © 2018 0I00II. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct item_user {
    let id_itm: Int
    let apiKey_itm:String
    let apiSecret_itm: String
    let exchangeId_itm: Int
    let exchangeName_itm: String
}

var items_api = [item_user]()

class API_exchanges_VC: UIViewController {

    var token = ""
    var token_type = ""
    var user_id = ""
    var refresh_token = ""
    
    public enum HTTPMethod: String{
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    @IBOutlet var tableView: UITableView!
    
    func alamofireGet(){
        
        let headers: HTTPHeaders = [
            "Authorization" : "\(self.token_type) \(self.token)",
            "Accept" : "application/json"
        ]
        
        Alamofire.request("http://82.202.246.197/api/v1.0/Exchanges/ForUser", headers: headers).validate().responseJSON { response in
            guard response.result.isSuccess else{
                print("Error for data response\(String(describing: response.result.error))")
                return
            }
            guard let arrayOfItems = response.result.value as? [[String:AnyObject]]
                else{
                    print("Cannot move to array")
                    return
            }
            
            print(response)
            
            for itm in arrayOfItems{
                let item = item_user(id_itm: itm["id"] as! Int, apiKey_itm: itm["apiKey"] as! String, apiSecret_itm: itm["apiSecret"] as! String, exchangeId_itm: itm["exchangeId"] as! Int, exchangeName_itm: itm["exchangeName"] as! String)
                
                items_api.append(item)
                items_api = items_api.sorted(by: {$0.id_itm < $1.id_itm})
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    func alamofireDel(){
        let headers: HTTPHeaders = [
            "Authorization" : "\(self.token_type) \(self.token)",
            "Accept" : "application/json"
        ]
        Alamofire.request("http://82.202.246.197/api/v1.0/Exchanges/ForUser", method: .delete, headers: headers).responseJSON{ response in
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        print("Token: \(token)")
        print("Token type: \(token_type)")
        print("User ID: \(user_id)")
        
        alamofireGet()
    }
}

class ItemCell_1: UITableViewCell{
    @IBOutlet var exchangeName: UILabel!
    @IBOutlet var apiKey: UILabel!
    @IBOutlet var apisecret: UILabel!
    
}
extension API_exchanges_VC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items_api.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemCell_1
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    private func configureCell(cell: ItemCell_1,for indexPath: IndexPath) {
        let item = items_api[indexPath.row]
        
        cell.exchangeName.text = "\(item.exchangeName_itm)"
        cell.apiKey.text = "\(item.apiKey_itm)"
        cell.apisecret.text = "\(item.apiSecret_itm)"
    }
}
