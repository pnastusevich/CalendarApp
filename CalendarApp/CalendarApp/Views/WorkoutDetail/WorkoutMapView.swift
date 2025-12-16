import SwiftUI
import MapKit

struct WorkoutMapView: View {
    let routeCoordinates: [(latitude: Double, longitude: Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("workout.detail.route".localized())
                .font(.headline)
                .padding(.horizontal)
            
            RouteMapView(routeCoordinates: routeCoordinates)
                .frame(height: 300)
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
}

struct RouteMapView: UIViewRepresentable {
    let routeCoordinates: [(latitude: Double, longitude: Double)]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        guard !routeCoordinates.isEmpty else { return }
        
        let coordinates = routeCoordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        let annotations = MapHelper.createAnnotations(from: coordinates)
        annotations.forEach { mapView.addAnnotation($0) }
        
        let region = MapHelper.calculateRegion(for: routeCoordinates)
        mapView.setRegion(region, animated: false)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

