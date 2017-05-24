//
//  SettingViewController.swift
//  Count2Quit
//
//  Created by yisho on 4/22/17.
//  Copyright © 2017 yisho. All rights reserved.
//

import UIKit
import CoreData

class SettingViewController: UIViewController {

    @IBOutlet weak var brandForm: UITextField!
    @IBOutlet weak var priceForm: UITextField!
    
    @IBOutlet weak var currentBrand: UILabel!
    @IBOutlet weak var Price: UILabel!
    
    var brandContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmpty()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentBrand")
        let result = try? brandContext.fetch(fetchRequest)
        let resultData = result as! [CurrentBrand]
        currentBrand.text = resultData[0].brand
        Price.text = String(resultData[0].price)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func update(_ sender: UIButton) {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentBrand")
        let result = try? brandContext.fetch(fetchRequest)
        let resultData = result as! [CurrentBrand]
        
        resultData[0].brand = brandForm.text
        
        resultData[0].price = Double(priceForm.text!)!
        
        currentBrand.text = resultData[0].brand
        Price.text = String(resultData[0].price)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func checkEmpty(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentBrand")
        let result = try? brandContext.fetch(fetchRequest)
        let resultData = result as! [CurrentBrand]
        
        if(resultData.count == 0){
            let ent = NSEntityDescription.entity(forEntityName: "CurrentBrand", in: self.brandContext)
            let newItem = CurrentBrand(entity: ent!, insertInto: self.brandContext)
            newItem.brand = ""
            newItem.price = 0.0
            do {
                try self.brandContext.save()
                
            } catch _ {
            }
            
        }
        
    }
    
    

}
