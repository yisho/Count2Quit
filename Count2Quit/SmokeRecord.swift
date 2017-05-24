//
//  SmokeRecord.swift
//  Count2Quit
//
//  Created by yisho on 3/20/17.
//  Copyright © 2017 yisho. All rights reserved.
//

import Foundation

class record {
    var rec:[smokeRecord] = []
    
    init() {
        
    let tempcellRecord: smokeRecord = smokeRecord(b: "CamelRed", p: 10.00, ts: 0, tu: 0, tp: 0, d: "3-20-2017")
    rec.append(tempcellRecord)
        
    }
    
    internal func remove(index: Int){
        rec.remove(at: index)
    }
}

class smokeRecord {
    
    var brand = ""
    var price: Double = 0
    var totalSmoked = 0
    var totalUrges = 0
    var totalPrice: Double = 0
    var date: String = ""
    
    
    init(b: String, p: Double, ts: Int, tu: Int, tp: Double, d: String ){
        brand = b
        price = p
        totalSmoked = ts
        totalUrges = tu
        totalPrice = tp
        date = d
    }
    
    internal func getBrand() -> String{
        return brand
    }
    
    internal func getPriceofPack() -> Double{
        return price
    }
    
    internal func getPriceofStick() -> Double{
        return price/20
    }
    
    internal func gettotalSmoke() -> Int{
        return totalSmoked
    }
    
    internal func gettotalUrges() -> Int{
        return totalUrges
    }
    
    internal func gettotalPrice() -> Double{
        return totalPrice
    }
    
    internal func getDate() -> String{
        return date
    }
    
    
}
