//
//  ViewController.swift
//  daa
//
//  Created by brian lipscomb on 12/4/17.
//  Copyright © 2017 codewithlips. All rights reserved.
// help Rec'd: https://www.youtube.com/watch?v=UyiuX8jULF4, recieved help from sources on: https://stackoverflow.com/

import UIKit
import MapKit
import WebKit
import CoreLocation


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate,   MKMapViewDelegate{
    @IBOutlet weak var nearView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var nearLabel: UILabel!
    @IBOutlet weak var settingNearLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var buttonGroup: UIStackView!
    @IBOutlet weak var startInput: UITextField!
    @IBOutlet weak var destinationInput: UITextField!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var newMenu: UIView!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissWelcomeButton: UIButton!
    @IBOutlet weak var removeDirections: UIButton!
    @IBOutlet var BuildDesc: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var boxHeight: NSLayoutConstraint!
    @IBOutlet weak var menu: UIScrollView!
    @IBOutlet weak var locationInfoLabel: UILabel!
    @IBOutlet weak var ToggleLabel: UIButton!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var textBox: UILabel!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var searchBar1: UISearchBar!
    @IBOutlet weak var alt: UILabel!
    @IBOutlet weak var lo: UILabel!
    @IBOutlet weak var la: UILabel!
    @IBOutlet weak var nearestLabel: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet var welcomeView: UIView!
    @IBOutlet weak var nearImage: UIImageView!
    @IBOutlet weak var menuViewImage: UIImageView!
    @IBOutlet weak var menuViewLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var pageViewController: UIPageViewController?
    var imagePickerController: UIImagePickerController!
    var cameraImage: UIImage!
    var thisBuilding: String!
    var BuildingWrong = false
    var directionsEnabled = false
    var count : Int!
    var sort: [String]!
    var isSlideMenuHidden = true
    var editButton = [UIButton]()
    var dismiss: Bool = false
    var newBuilding: String!
    var updatelocation: CLLocationCoordinate2D!
    var effect:UIVisualEffect!
    var isAnimating: Bool = false
    var buildingArray = [Building]()
    var currentBuilding = [Building]() //update search table
    var departmentArray:[String:String]!
    var myIndex = 0
    
    private var lpgr:UILongPressGestureRecognizer!
    
    let locationManager = CLLocationManager()
    let URL_KEYDET = "http://localhost:8888/KeydetGo/index.php"
    
   

    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
     
        mapView.mapType = .satellite
        
        viewSytles()
 
        let test = CLLocationCoordinate2D(latitude: 37.790486058045758, longitude: -79.438132043746407)
        let startRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(test , 600, 600)
        mapView.setRegion(startRegion, animated: true)
        setUpBuildings()
        setUpSearchBar()
        alterLayout()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            animateIn(View: welcomeView)
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }

      
        mapView.delegate = self
        
        let nearGesture = UITapGestureRecognizer(target: self, action: #selector(self.nearHandleTap(gestureRecognizer:)))
         nearGesture.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.2
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        
        
        
        startInput.delegate = self
        destinationInput.delegate = self
        

      
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.addGestureRecognizer(lpgr)
        
        nearView.addGestureRecognizer(nearGesture)
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate=self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
           
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
  
        let location = locations[0]
        let span = 2.0 * 250
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation, span, span)
        
        let sourceCoordinates = locationManager.location?.coordinate
        updatelocation = sourceCoordinates!

        
        mapView.setRegion(region, animated: true)
       
        self.mapView.showsUserLocation = true
        mapView.showsBuildings = true
        
        
        
        let longitude = location.coordinate.longitude
        let lattitude = location.coordinate.latitude
        
     
        findNear(longy: longitude,latty: lattitude)
        
            
        
    
        let x = Double(round(100000 * location.coordinate.latitude)/100000)
        let y = Double(round(100000 * location.coordinate.longitude)/100000)
       
    
        self.la.text = String(x) + ", " + String(y)
        
        
        
       
        
        labelUnderline(label: self.lo)
        labelUnderline(label: self.alt)
        labelUnderline(label: self.nearestLabel)
        labelTopBorder(label: self.locationInfoLabel)
        labelUnderlineBold(label: self.locationInfoLabel)

        let alt = locations[0].altitude
        self.altLabel.text =  String(alt)

    }
    
    func labelUnderline(label: UILabel!){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: label.frame.size.height - width, width:label.frame.size.width, height: label.frame.size.height)
        border.borderWidth = width
        label.layer.addSublayer(border)
        label.layer.masksToBounds = true
        
    }
    
    func labelUnderlineBold(label: UILabel!){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: label.frame.size.height - width, width:label.frame.size.width, height: label.frame.size.height)
        border.borderWidth = width
        label.layer.addSublayer(border)
        label.layer.masksToBounds = true
        
    }
    
    func labelTopBorder(label: UILabel!){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: 0, width:label.frame.size.width, height: 2)
        border.borderWidth = width
        label.layer.addSublayer(border)
        label.layer.masksToBounds = true
        
    }
    
    func labelTop(view: UIView!){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: 0, width:view.frame.size.width, height: 2)
        border.borderWidth = width
        view.layer.addSublayer(border)
        view.layer.masksToBounds = true
    }
    func viewBorder(view: UIView!){
         let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: 0, width:view.frame.size.width, height: 2)
        border.borderWidth = width
        view.layer.addSublayer(border)
        view.layer.masksToBounds = true
        
        let border1 = CALayer()
        let width1 = CGFloat(2.0)
        border1.borderColor = UIColor.lightGray.cgColor
        border1.frame = CGRect(x: 0, y: view.frame.size.height - width1, width:view.frame.size.width, height: view.frame.size.height)
        border1.borderWidth = width1
        view.layer.addSublayer(border1)
        view.layer.masksToBounds = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField)
        if textField == startInput{
            textField.resignFirstResponder()
            
            destinationInput.becomeFirstResponder()
            
            let xPosition = settingView.frame.origin.x
            let yPosition = settingView.frame.origin.y - 50
  
            UIView.animate(withDuration: 0.5, animations: {
                self.settingView.frame.origin = CGPoint(x: xPosition, y: yPosition)
            })
        }else if textField == destinationInput{
            textField.resignFirstResponder()
            let xPosition = settingView.frame.origin.x
            let yPosition = settingView.frame.origin.y + 50
            UIView.animate(withDuration: 0.5, animations: {
                self.settingView.frame.origin = CGPoint(x: xPosition, y: yPosition)
            })
            
        }
        return true
    
    }
    
    
    func startFromDirections(){
        
        
        mapView.removeOverlays(mapView.overlays)
        if(BuildingWrong == false){
    
        let SourceCoordinates =  blah(building: startInput.text!)
        let destCoordinates = blah(building:destinationInput.text!)
 
        let sourcePlacemark = MKPlacemark(coordinate:  SourceCoordinates)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else {
                if error != nil {
                    print("Something went wrong" )
                }
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.add(route.polyline, level: .aboveRoads)
            
         
    })
            
            let camera = MKMapCamera()
            camera.centerCoordinate = SourceCoordinates
            camera.pitch = 80.0
            camera.altitude = 80.0
            camera.heading = 45.0
            mapView.setCamera(camera, animated: true )
        }
            
        
        else {
            print("Did not enter correct building" )
        }

        
}
    struct GlobalVariable{
        static var myStruct = String()
    }
    
    @IBAction func directionPressed(_ sender: Any) {
        directionsEnabled = true
        removeDirections.isHidden = false
        mapView.removeOverlays(mapView.overlays)

        let destCoordinates = blah(building: newBuilding)
        
        let sourcePlacemark = MKPlacemark(coordinate: updatelocation)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
    
        let annotation = MKPointAnnotation()
    
        
        annotation.coordinate = destCoordinates
        annotation.title = newBuilding
        annotation.subtitle = newBuilding
        mapView.addAnnotation(annotation)
        
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
    
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else {
                if error != nil {
                    print("Something went wrong" )
                }
                return
            }
            
            let route = response.routes[0]
         
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        })
        
            
        
        searchView.isHidden = false
        buttonGroup.isHidden = false
        locateButton.isHidden = false
        

        
    }
    
    @IBAction func removeAnn(){
        if(directionsEnabled == true){
            mapView.removeOverlays(mapView.overlays)
            removeDirections.isHidden = true
        }
    
    }
    
   

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        //renderer.strokeColor = UIColor(red: 0.2824, green: 0.5255, blue: 0.949, alpha: 1.0)
        renderer.strokeColor = UIColor.blue.withAlphaComponent(0.7) // 1.0 alpha
        renderer.fillColor   = UIColor.red.withAlphaComponent(0.2)

        renderer.lineWidth = 10.0
        
        return renderer
    }
    

    

    
    func findNear(longy: CLLocationDegrees, latty: CLLocationDegrees){
        isNear(longitude: longy, lattitude: latty, lat1: 37.789610, lat2: 37.789091, long1:-79.438185, long2:-79.437584 , building: "Mallory Hall")
        isNear(longitude: longy, lattitude: latty, lat1: 37.789300, lat2: 37.789067, long1:-79.438973, long2:-79.438260, building: "Maury Brooke")//Maury Brook
        isNear(longitude: longy, lattitude: latty, lat1: 37.789736, lat2: 37.789232, long1:-79.437358, long2:-79.436832 , building: "Preston")// Preston Library
        isNear(longitude: longy, lattitude: latty, lat1: 37.789935, lat2: 37.789403, long1:-79.436495, long2:-79.436039 , building: "Nichols")//Nichols Engineering
        isNear(longitude: longy, lattitude: latty, lat1: 37.790132, lat2: 37.789752, long1:-79.435931, long2:-79.435570 , building: "JM Hall")//JM Hall
        isNear(longitude: longy, lattitude: latty, lat1: 37.789207, lat2: 37.788549, long1:-79.435991, long2:-79.433979, building: "Foster Stadium")//Foster Stadium
        isNear(longitude: longy, lattitude: latty, lat1:37.790093, lat2: 37.789604, long1:-79.435550, long2:-79.434709 , building: "Cocke Hall")//Cocke Hall
        isNear(longitude: longy, lattitude: latty, lat1:37.790664, lat2: 37.790562, long1:-79.434744, long2: -79.434336 , building: "Shell Hall")//Nichols Engineering
        isNear(longitude: longy, lattitude: latty, lat1:37.790770, lat2: 37.790587, long1:-79.434320, long2:-79.433859 , building: "Carroll Hall")//Carrol Hall
        isNear(longitude: longy, lattitude: latty, lat1:37.790503, lat2: 37.790274, long1: -79.433585, long2:-79.432469 , building: "Crozet Hall")//Crozet Hall
        isNear(longitude: longy, lattitude: latty, lat1:37.790579, lat2: 37.790253, long1:-79.432314, long2:-79.431944 , building: "Post Hospital")//Carrol Hall
        isNear(longitude: longy, lattitude: latty, lat1:37.789617, lat2:37.789138, long1:-79.433923, long2:-79.432094 , building: "Kilbourne Hall")//Carrol Hall
        isNear(longitude: longy, lattitude: latty, lat1:37.789354, lat2:37.788970, long1:-79.431895, long2:-79.430877 , building: "Cormack Hall")//Cormack Hall
        isNear(longitude: longy, lattitude: latty, lat1:37.788701, lat2:37.788413, long1:-79.437276, long2:-79.436063 , building: "Cameron Hall")//Cameron Hall
        isNear(longitude: longy, lattitude: latty, lat1:37.788137, lat2:37.787802, long1:-79.438799, long2:-79.436959, building: "CPT ")//Corps Physical Training Facility
        isNear(longitude: longy, lattitude: latty, lat1:37.789799, lat2:37.789301, long1:-79.441072, long2:-79.440324, building: "CLE")//The Center for Leadership and Ethics
        
        // Barracks
        isNear(longitude: longy, lattitude: latty, lat1:37.791008, lat2:37.790266, long1:-79.435794, long2:-79.434925, building: "Old Barracks")//Old barracks
        isNear(longitude: longy, lattitude: latty, lat1:37.791294, lat2:37.791184, long1:-79.436459, long2:-79.435563, building: "New Barracks")//New Barracks
        isNear(longitude: longy, lattitude: latty, lat1:37.791753, lat2:37.791321, long1:-79.437167, long2:-79.436389, building: "Third Barracks")//Third Barracks
        
        isNear(longitude: longy, lattitude: latty, lat1:37.790321, lat2:37.790664, long1:-79.437536, long2:-79.438963, building: "Parade Field")//parade Field
        isNear(longitude: longy, lattitude: latty, lat1:37.790381, lat2:37.790186, long1:-79.434646, long2:-79.433932, building: "Scott Shipp Hall")//Scott shipp
        
    }

    
    func findBuilding(longy: CLLocationDegrees, latty: CLLocationDegrees){

        
         buildingLocation(longitude: longy, lattitude: latty, lat1: 37.789610, lat2: 37.789091, long1:-79.438185, long2:-79.437584 , building: "Mallory Hall")//Mallory Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1: 37.789300, lat2: 37.789067, long1:-79.438973, long2:-79.438260, building: "Maury Brooke")//Maury Brook
         buildingLocation(longitude: longy, lattitude: latty, lat1: 37.789736, lat2: 37.789232, long1:-79.437358, long2:-79.436832 , building: "Preston")// Preston Library
         buildingLocation(longitude: longy, lattitude: latty, lat1: 37.789935, lat2: 37.789403, long1:-79.436495, long2:-79.436039 , building: "Nichols")//Nichols Engineering
         buildingLocation(longitude: longy, lattitude: latty, lat1: 37.790132, lat2: 37.789752, long1:-79.435931, long2:-79.435570 , building: "JM Hall")//JM Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1: 37.789207, lat2: 37.788549, long1:-79.435991, long2:-79.433979, building: "Foster Stadium")//Foster Stadium
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.790093, lat2: 37.789604, long1:-79.435550, long2:-79.434709 , building: "Cocke Hall")//Cocke Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.790664, lat2: 37.790562, long1:-79.434744, long2: -79.434336 , building: "Shell Hall")//Nichols Engineering
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.790770, lat2: 37.790587, long1:-79.434320, long2:-79.433859 , building: "Carroll Hall")//Carrol Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.790503, lat2: 37.790274, long1: -79.433585, long2:-79.432469 , building: "Crozet Hall")//Crozet Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.790579, lat2: 37.790253, long1:-79.432314, long2:-79.431944 , building: "Post Hospital ")//Carrol Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.789617, lat2:37.789138, long1:-79.433923, long2:-79.432094 , building: "Kilbourne Hall")//Carrol Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.789354, lat2:37.788970, long1:-79.431895, long2:-79.430877 , building: "Cormack")//Cormack Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.788701, lat2:37.788413, long1:-79.437276, long2:-79.436063 , building: "Cameron Hall")//Cameron Hall
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.788137, lat2:37.787802, long1:-79.438799, long2:-79.436959, building: "CPT")//Corps Physical Training Facility
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.789799, lat2:37.789301, long1:-79.441072, long2:-79.440324, building: "CLE")//The Center for Leadership and Ethics
        
         // Barracks
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.791008, lat2:37.790266, long1:-79.435794, long2:-79.434925, building: "Old Barracks")//Old barracks
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.791294, lat2:37.791184, long1:-79.436459, long2:-79.435563, building: "New Barracks")//New Barracks
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.791753, lat2:37.791321, long1:-79.437167, long2:-79.436389, building: "Third Barracks")//Third Barracks
        
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.790629, lat2:37.790316, long1:-79.439668, long2:-79.436224, building: "Parade Field")//parade Field
         buildingLocation(longitude: longy, lattitude: latty, lat1:37.790381, lat2:37.790186, long1:-79.434646, long2:-79.433932, building: "Scott Shipp Hall")//Scott shipp

    }
    

    

    func buildingLocation(longitude: CLLocationDegrees, lattitude: CLLocationDegrees, lat1: Double ,  lat2: Double,  long1: Double,  long2:Double, building: String){

        
            if(lattitude <= lat1 && lattitude >= lat2 && longitude >= long1 && longitude <= long2){
                menuViewImage.image = UIImage(named:building)
                textBox.text = building.localized
                menuViewLabel.text = building
                animateIn(View: BuildDesc)
                newBuilding = building
                lpgr.isEnabled = !lpgr.isEnabled
                searchView.isHidden = true
                buttonGroup.isHidden = true
                locateButton.isHidden = true
                department(building: building)
                thisBuilding = building
                GlobalVariable.myStruct = thisBuilding
                

             
            }
            else{
            print("no building")
        }
    }
    
    func isNear(longitude: CLLocationDegrees, lattitude: CLLocationDegrees, lat1: Double ,  lat2: Double,  long1: Double,  long2:Double, building: String){
        if(lattitude <= lat1 && lattitude >= lat2 && longitude >= long1 && longitude <= long2){
            nearView.isHidden = false;
            nearLabel.text = " you are near " + building;
            settingNearLabel.text = building;
            nearImage.image = UIImage(named: building);
            
    }
        
    }
    
    

    
 
    
    
    @IBAction func CurrentLocationUpdate(_ sender: Any) {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        switch mapView.mapType{
        case .satellite:
            mapView.mapType = .satelliteFlyover
        case .hybrid:
            mapView.mapType = .hybridFlyover
        case .standard:
            mapView.mapType = .standard
            
        default:
            break
            
        }
        
        locationManager.startUpdatingLocation()

    }
    
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer){
   
        UITableView.animate(withDuration: 0.2, animations: {
            self.searchTable.frame.size.height = 0;
        })
        animateSearch()
        animateButtons()
        dismissSettings()
        
    
        locationManager.stopUpdatingLocation()
        searchBar1.endEditing(true)
      
    }
    @objc func nearHandleTap(gestureRecognizer: UILongPressGestureRecognizer){
            findBuilding(longy: updatelocation.longitude, latty: updatelocation.latitude)
        nearView.isHidden = true
        
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){

        
        
        let touchPoint: CGPoint = gestureRecognizer.location(in: mapView)
        let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let latty = newCoordinate.latitude
        let longy = newCoordinate.longitude
        
       
        
        
        findBuilding(longy: longy, latty: latty)
        
        
        animateSearch()
        animateButtons()
       
    }
    

    func department(building: String){
        if building == "Mallory Hall"{
            departmentArray = ["Computer and Information Science": "CIS".localized, "Physics": "Physics".localized, "Applied Math": "Applied".localized]
            buildingInfo(building: building , build:departmentArray)
        }
       else if building == "Preston"{
            departmentArray = ["Library": "Lib".localized]
            buildingInfo(building: building , build:departmentArray)
           
        }
            
        else if (building == "Maury Brooke" ){
            departmentArray = ["Biology": "Biology".localized, "Chemistry": "Chemistry".localized]
            buildingInfo(building: building , build:departmentArray)
        }
       
        else if (building == "Corps Physical Training Facility" || building == "CPT"){
            departmentArray = ["Track and Field": "Track".localized]
            buildingInfo(building: building , build:departmentArray)
        }
        else if (building == "Nichols" ){
            departmentArray = ["Civil Engineering": "Civil".localized, "Electrical and Computer Engineering" : "EE".localized, "Mechanical Engineering" : "Mech".localized]
            buildingInfo(building: building , build:departmentArray)
            
        }
        else if (building == "JM Hall" || building == "JM hall" || building == "Church"){
            departmentArray = ["The Church": "church".localized, "VMI Museuem" : "Muse".localized]
            buildingInfo(building: building , build:departmentArray)
            
        }
        else if (building == "Old Barracks" ){
           departmentArray = nil
            
        }
        else if (building == "New Barracks" ){
            departmentArray = nil
        }
        else if (building == "Third Barracks" ){
          departmentArray = nil
        }
        else if (building == "Cocke Hall" ){
            departmentArray = ["Physical Education": "PE".localized]
            buildingInfo(building: building , build:departmentArray)
            
        }
        else if (building == "Scott Shipp Hall" ){
            departmentArray = ["History" : "History".localized, "Modern Languages and Cultures": "Lang".localized,
                               "English, Rhetoric, and Humanistic Studies": "English".localized, "Economics and Business": "Econ".localized,
                               "International Studies and Political Science": "IS".localized ]
            buildingInfo(building: building , build:departmentArray)
            
        }
        else if (building == "Shell Hall" ){
            departmentArray = ["Registrar Office": "Registrar".localized, "VMI Regimental Band" : "Band".localized, "Auxilary Services" : "Auxilary".localized]
            buildingInfo(building: building , build:departmentArray)
            
        }
        else if (building == "Foster Stadium"  ){
            departmentArray = ["VMI Football": "Football".localized]
            buildingInfo(building: building , build:departmentArray)
            
        }
        else if (building == "Crozet Hall" || building == "Dining Hall".lowercased() || building == "Food" || building == "Dining" ){
           
            
        }
        else if (building == "Kilbourne Hall"  ){
            departmentArray = ["Air Force ROTC": "air".localized, "Navy ROTC" : "navy".localized, "Army ROTC": "Army".localized]
            buildingInfo(building: building , build:departmentArray)
        }
        else if (building == "Cormack Hall"  ){
            departmentArray = ["Physical Education": "PE".localized]
            buildingInfo(building: building , build:departmentArray)

        }
            
        else if (building == "Post Hospital"  ){
            
        }
            
        else if (building == "Carroll Hall"  ){
            departmentArray = ["Psychology": "Psych".localized]
            buildingInfo(building: building , build:departmentArray)

        }
            
        else if (building == "Cameron Hall"  ){
            departmentArray = ["VMI Basketball": "Basketball".localized]
            buildingInfo(building: building , build:departmentArray)
        }
        else{
            
            departmentArray = ["VMI": "VMI"]
            buildingInfo(building: building , build:departmentArray)
        }
        
    }
    
    func  blah(building: String)-> CLLocationCoordinate2D{
  
        
        if building == "Preston"{
           
            return CLLocationCoordinate2D(latitude:37.789716, longitude: -79.437137)
        
        }

        else if (building == "Maury Brooke" ){
            return CLLocationCoordinate2D(latitude: 37.78912509706754, longitude: -79.438526933928983)
        }
        else if (building == "Mallory Hall" ){
          
            return CLLocationCoordinate2D(latitude: 37.789372152379642, longitude: -79.43784136086272)
            
        }
        else if (building == "Corps Physical Training Facility" || building == "CPT"){
            return CLLocationCoordinate2D(latitude: 37.787889808116972, longitude: -79.437890722135521)
        }
        else if (building == "Nichols" ){
            return CLLocationCoordinate2D(latitude: 37.789705892322374, longitude: -79.436311161405399)
            
        }
        else if (building == "JM Hall" || building == "JM hall" || building == "Church"){
            return CLLocationCoordinate2D(latitude: 37.789775240852478, longitude: -79.435647526347964)
            
        }
        else if (building == "Old Barracks" ){
            return CLLocationCoordinate2D(latitude: 37.790798122028718, longitude: -79.435323935949)
            
        }
        else if (building == "New Barracks" ){
            return CLLocationCoordinate2D(latitude: 37.791141088969241, longitude: -79.436133369497497)
            
        }
        else if (building == "Third Barracks" ){
           return CLLocationCoordinate2D(latitude: 37.791125747328479, longitude: -79.436839539980724)
            
        }
        else if (building == "Cocke Hall" ){
            return CLLocationCoordinate2D(latitude: 37.790178193751046, longitude: -79.435171473026344)
            
        }
        else if (building == "Scott Shipp Hall" ){
            return CLLocationCoordinate2D(latitude: 37.79039813589155, longitude: -79.434548359398576)
            
        }
        else if (building == "Shell Hall" ){
            return CLLocationCoordinate2D(latitude: 37.790537046388366, longitude: -79.434543852213054)
            
        }
        else if (building == "Foster Stadium"  ){
            return CLLocationCoordinate2D(latitude: 37.789566539090814, longitude: -79.434088401779761)
            
        }
        else if (building == "Crozet Hall" || building == "Dining Hall".lowercased() || building == "Food" || building == "Dining" ){
            return CLLocationCoordinate2D(latitude: 37.790290391045048, longitude: -79.433584955791105)
            
        }
        else if (building == "Kilbourne Hall"  ){
            return CLLocationCoordinate2D(latitude: 37.78963154287095, longitude: -79.433591488366758)
        }
        else if (building == "Cormack Hall"  ){
            return CLLocationCoordinate2D(latitude: 37.789340361230458, longitude: -79.431424675456711)
        }
            
        else if (building == "Post Hospital"  ){
            return CLLocationCoordinate2D(latitude: 37.79059435082101, longitude: -79.432188331777553)
        }
            
        else if (building == "Carroll Hall"  ){
            return CLLocationCoordinate2D(latitude: 37.7905769712021, longitude: -79.434091123351791)
        }
            
        else if (building == "Cameron Hall"  ){
       
            return CLLocationCoordinate2D(latitude: 37.788810460754661, longitude: -79.436790193095717)
        }
        else{
           

        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        
        
    }
    
    
    
    func addAnnotationOnLocation(buildingName: String) {
        let build: CLLocationCoordinate2D = blah(building: buildingName)
        
       
        
    
        let annotation = MKPointAnnotation()
        
      
        annotation.coordinate = build
        annotation.title = buildingName
        annotation.subtitle = buildingName
        mapView.addAnnotation(annotation)
        

        

            
        }
    

    
    func animateIn(View: UIView ){
        
       self.view.addSubview(View)
        View.center = self.view.center
        
        View.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        View.alpha = 0
        locationManager.stopUpdatingLocation()
        
        
        UIView.animate(withDuration: 0.4) {
            View.alpha = 1
            View.transform = CGAffineTransform.init(scaleX: 1, y: 1)
   
        }
    }
    func animateSearch(){
        if self.searchView.transform == .identity {
        UIView.animate(withDuration: 0.5 , animations: {
            self.searchView.transform = CGAffineTransform.init(translationX: 1, y: -100)
        
        }) { (true) in
            
        }
        }   else {
            UIView.animate(withDuration: 0.5 , animations: {
                self.searchView.transform = .identity
            }) { (true) in
                
            }
            
        }
        

         
    }
    func animateButtons(){
        if self.buttonGroup.transform == .identity {
            UIView.animate(withDuration: 0.5 , animations: {
                self.buttonGroup.transform = CGAffineTransform.init(translationX: 1, y: 1000)
            }) { (true) in
                
            }
        }   else {
            UIView.animate(withDuration: 0.5 , animations: {
                self.buttonGroup.transform = .identity
            }) { (true) in
                
            }
            
        }
        if self.locateButton.transform == .identity {
            UIView.animate(withDuration: 0.6 , animations: {
                self.locateButton.transform = CGAffineTransform.init(translationX: 1, y: 1000)
            }) { (true) in
                
            }
        }   else {
            UIView.animate(withDuration: 0.6 , animations: {
                self.locateButton.transform = .identity
            }) { (true) in
                
            }
            
        }
        
     
        
        
    }
    
    
    func animateOut(View: UIView){
        
        UIView.animate(withDuration: 0.3, animations: {
            View.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
           View.alpha = 0
            
        
        }) { (successs: Bool) in
             View.removeFromSuperview()
            
            
            
        }
      
    }
    
    
   
    @IBAction func DismissNear(_ sender: Any) {
        
        nearView.isHidden = true
        locationManager.stopUpdatingLocation()
    }
    
 
    @IBAction func dismissPopup(_ sender: Any) {
        animateOut(View: BuildDesc )
        searchView.isHidden = false
        buttonGroup.isHidden = false
        locateButton.isHidden = false
        lpgr.isEnabled = true
        dismiss = true
        
        boxHeight.constant = 0
        viewHeight.constant = 450
        
        self.menu.setContentOffset(CGPoint.zero, animated: true)
        
   
        
    
        if(count != nil){
        
        for i in 0...count-1{
            editButton[i].removeFromSuperview()
        
        }
            count = nil
        }
        
        
        editButton.removeAll()
   
        
        

    }
    
    @IBAction func dismissWelcome(_ sender: Any) {
         animateOut(View: welcomeView)
         locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func toggleMapType(_ sender: Any) {
       
        switch mapView.mapType{
        case .standard:
            mapView.mapType = .satellite
            ToggleLabel.setTitle("Satellite", for: .normal)
        case .satellite:
            mapView.mapType = .hybrid
            ToggleLabel.setTitle("Hybrid", for: .normal)
        case .hybrid:
            mapView.mapType = .standard
            ToggleLabel.setTitle("Standard", for: .normal)
            
        case .satelliteFlyover:
            mapView.mapType = .hybrid
            
        case .hybridFlyover:
            mapView.mapType = .standard
        default:
            break
            
        }
        
    }

    @IBAction func overheadMap(_ sender: Any) {
        mapView.camera.pitch = 0.0
        mapView.camera.altitude = 1000.0
        mapView.camera.heading = 0.0
        
        mapView.mapType = .standard
    
    }
    
    @IBAction func flyOver(_ sender: Any) {
        

        switch mapView.mapType{
        case .satellite:
            mapView.mapType = .satelliteFlyover
        case .hybrid:
            mapView.mapType = .hybridFlyover
        case .standard:
            mapView.mapType = .standard
        
        default:
            break
        }
        let camera = MKMapCamera()
        camera.centerCoordinate = mapView.centerCoordinate
        camera.pitch = 30.0
        camera.altitude = 100.0
        camera.heading = 90.0
        mapView.setCamera(camera, animated: true )
        
    }
    

 
    
    
    
  

  
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       print("working", searchBar1.text!)
        searchBar1.resignFirstResponder()
        
        addAnnotationOnLocation(buildingName: searchBar1.text!)
        UITableView.animate(withDuration: 0.2, animations: {
            self.searchTable.frame.size.height = 0;
        })
        
        
       
            
            }
    
    
    private func setUpBuildings(){
        buildingArray.append(Building(name:"Mallory Hall", facility: .bathroom, image: "Mallory Hall", facilnum: "4"))
        buildingArray.append(Building(name:"Old Barracks", facility: .bathroom, image: "Old Barracks", facilnum: "6"))
        buildingArray.append(Building(name:"Maury Brooke", facility: .bathroom, image: "Maury Brooke", facilnum: "4"))
        buildingArray.append(Building(name:"JM Hall", facility: .bathroom, image: "JM Hall", facilnum: "3"))
        buildingArray.append(Building(name:"Foster Stadium", facility: .sports, image: "Foster Stadium", facilnum: "football"))
        buildingArray.append(Building(name:"Scott Shipp", facility: .bathroom, image: "Scott Shipp Hall", facilnum: "5"))
        buildingArray.append(Building(name:"Nichols", facility: .bathroom, image: "Nichols", facilnum: "6"))
        buildingArray.append(Building(name:"Shell Hall", facility: .bathroom, image: "Shell Hall", facilnum: "4"))
        buildingArray.append(Building(name:"Carroll Hall", facility: .bathroom, image: "Carroll", facilnum: "4"))
        buildingArray.append(Building(name:"Post Hospital", facility: .bathroom, image: "Post Hospital", facilnum: "2"))
        buildingArray.append(Building(name:"Kilbourne Hall", facility: .bathroom, image: "Kilbourne Hall", facilnum: "3"))
        buildingArray.append(Building(name:"Preston", facility: .bathroom, image: "Preston", facilnum: "5"))
        buildingArray.append(Building(name:"Cocke Hall", facility: .bathroom, image: "Cocke Hall", facilnum: "5"))
        buildingArray.append(Building(name:"Crozet Hall", facility: .bathroom, image: "Crozet Hall", facilnum: "3"))
        buildingArray.append(Building(name:"New Barracks", facility: .bathroom, image: "New Barracks", facilnum: "6"))
        buildingArray.append(Building(name:"Third Barracks", facility: .bathroom, image: "Third Barracks", facilnum: "6"))
        buildingArray.append(Building(name:"Cormack", facility: .bathroom, image: "Cormack Hall", facilnum: "2"))
        buildingArray.append(Building(name:"Cameron Hall", facility: .sports, image: "Cameron Hall", facilnum: "basketball"))
        buildingArray.append(Building(name:"CPT", facility: .sports, image: "CPT", facilnum: "track/field"))
        
        currentBuilding = buildingArray
        
     
        
    }
 
   

    func alterLayout() {
        searchTable.tableHeaderView = UIView()
        // search bar in section header
        searchTable.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar1
        searchBar1.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar1.placeholder = "Search for Building or facility"
    }
    
    private func setUpSearchBar(){
        searchBar1.delegate = self
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        var newFrame = searchTable.frame
        
        searchTable.isHidden = false
        
        
        
     
      
            newFrame.size.height = 500;
            UITableView.animate(withDuration: 0.9, animations: {
                self.searchTable.frame.size.height = 500;
                 //self.searchTable.frame = newFrame;
                })
            
        }
    
        
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        
        currentBuilding = buildingArray.filter({ building -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return building.facilnum.lowercased().contains(searchText.lowercased()) ||
                building.name.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return building.facility == .bathroom }
                return building.name.lowercased().contains(searchText.lowercased()) &&
                    building.facility == .bathroom
            case 2:
                if searchText.isEmpty { return building.facility == .lab }
                return building.name.lowercased().contains(searchText.lowercased()) &&
                    building.facility == .lab
                
            default:
                return false
            }
        })
        searchTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBuilding.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            return UITableViewCell()
        }
    
        cell.BuildLbl.text = currentBuilding[indexPath.row].name
        cell.facilLbl.text = currentBuilding[indexPath.row].facility.rawValue
        cell.imgView.image = UIImage(named:currentBuilding[indexPath.row].image)
        cell.facilNumLbl.text = currentBuilding[indexPath.row].facilnum
   
        
        
        return cell
  
     
    
    }
    

    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
     let building1 = currentBuilding[indexPath.row].name
        let whatBuild = blah(building:building1)

        
        
        
        addAnnotationOnLocation(buildingName:building1)
        findBuilding(longy: whatBuild.longitude, latty: whatBuild.latitude)
        
        
        UITableView.animate(withDuration: 0.2, animations: {
            self.searchTable.frame.size.height = 0;
        })
        searchTable.endEditing(true)
        searchBar1.endEditing(true)
        

        view.endEditing(true)
        
        
        
    }
    
    class Building {
        let name: String
        let facilnum: String
        let facility: Facil
        let image: String
        init(name: String,  facility: Facil, image: String, facilnum: String){
            self.name = name
            self.facility = facility
            self.image = image
            self.facilnum = facilnum

        }
    }
    enum Facil: String {
        case bathroom  = "Floors: "
        case lab = "lab"
        case sports = "Sports"
        
    }
    
    
    func viewSytles(){
        
        //menuView appearance
        menu.layer.shadowColor = UIColor.black.cgColor
        menu.layer.shadowRadius = 15
       menu.layer.backgroundColor = UIColor.white.cgColor
       menu.layer.cornerRadius = 5
        menu.layer.shadowOpacity = 0.5
      menu.layer.shadowOffset = CGSize(width: 0, height: 0)


        
    
        
        //Search Table appearance
        searchTable.frame.size.height = 0
        
        //locate Button appearance
        locateButton.backgroundColor = UIColor.white
        locateButton.frame.size = CGSize(width: 45, height: 45)
        locateButton.layer.cornerRadius = locateButton.frame.height / 2
        locateButton.layer.shadowRadius = 2
        locateButton.layer.shadowOpacity = 0.8
        locateButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        //searchView appearance
        searchView.layer.cornerRadius = 3
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.white.cgColor
        searchView.layer.shadowColor = UIColor.black.cgColor
        searchView.layer.shadowRadius = 9
        searchView.layer.shadowOpacity = 0.2
        searchView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        //settingsView appearance
        settingView.layer.shadowColor = UIColor.black.cgColor
        settingView.layer.shadowOpacity = 1
        settingView.layer.shadowOffset = CGSize(width: 5, height: 0 )
        self.viewConstraint.constant = -250
        
  
       
        
        //searchbar appearance
        searchBar1.layer.borderWidth = 0
        searchBar1.layer.borderColor = UIColor.white.cgColor
        
        //Textbox appearance
        textBox.layer.cornerRadius = 5
        
        //Direction Button appearance
        directionButton.layer.cornerRadius = 5
        
        //Welcome view
        welcomeView.layer.shadowColor = UIColor.black.cgColor
        welcomeView.layer.shadowRadius = 15
        welcomeView.layer.backgroundColor = UIColor.white.cgColor
        welcomeView.layer.cornerRadius = 3
        welcomeView.layer.shadowOpacity = 0.5
        welcomeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        nearImage.layer.borderColor = UIColor.black.cgColor
        nearImage.layer.borderWidth = 1
        
        dismissWelcomeButton.titleEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        dismissWelcomeButton.frame.size.width = 150
        
        //viewBorder(view: newMenu)
        viewBorder(view: tagView)
        labelTop(view: newMenu)
        
    
        
        locationManager.stopUpdatingLocation()
        
        
        UIView.animate(withDuration: 0.4) {
            
          
            
            
        }
        
        
        
        
   
        
        
    }
   private var counter  = CGFloat (0)
    @IBAction func settingsButtonPressed(_ sender: Any) {
            counter += 1
        UIView.animate(withDuration: 0.8, animations: {
            self.settingsButton.transform = CGAffineTransform(rotationAngle: (CGFloat.pi * self.counter))
        })
        
        
       
            viewConstraint.constant = 0
            UIView.animate(withDuration: 0.5 , animations: {
                self.view.layoutIfNeeded()
            })
        
        animateButtons()
        animateSearch()
        
        
        
    }
    

    
    func dismissSettings() {
    
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewConstraint.constant = -250
                    self.view.layoutIfNeeded()
                    
                })
        
    }
        
    
        
    
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
   
            
            if sender.state == .began || sender.state == .changed {
                
                let translation = sender.translation(in: self.view).x
                
                if translation > 0 { // swipe right
                    
                    
                }else {             // swipe left
                    if viewConstraint.constant > -250 {
                        UIView.animate(withDuration: 0.5, animations: {
                            
                            self.viewConstraint.constant += translation / 2
                            self.view.layoutIfNeeded()
                            
                        })
                    }
                }
                
                
            } else if sender.state == .ended {
                
                if viewConstraint.constant < -100 {
                    UIView.animate(withDuration: 0.01, animations: {
                        
                        self.viewConstraint.constant = -250
                        self.view.layoutIfNeeded()
                        
                    })
                } else {
                 
                }
                
        }
        }
    
    

    

    
    func buildingInfo(building: String, build:[String:String]){
     
        
         count = build.count
        let yourAttributes : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.blue,
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
   
        for (index, value) in build.enumerated(){
     
            sort = build.keys.sorted()
            print(value)
   
            let attributeString = NSMutableAttributedString(string: sort[index],
                                                            attributes: yourAttributes)
            let newEditButton = UIButton(frame: CGRect(x:10, y:30 * (index ), width:320,height:40))
            newEditButton.setAttributedTitle(attributeString, for: .normal)
            newEditButton.contentHorizontalAlignment = .left
            newEditButton.addTarget(self, action: #selector(editButtonTapped), for: UIControlEvents.touchUpInside)
            
            editButton.append(newEditButton)
            newMenu.addSubview(editButton[index])
            boxHeight.constant *= CGFloat(index) + 1
         

        }
        

        if (build.count == 1){
            boxHeight.constant = 40
            viewHeight.constant = 470 + textBox.frame.height
     
        }else if(build.count == 2){
            boxHeight.constant = 80
            viewHeight.constant = 460 + textBox.frame.height + boxHeight.constant
            
        } else if(build.count == 3){
            boxHeight.constant = 120
            viewHeight.constant = 600
        }else if (count == 0 || departmentArray == nil){
            boxHeight.constant = 0
        
        }
    else if (build.count == 5){
            boxHeight.constant = 180
            viewHeight.constant = 760
  
        }else{
            boxHeight.constant = 0
        }
    
    }
    
    

   
    
    @IBAction func editButtonTapped (sender: UIButton!) {
      let departmentWebsite = departmentArray[sender.titleLabel!.text!]!
          print(departmentWebsite)
      
          UIApplication.shared.open(URL(string: departmentWebsite)! as URL, options: [:], completionHandler: nil)
        }
    
    @IBAction func SettingsDirections(_ sender: Any) {
        
        startFromDirections()
        dismissSettings()
        directionsEnabled = true
        removeDirections.isHidden = false
        
    }
    
   
    

}



    

  // <div>Icons made by <a href="https://www.flaticon.com/authors/gregor-cresnar" title="Gregor Cresnar">Gregor Cresnar</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
    
    



    
    
    




