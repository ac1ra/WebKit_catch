//
//  GetInfoTableViewController.swift
//  WebKit_catch
//
//  Created by 0I00II on 14/09/2018.
//  Copyright © 2018 0I00II. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Item {
    let id: Int
    let title: String
}

var items = [Item]()

class GetInfoTableViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var token = ""
    var token_type = ""
    var user_id = ""
    var refresh_token = ""
    
    
    public enum HTTPMethod: String{
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    @IBOutlet var textID_del: UITextField!
    
    @IBAction func buttn_del(_ sender: UIButton) {
        let headers: HTTPHeaders = [
            "Authorization": "\(token_type) \(token)",
            "Accept": "application/json"
        ]
        let if_info = [
            "id" : textID_del.text!
        ]
        
        Alamofire.request("http://82.202.246.197/api/v1.0/Exchanges/Delete/{id}", method: .delete, parameters: if_info, headers: headers).validate().responseJSON{ response in
            
        }
        self.tableView.reloadData()
    }
    @IBAction func bttn_GetUser(_ sender: UIButton) {
        let headers: HTTPHeaders = [
            "Authorization": "\(token_type) \(token)",
            "Accept": "application/json"
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
//            for itm in arrayOfItems{
//                let item = Item(id: itm["id"] as! Int, title: itm["name"] as! String)
//                items.append(item)
//                items = items.sorted(by: {$0.id < $1.id})
//            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Token: \(token)")
        print("Token type: \(token_type)")
        print("User ID: \(user_id)")
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token_type) \(token)",
            "Accept": "application/json"
        ]
        Alamofire.request("http://82.202.246.197/api/v1.0/Exchanges/All", headers: headers).validate().responseJSON { response in
            guard response.result.isSuccess else{
                print("Error for data response\(String(describing: response.result.error))")
                return
            }
            guard let arrayOfItems = response.result.value as? [[String:AnyObject]]
                else{
                    print("Cannot move to array")
                    return
            }
            for itm in arrayOfItems{
                let item = Item(id: itm["id"] as! Int, title: itm["name"] as! String)
                items.append(item)
                items = items.sorted(by: {$0.id < $1.id})
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }

        
//        Alamofire.request("http://82.202.246.197/api/v1.0/Exchanges/all", headers: headers).responseJSON { (responseData)-> Void in
//            if((responseData.result.value) != nil){
//                let swiftJSON = JSON(responseData.result.value!)
//
//                if let resData = swiftJSON["success"].arrayObject{
//                    self.arrayDict = resData as! [[String:AnyObject]]
//                }
//                if self.arrayDict.count > 0{
//                    self.tableJSON.reloadData()
//                }
//
//            }
//            debugPrint(responseData)
//        }
//        Alamofire.request("http://82.202.246.197/api/v1.0/Exchanges/Create", method: .post, headers: headers)
//        Alamofire.request("http://82.202.246.197/api/v1.0/Exchanges/Delete/{id}", method: .delete, headers: headers)
    }
}
class ItemCell: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
}
extension GetInfoTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    private func configureCell(cell: ItemCell, for indexPath: IndexPath){
        let item = items[indexPath.row]
        
        
        
        cell.idLabel.text = "\(item.id)"
        cell.titleLabel.text = "\(item.title)"
    }
}
