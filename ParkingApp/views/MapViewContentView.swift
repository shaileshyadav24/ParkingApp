//
//  MapViewContentView.swift
//  ParkingApp
//
//  Created by Nathan Kennedy on 2021-01-25.
//

import SwiftUI
import MapKit

struct MapViewContentView: UIViewRepresentable {
    
    var ParkingInfo:Parking = Parking()
    
    @State var AlertShown:Bool = false
    @State var showAlert:Bool = false
    
    @State var startAnnotationAdded = false
    @State var endAnnotationAdded = false
    
    @ObservedObject var locationManager = LocationManager()
    var userLatitude: Double {
            return Double(locationManager.lastLocation?.coordinate.latitude ?? 0)
        }

    var userLongitude: Double {
        return Double(locationManager.lastLocation?.coordinate.longitude ?? 0)
    }
    
    @State var lat:Double = 0
    @State var lon:Double = 0
    
    
    
    class Coordinator:NSObject, MKMapViewDelegate {
        var parent:MapViewContentView
        
        init(_ parent: MapViewContentView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        
        func mapView(_ mapView:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .blue
            render.lineWidth = 5
            return render
            
        }
        
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIView(context:UIViewRepresentableContext<MapViewContentView>) -> MKMapView {
        
        
        
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
//        let region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: self.ParkingInfo.parkingLat, longitude: self.ParkingInfo.parkingLon),
//            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//          mapView.setRegion(region, animated: true)
        
        
//        let currentUserLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude))
//
//        let markerLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.ParkingInfo.parkingLat, longitude: self.ParkingInfo.parkingLon))
//
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: currentUserLocation)
//          request.destination = MKMapItem(placemark: markerLocation)
//          request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//          directions.calculate { response, error in
//            guard let route = response?.routes.first else { return }
//            mapView.addAnnotations([currentUserLocation, markerLocation])
//            mapView.addOverlay(route.polyline)
//            mapView.setVisibleMapRect(
//              route.polyline.boundingMapRect,
//              edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
//              animated: true)
//          }
        
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        
//        let annotation = MKPointAnnotation()
//        annotation.title = "Greater Toronto Area"
//        annotation.subtitle = "This should be somewhere near the GTA."
//        annotation.coordinate = CLLocationCoordinate2D(latitude: ParkingInfo.parkingLat, longitude: ParkingInfo.parkingLon)
//        mapView.addAnnotation(annotation)
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
        
        
        return mapView
    }
    
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.delegate = context.coordinator
        
        
            

        
        let currentUsersLocation = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
        let markersLocation = CLLocationCoordinate2D(latitude: self.ParkingInfo.parkingLat, longitude: self.ParkingInfo.parkingLon)
        
        let startPin = MKPointAnnotation()
        startPin.coordinate = currentUsersLocation
        startPin.title = "Current Location"
        if(!startAnnotationAdded){
            uiView.addAnnotation(startPin)
            self.startAnnotationAdded = true
        }
        
        
        let endPin = MKPointAnnotation()
        endPin.coordinate = markersLocation
        endPin.title = ParkingInfo.parkingAddr
        if(!endAnnotationAdded){
            uiView.addAnnotation(endPin)
            self.endAnnotationAdded = true
        }
        
        
//        let region = MKCoordinateRegion(center: currentUsersLocation, latitudinalMeters: 100000, longitudinalMeters: 100000)
        
//        uiView.region = region
        
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: currentUsersLocation))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: markersLocation))
        
        let directions = MKDirections(request: req)
        
        directions.calculate { (direct, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let polyline = direct?.routes.first?.polyline
            uiView.addOverlay(polyline!)
//            uiView.setRegion(MKCoordinateRegion(polyline!.boundingMapRect), animated: true)
            uiView.setVisibleMapRect(
            polyline!.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10),
            animated: true)
            
            
        }
        
        
//        let currentUserLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude))
//
//        let markerLocation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.ParkingInfo.parkingLat, longitude: self.ParkingInfo.parkingLon))
//
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: currentUserLocation)
//          request.destination = MKMapItem(placemark: markerLocation)
//          request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//          directions.calculate { response, error in
//            guard let route = response?.routes.first else { return }
//            uiView.addAnnotations([currentUserLocation, markerLocation])
//            uiView.removeOverlays(uiView.overlays)
//            uiView.addOverlay(route.polyline)
//            uiView.setVisibleMapRect(
//              route.polyline.boundingMapRect,
//              edgePadding: UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0),
//              animated: true)
//          }
        
    }
}

struct MapViewContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContentView()
    }
}
