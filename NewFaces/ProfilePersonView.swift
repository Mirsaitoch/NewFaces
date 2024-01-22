//
//  AddPersonView.swift
//  NewFaces
//
//  Created by Мирсаит Сабирзянов on 21.01.2024.
//

import SwiftUI
import PhotosUI
import MapKit

struct ProfilePersonView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    
    let locationFetcher = LocationFetcher()
    
    @State private var pickedImage: PhotosPickerItem?
    @State private var image: Image?
    
    @State private var name: String
    @State private var imageData: Data
    @State private var finalLocation: CLLocationCoordinate2D
    
    var saveButtonIsActive: Bool{
        image == nil || name == "" || (finalLocation.latitude == 0 && finalLocation.longitude == 0)
    }
    
    var onSave: (Person) -> Void
    
    @State private var showLocationSheet = false
    
    @State private var inputLocation: CLLocationCoordinate2D
    
    @State private var position: MapCameraPosition
    @State private var showMap: Bool
    
    var body: some View {
        VStack{
            PhotosPicker(selection: $pickedImage) {
                if let image {
                    VStack(alignment: .center) {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .containerRelativeFrame(.horizontal) { width, axis in
                                width * 0.6
                            }
                    }
                }
                else {
                    ContentUnavailableView("Add new person", systemImage: "photo.badge.plus.fill", description: Text("tap to choice image"))
                        .photosPickerStyle(.presentation)
                }
            }
            .onChange(of: pickedImage, convertDataImage)
            
            TextField("name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.top, 30)
                        
            if showMap {
                Map(position: $position){
                    Annotation("It's me!", coordinate: finalLocation) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                    }
                }
                .mapStyle(.imagery)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .onAppear(perform: {
            locationFetcher.start()
        })
        .padding(10)
        .toolbar{
            NavigationLink {
                if let location = locationFetcher.lastKnownLocation {
                    AddLocationView(location: location) {
                        coordinate in
                        finalLocation = coordinate
                        print("finalLocation : \(finalLocation.latitude)")
                    }
                } else {
                    AddLocationView(location: CLLocationCoordinate2D(latitude: 55.755819, longitude: 37.617644)) {
                        coordinate in
                        finalLocation = coordinate
                        print("finalLocation : \(finalLocation.latitude)")
                    }
                }
            } label: {
                Image(systemName: "location.circle")
            }
            
            Button("Save", systemImage: "checkmark.circle.fill") {
                print("saved!")
                let newPerson = Person(name: name, imageData: imageData, latitude: finalLocation.latitude, longitude: finalLocation.longitude)
                onSave(newPerson)
                dismiss()
            }.disabled(saveButtonIsActive)
        }
    }
    
    init(person: Person, onSave: @escaping (Person) -> Void) {
        self.person = person
        self.onSave = onSave
        
        _name = State(initialValue: person.name)
        _imageData = State(initialValue: person.imageData)
        _finalLocation = State(initialValue: CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude))
        _inputLocation = State(initialValue: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        if !person.latitude.isZero && !person.longitude.isZero{
            _position = State(initialValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
            _showMap = State(initialValue: true)
        }
        else{
            _position = State(initialValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
            _showMap = State(initialValue: false)
        }
        
        if !person.imageData.isEmpty {
            _image = State(initialValue: Image(uiImage: UIImage(data: person.imageData) ?? UIImage()))
        }
    }
    
    func convertDataImage() {
        Task {
            guard let pickedImage = pickedImage,
                  let inputData = try? await pickedImage.loadTransferable(type: Data.self),
                  let inputImage = UIImage(data: inputData) else {
                return
            }
            imageData = inputData
            image = Image(uiImage: inputImage)
        }
    }
    
    func fetchLocation(){
        if let location = locationFetcher.lastKnownLocation {
            inputLocation = location
            print("Your location is \(location)")
        } else {
            print("Your location is unknown")
        }
    }
}

#Preview {
    ProfilePersonView(person: .example) { _ in }
}
