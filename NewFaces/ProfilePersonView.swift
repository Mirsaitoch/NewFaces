//
//  AddPersonView.swift
//  NewFaces
//
//  Created by Мирсаит Сабирзянов on 21.01.2024.
//

import SwiftUI
import PhotosUI

struct ProfilePersonView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    
    @State private var pickedImage: PhotosPickerItem?
    @State private var image: Image?
    
    @State private var name: String
    @State private var imageData: Data
    
    var saveButtonIsActive: Bool{
        image == nil || name == ""
    }
    
    var onSave: (Person) -> Void
    
    var body: some View {
        VStack{
            PhotosPicker(selection: $pickedImage) {
                if let image {
                    VStack(alignment: .center) {
                        image
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal) { width, axis in
                                width * 0.6
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
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
        }
        .padding(10)
        .toolbar{
            Button("Save", systemImage: "checkmark.circle.fill") {
                let newPerson = Person(name: name, imageData: imageData)
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
}

#Preview {
    ProfilePersonView(person: .example) { _ in}
}
