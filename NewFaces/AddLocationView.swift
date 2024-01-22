import SwiftUI
import MapKit

struct AddLocationView: View {
    
    var location: CLLocationCoordinate2D
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var position: MapCameraPosition
    @State private var coordinate: CLLocationCoordinate2D
    
    var onSave: (CLLocationCoordinate2D) -> Void
    
    var body: some View {
        NavigationStack{
            MapReader { proxy in
                Map(position: $position){
                    Annotation("It's me!", coordinate: coordinate) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                    }
                }
                .onTapGesture { position in
                    if let newCoordinate = proxy.convert(position, from: .local) {
                        coordinate = newCoordinate
                    }
                }
            }
            .navigationTitle("Choose your location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("Done"){
                    onSave(coordinate)
                    dismiss()
                }
            }
        }
    }
    
    init(location: CLLocationCoordinate2D, onSave: @escaping ((CLLocationCoordinate2D)) -> Void) {
        self.location = location
        self.onSave = onSave

        print(location.latitude)
        _coordinate = State(initialValue: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        _position = State(initialValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))))
    }
}

#Preview {
    AddLocationView(location: CLLocationCoordinate2D(latitude: 55.755696,  longitude: 37.617306)){ _ in}
}
