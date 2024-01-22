//
//  ContentView-ViewModel.swift
//  NewFaces
//
//  Created by Мирсаит Сабирзянов on 21.01.2024.
//

import Foundation
import SwiftUI

extension ContentView{
    @Observable
    class ViewModel{
        
        var savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        private(set) var peopleList = [Person]()
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                peopleList = try JSONDecoder().decode([Person].self, from: data)
            } catch {
                peopleList = []
            }
        }
        
        private func save(){
            do {
                let data = try JSONEncoder().encode(peopleList)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Error!")
            }
        }
        
        func appendPerson(person: Person) {
            peopleList.append(person)
            save()
        }
        
        func updatePerson(previousPerson: Person, updatedPerson: Person) {
            if let index = peopleList.firstIndex(of: previousPerson) {
                peopleList[index] = updatedPerson
                save()
            }
        }
        
        func fromDataToImage(data: Data) -> Image {
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
            } else {
                Image(systemName: "cat")
            }
        }
    }
}
