//
//  showPlace.swift
//  KeydetGoo
//
//  Created by brian lipscomb on 2/19/18.
//  Copyright © 2018 codewithlips. All rights reserved.
//

import UIKit
import MapKit

class showPlace: UISearchBar {
    
    
    func searchBarSearchButtonCLicked (_ searchBar: UISearchBar){
        //ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {(response, error) in
            if response == nil{
                print("Error")
            }
            else{
            let annotations = self.myMapView.annotations
            self.mapView.removeAnnotations(annotations)
                
                //Remove annnotations
                let annotations = self.mapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                // retrieving data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation
            }
        }
        
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
