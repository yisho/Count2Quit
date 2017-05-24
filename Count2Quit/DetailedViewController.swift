//
//  DetailedViewController.swift
//  Count2Quit
//
//  Created by yisho on 3/20/17.
//  Copyright © 2017 yisho. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class DetailedViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var smokedCount: UILabel!
    @IBOutlet weak var urgesCount: UILabel!
    @IBOutlet weak var moneyCount: UILabel!
    @IBOutlet weak var currentBrand: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagePicked: UIImageView!
    
    
    var mainView: ViewController = ViewController()
    var manager:CLLocationManager!
    var detailedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let picker = UIImagePickerController()
    
    
    var recIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshMap()
        
        picker.delegate = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        
        smokedCount.text = String(resultData[recIndex].totalSmoked)
        
        urgesCount.text = String(resultData[recIndex].totalUrges)
        
        moneyCount.text = String(describing: resultData[recIndex].totalPrice)
        
        currentBrand.text = resultData[recIndex].brand
        if (resultData[recIndex].pic != nil)
        {
            imagePicked.image = UIImage(data: resultData[recIndex].pic! as Data)
        }
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStick(price:Double) -> Double{
        return price/20
    }
    
    @IBAction func plusCig(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        resultData[recIndex].totalSmoked+=1
        let stickPrice = getStick(price: resultData[recIndex].price)
        resultData[recIndex].totalPrice = resultData[recIndex].totalPrice + stickPrice
        
        smokedCount.text = String(resultData[recIndex].totalSmoked)
        
        moneyCount.text = String(resultData[recIndex].totalPrice)
        
        manager.startUpdatingLocation()
      
        
        do {
            try self.detailedContext.save()
            
        } catch _ {
        }
        manager.stopUpdatingLocation()
        
    }
    
    @IBAction func cigMinus(_ sender: UIButton) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        resultData[recIndex].totalSmoked-=1
        let stickPrice = getStick(price: resultData[recIndex].price)
        resultData[recIndex].totalPrice = resultData[recIndex].totalPrice - stickPrice
        
        
        smokedCount.text = String(resultData[recIndex].totalSmoked)
        
        moneyCount.text = String(resultData[recIndex].totalPrice)
        
        do {
            try self.detailedContext.save()
            
        } catch _ {
        }
        
    }
    
    @IBAction func urgesPlus(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        
        resultData[recIndex].totalUrges+=1
        
        urgesCount.text = String(resultData[recIndex].totalUrges)
        
        do {
            try self.detailedContext.save()
            
        } catch _ {
        }
        
    }

    @IBAction func urgesMinus(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        
        resultData[recIndex].totalUrges-=1
        
        urgesCount.text = String(resultData[recIndex].totalUrges)
        
        do {
            try self.detailedContext.save()
            
        } catch _ {
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        
        //userLocation - there is no need for casting, because we are now using CLLocation object
        
        let userLocation:CLLocation = locations[0]
        
        resultData[recIndex].lat = userLocation.coordinate.latitude
        
        resultData[recIndex].long = userLocation.coordinate.longitude
        
        refreshMap()
        
        
    }
    
    func refreshMap(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        
        let lon : CLLocationDegrees = resultData[recIndex].long
        
        let lat : CLLocationDegrees = resultData[recIndex].lat
        
        
        let coordinates = CLLocationCoordinate2D( latitude: lat, longitude: lon)
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        print(coordinates)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinates, span)
        
        self.mapView.setRegion(region, animated: true)
        
        // add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "Smoked Here"
        annotation.subtitle = "Last"
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func addPic(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            print("No camera")
        }
        
        
    }
    
    //Corrects orientation of image
    func normalizedImage(img: UIImage) -> UIImage {
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        imagePicked.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SmokeEntity")
        let result = try? detailedContext.fetch(fetchRequest)
        let resultData = result as! [SmokeEntity]
        
        
        let imageData = UIImagePNGRepresentation(normalizedImage(img: imagePicked.image!))
        resultData[recIndex].pic = imageData! as NSData
        
        do {
            try detailedContext.save()
        } catch _ {
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
