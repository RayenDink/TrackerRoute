//
//  ViewController.swift
//  TrackerRoute
//
//  Created by Rayen on 15.06.2021.
//

import Foundation
import UIKit
import GoogleMaps
import RealmSwift
import CoreLocation
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    var usselesExampleVariable = ""

    private var marker: GMSMarker?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    //Вынес в отдельный файл
    var locationManager = LocationManager.instance

    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func currentLocation(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
        addLastRoute()
    }
    @IBAction func lastroute(_ sender: Any) {
        lastRoute()
    }

    @IBAction func recordLocation(_ sender: UIButton) {
        addLine()
        locationManager.startUpdatingLocation()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
    }



    func configureMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.728899, longitude: 37.654048)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
    }

    func configureLocationManager() {
        _ = locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                // Обновляем путь у линии маршрута путём повторного присвоения
                self?.route?.path = self?.routePath
                self?.removeMarker()
                self?.addMarker(position: location.coordinate)
                self?.configureMap()
                // Чтобы наблюдать за движением, установим камеру на только что добавленную точку
             //   self?.configureMap(coordinate: location.coordinate)
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
            }
    }


    func addLine() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = .systemBlue
        route?.strokeWidth = 2
        routePath = GMSMutablePath()
        route?.map = mapView
    }

    func addMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.map = mapView
        self.marker = marker
        mapView.animate(toLocation: position)

    }

    func removeMarker() {
        marker?.map = nil
        marker = nil
    }


    func addLastRoute() {
        var lastRoute: [Route] = []
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded:false)
            let realm = try Realm(configuration: config)
            guard let routePath = routePath else { return }

            for i in 0..<routePath.count() {
                let currentCoordinate = routePath.coordinate(at: i)
                let route = Route()
                route.latitude = currentCoordinate.latitude
                route.longitude = currentCoordinate.longitude
                lastRoute.append(Route(value: route))
            }

            try realm.write{
                    realm.deleteAll()
                    realm.add(lastRoute)
                }

        } catch {
            print(error)
        }
    }

    func lastRoute() {
        let realm = try! Realm()
        let lastRoute: Results<Route> = { realm.objects(Route.self) }()
        guard !lastRoute.isEmpty else { return }
        addLine()
        for coordinates in lastRoute {
            routePath?.add(CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))
            route?.path = routePath
        }
        let firstCoordinates = CLLocationCoordinate2D(latitude: lastRoute.first!.latitude, longitude: lastRoute.first!.longitude)
        let lastCoordinates = CLLocationCoordinate2D(latitude: lastRoute.last!.latitude ,longitude: lastRoute.last!.longitude)
        let bounds = GMSCoordinateBounds(coordinate: firstCoordinates, coordinate: lastCoordinates)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
        mapView.camera = camera
        mapView.moveCamera(GMSCameraUpdate.zoomOut())
    }


}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
        mapView.animate(to: camera)
        removeMarker()
        addMarker(position: location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

