//
//  MapView.swift
//  ParkingApp
//
//  Created by Nathan Kennedy 101333351 on 2021-01-25.
//

import SwiftUI

struct MapView: View {
    
    var ParkingInfo:Parking
    
    @ObservedObject var locationManager = LocationManager()
    var userLatitude: Double {
            return Double(locationManager.lastLocation?.coordinate.latitude ?? 0)
        }

    var userLongitude: Double {
        return Double(locationManager.lastLocation?.coordinate.longitude ?? 0)
    }
    
    
    var body: some View {
        MapViewContentView(ParkingInfo: ParkingInfo, userLatitude: userLatitude, userLongitude: userLongitude)
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(ParkingInfo: Parking())
    }
}
