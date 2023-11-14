//
//  ContentView.swift
//  CoreLocationTest
//
//  Created by Guilherme Nunes Lobo on 14/11/23.
//
import SwiftUI
import CoreLocation
import MapKit


struct ContentView: View {
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Coordenadas iniciais (São Francisco, CA)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            if let location = locationManager.location {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .onAppear {
                        setRegion(location.coordinate)
                    }
                    .frame(height: 500)
                    .cornerRadius(10)
                    .padding(.bottom, 10)


                Text("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
                    .padding(.bottom, 10)

                if let placemark = locationManager.placemark {
                    Text("Localização: \(placemark.locality ?? ""), \(placemark.country ?? "")")
                        .padding(.bottom, 10)
                }
            } else {
                if locationManager.isUpdatingLocation {
                    ProgressView("Obtendo Localização...")
                } else {
                    Text("Aguardando a localização...")
                }
            }

            Button(action: {
                if let userLocation = locationManager.location {
                    setRegion(userLocation.coordinate)
                }
            }) {
                Image(systemName: "location.fill.viewfinder")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .background(.shadow(.drop(radius: 10)))
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region.center = coordinate
    }
}


