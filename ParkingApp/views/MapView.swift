//
//  MapView.swift
//  ParkingApp
//
//  Created by Nathan Kennedy on 2021-01-25.
//

import SwiftUI

struct MapView: View {
    
    var ParkingInfo:Parking
    
    
    var body: some View {
        MapViewContentView(ParkingInfo: ParkingInfo)
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(ParkingInfo: Parking())
    }
}
