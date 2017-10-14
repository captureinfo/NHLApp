//
//  InitialViewController.swift
//  FinalProject
//
//  Created by Yang Gao on 10/11/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import GoogleMaps
import GooglePlaces

class InitialViewController: UIViewController, GMSMapViewDelegate{

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    var mapView: GMSMapView!
    var marker: GMSMarker!

    override func viewDidLoad() {
        super.viewDidLoad()

        GMSServices.provideAPIKey("AIzaSyCW40fYtEJ55rVDs3nEMy_jLpxOtDtaOwk")
        let camera = GMSCameraPosition.camera(withLatitude: 40.759098, longitude: -73.985120, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        let currentLocation = CLLocationCoordinate2D(latitude: 40.759098, longitude: -73.985120)
        marker = GMSMarker(position: currentLocation)
        marker.title = "Time Square"
        marker.map = mapView


        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false

        navigationController?.navigationBar.isTranslucent = false
        searchController?.hidesNavigationBarDuringPresentation = false

        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Landmark")
        do {
            let landmarks = try managedContext.fetch(fetchRequest)
            for landmark in landmarks {
                let position = CLLocationCoordinate2D(
                    latitude: landmark.value(forKey: "lat") as! CLLocationDegrees,
                    longitude: landmark.value(forKey: "lon") as! CLLocationDegrees)
                let marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImage(with: .blue)
                marker.title = landmark.value(forKey: "name") as! String?
                marker.map = mapView
                marker.snippet = landmark.value(forKey: "wikiPage") as! String?
            }
        } catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
        }
    }

}

// Handle the user's selection.
extension InitialViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")

        let currentLocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        mapView.animate(toLocation: currentLocation)
        mapView.animate(toZoom: 15)
        marker.position = currentLocation
        marker.title = place.name

    }

    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


