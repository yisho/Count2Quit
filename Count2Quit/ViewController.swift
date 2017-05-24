//
//  ViewController.swift
//  Count2Quit
//
//  Created by yisho on 3/20/17.
//  Copyright © 2017 yisho. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    var masterRecList: record = record()
    
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var smokedAT: UILabel!
    @IBOutlet weak var urgesAT: UILabel!
    @IBOutlet weak var spentAT: UILabel!
    @IBOutlet weak var dateForm: UITextField!
    
    
    let smokeContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchResults = [SmokeEntity]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher()
        checkEmpty()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if(segue.identifier == "detailSegue"){
            let selectedIndex: IndexPath = self.dateTableView.indexPath(for: sender as! UITableViewCell)!
            
            
            if let detailviewController: DetailedViewController = segue.destination as? DetailedViewController
            {
    
                detailviewController.recIndex = selectedIndex.row
                detailviewController.detailedContext = smokeContext
            }
        }
        if(segue.identifier == "settingSegue"){
            if let settingviewController: SettingViewController = segue.destination as? SettingViewController{
                settingviewController.brandContext = smokeContext
            }
        }
    }
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        var x   = 0
        // Execute the fetch request, and cast the results to an array of LogItem objects
        fetchResults = ((try? smokeContext.fetch(fetchRequest)) as? [SmokeEntity])!
        
        
        x = fetchResults.count
        
        print(x)
        
        return x
        
    }
    
  
    
    @IBAction func addRecord(_ sender: UIBarButtonItem) {
        let ent = NSEntityDescription.entity(forEntityName: "SmokeEntity", in: self.smokeContext)
        let newItem = SmokeEntity(entity: ent!, insertInto: self.smokeContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentBrand")
        let result = try? smokeContext.fetch(fetchRequest)
        let resultData = result as! [CurrentBrand]
        
        
        newItem.date = dateForm.text!
        newItem.brand = resultData[0].brand
        newItem.price = resultData[0].price
        
        do {
            try self.smokeContext.save()
        
        } catch _ {
        }
        
        dateTableView.reloadData()
        print(newItem)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.borderWidth = 1.0
        cell.textLabel?.text = fetchResults[indexPath.row].date
        if (fetchResults[indexPath.row].pic != nil)
        {
            cell.imageView?.image = UIImage(data: fetchResults[indexPath.row].pic! as Data)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
            let result = try? smokeContext.fetch(fetchRequest)
            let resultData = result as! [SmokeEntity]
            
            smokeContext.delete(resultData[indexPath.row])
            
            do {
                try smokeContext.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        dateTableView.reloadData()
    }
    
    @IBAction func Refresh(_ sender: UIButton) {
        refresher()
    }
    
    func refresher(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? smokeContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        
        var totalSP = 0.0
        var totalU = 0
        var totalS = 0
        
        for object in resultData {
            totalSP += Double(object.totalPrice)
            totalU += Int(object.totalUrges)
            totalS += Int(object.totalSmoked)
        }
        
        
        smokedAT.text = String(totalS)
        
        urgesAT.text = String(totalU)
        
        spentAT.text = String(format: "%.02", totalSP)
        
        dateTableView.reloadData()
        
    }
    
    @IBAction func Tips(_ sender: UIButton) {
        
        UIApplication.shared.openURL(URL(string: "https://quitday.org/quit-smoking/quit-smoking-tips/")!)
    }
    
    func checkEmpty(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentBrand")
        let result = try? smokeContext.fetch(fetchRequest)
        let resultData = result as! [CurrentBrand]
        
        if(resultData.count == 0){
            let ent = NSEntityDescription.entity(forEntityName: "CurrentBrand", in: self.smokeContext)
            let newItem = CurrentBrand(entity: ent!, insertInto: self.smokeContext)
            newItem.brand = ""
            newItem.price = 0.0
            do {
                try self.smokeContext.save()
                
            } catch _ {
            }
            
        }
        
    }
    
}

