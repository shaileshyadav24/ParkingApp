//
//  ViewParkingDetailsView.swift
//  ParkingApp
//
//  Created by Nathan Kennedy on 2021-01-24.
//

import SwiftUI

struct ViewParkingDetailsView: View {
    var ParkingInfo:Parking
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ViewParkingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewParkingDetailsView(ParkingInfo: Parking())
    }
}
