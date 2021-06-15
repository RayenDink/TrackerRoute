//
//  LocationManager.swift
//  TrackerRoute
//
//  Created by Rayen on 15.06.2021.
//

import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    static let instance = LocationManager()

    private override init() {
        super.init()
        configureLocationManager()
    }

    let locationManager = CLLocationManager()

    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    private func configureLocationManager() {
        // Устанавливаем делегат:
        locationManager.delegate = self
        // Разрешить обновление геолокации в фоновом режиме:
        locationManager.allowsBackgroundLocationUpdates = true
        // Не останавливать определение локации, если приложение находится в фоне и телефон некоторое время не меняет местоположения:
        locationManager.pausesLocationUpdatesAutomatically = false
        // Точность геолокации:
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Запускать приложение при перемещении устройства на 500 метров и более:
        locationManager.startMonitoringSignificantLocationChanges()
        // Запросим разрешения на работу геолокации в фоне:
        locationManager.requestAlwaysAuthorization()

    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        self.location.accept(locations.last)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

