//
//  Person.swift
//  NewFaces
//
//  Created by Мирсаит Сабирзянов on 21.01.2024.
//

import Foundation
import SwiftUI
import MapKit

struct Person: Comparable, Identifiable, Codable, Hashable {
    
    var id = UUID()
    var name: String
    var imageData: Data
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees

    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    static let example = Person(name: "", imageData: Data(), latitude: 0, longitude: 0)
}
