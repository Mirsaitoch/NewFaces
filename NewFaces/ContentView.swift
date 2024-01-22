//
//  ContentView.swift
//  NewFaces
//
//  Created by Мирсаит Сабирзянов on 21.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.peopleList.isEmpty {
                    emptyContentView
                } else {
                    peopleListView
                }
            }
            .navigationTitle("NewFaces")
            .toolbar{
                addPersonButton
            }
        }
    }
    
    private var emptyContentView: some View {
        ContentUnavailableView("There are no people here yet",
                               systemImage: "smiley.fill",
                               description: Text(""))
        .photosPickerStyle(.presentation)
    }
    
    private var peopleListView: some View {
        List(viewModel.peopleList.sorted()) { person in
            NavigationLink(destination: DetailPersonView(name: person.name, image: viewModel.fromDataToImage(data: person.imageData), latitude: person.latitude, longitude: person.longitude)) {
                HStack{
                    viewModel.fromDataToImage(data: person.imageData)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                    Text(person.name)
                        .font(.headline)
                }
            }
        }
    }
    
    private func personProfileView(for person: Person) -> some View {
        ProfilePersonView(person: person) { updatedPerson in
            viewModel.updatePerson(previousPerson: person, updatedPerson: updatedPerson)
        }
    }
    
    private var addPersonButton: some View {
        NavigationLink {
            ProfilePersonView(person: .example) { newPerson in
                viewModel.appendPerson(person: newPerson)
            }
        } label: {
            Image(systemName: "plus.circle")
        }
    }
}

#Preview {
    ContentView()
}
