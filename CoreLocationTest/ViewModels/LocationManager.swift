//
//  LocationManager.swift
//  CoreLocationTest
//
//  Created by Guilherme Nunes Lobo on 14/11/23.
//
import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var placemark: CLPlacemark?
    @Published var isUpdatingLocation = false

    private var locationManager = CLLocationManager()

    private var lastGeocodingRequestDate: Date?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            isUpdatingLocation = false

            // Adicionando geocodificação com atraso
            geocodeLocationWithDelay(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter localização: \(error.localizedDescription)")
        isUpdatingLocation = false
    }

    private func geocodeLocationWithDelay(_ location: CLLocation) {
        let currentDate = Date()

        if let lastRequestDate = lastGeocodingRequestDate,
           currentDate.timeIntervalSince(lastRequestDate) < 1.0 {
            // Aguarda pelo menos 1 segundo entre as solicitações
            return
        }

        lastGeocodingRequestDate = currentDate

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                self.placemark = placemark
            }
        }
    }
}
