//
//  ViewController.swift
//  TareaMapa
//
//  Created by Carlos Buitrago on 13/04/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    
    @IBOutlet weak var tipo: UISegmentedControl!
    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    var cont = true
    
    var distancia:Double = 0
    var punto = CLLocationCoordinate2D()
    var zoom : Double = 0.01

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        tipo.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        tipo.layer.cornerRadius = 4
        zoom = 0.01
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        self.mapa.setRegion(region, animated: true)
        
        if cont{
            cont = false
            punto.latitude = location!.coordinate.latitude
            punto.longitude = location!.coordinate.longitude
            let pin = MKPointAnnotation()
            pin.title = String(punto.latitude)+","+String(punto.longitude)
            pin.subtitle = String(distancia)
            pin.coordinate = punto
            mapa.addAnnotation(pin)
            
        }
        else{
            let userLocation:CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
            let priceLocation:CLLocation = CLLocation(latitude: punto.latitude, longitude: punto.longitude)
            let meters:CLLocationDistance = userLocation.distanceFromLocation(priceLocation)
            if meters > 50{
                if meters > 150{
                    self.cont = true
                    self.distancia = 0
                    let allAnnotations = self.mapa.annotations
                    self.mapa.removeAnnotations(allAnnotations)
                }else{
                    self.cont = true
                    self.distancia += meters
                }
            }
        }
    }
    @IBAction func zoom(sender: UIStepper) {
        zoom = 100/(sender.value * sender.value * sender.value * sender.value)
    }

    @IBAction func tipoMapa(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapa.mapType = .Standard
        case 1:
            mapa.mapType = .Satellite
        default: // or case 2
            mapa.mapType = .Hybrid
        }
    }

}

