//
//  DetailPersonView.swift
//  NewFaces
//
//  Created by Мирсаит Сабирзянов on 22.01.2024.
//

import SwiftUI
import MapKit

struct DetailPersonView: View {
    
    var name: String
    var image: Image
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    var body: some View {
        
        image
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .containerRelativeFrame(.horizontal) { width, axis in
                width * 0.6
            }
        
        Text(name)
                    
        Map(){
            Annotation("It's me!", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
            }
        }
        .mapStyle(.imagery)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    DetailPersonView(name: "", image: Image(systemName: "cat"), latitude: 0, longitude: 0)
}
