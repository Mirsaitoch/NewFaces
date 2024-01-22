//
//  Person.swift
//  NewFaces
//
//  Created by Мирсаит Сабирзянов on 21.01.2024.
//

import Foundation
import SwiftUI

struct Person: Comparable, Identifiable, Codable, Hashable{
    var id = UUID()
    var name: String
    var imageData: Data
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    static let example = Person(name: "", imageData: Data())
}
