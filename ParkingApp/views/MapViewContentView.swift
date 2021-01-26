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
    
//    @ObservedObject var locationManager = LocationManager()
//    var userLatitude: Double {
//            return Double(locationManager.lastLocation?.coordinate.latitude ?? 0)
//        }
//
//    var userLongitude: Double {
//        return Double(locationManager.lastLocation?.coordinate.longitude ?? 0)
//    }
    
    @State var userLatitude:Double = 0
    @State var userLongitude:Double = 0
    
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
        
        let currentUsersLocation = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
        let markersLocation = CLLocationCoordinate2D(latitude: self.ParkingInfo.parkingLat, longitude: self.ParkingInfo.parkingLon)
        
        
        let startPin = MKPointAnnotation()
        startPin.coordinate = currentUsersLocation
        startPin.title = "Current Location"
        mapView.addAnnotation(startPin)
        
        
        let endPin = MKPointAnnotation()
        endPin.coordinate = markersLocation
        endPin.title = ParkingInfo.parkingAddr
        mapView.addAnnotation(endPin)
        

        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        
        
        return mapView
    }
    
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.delegate = context.coordinator
        
        let currentUsersLocation = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
        let markersLocation = CLLocationCoordinate2D(latitude: self.ParkingInfo.parkingLat, longitude: self.ParkingInfo.parkingLon)
        
        
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
            uiView.setVisibleMapRect(
            polyline!.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10),
            animated: true)
            
            
        }
        
        
    }
}

struct MapViewContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContentView()
    }
}
