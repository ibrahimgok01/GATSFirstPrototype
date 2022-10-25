//
//  hospital_map.swift
//  triyaj_takip_prototip2
//
//  Created by Ibrahim Gok on 4.01.2022.
//

import UIKit
import MapKit
import CoreLocation

class hospital_map: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    // Algoritma için gerekli değişkenlerin tanımlanması
    
    var chosenProvince = String()
    var chosenDiagnosis = String()
    var latitude = Double()
    var longitude = Double()
    var hospitalName = String()
    var hospitalID = String()
    var momentaryDensity = Double()
    var hospitalCapacity = Double()
    var emergencyService_Density = Double()
    
    
    let greenDiagnoses = ["Burkulmalar", "Kronik Eklem Ağrıları", "Kronik Baş Ağrısı", "Döküntü", "Yara Bakımı", "Vajinal Akıntı", "Soğuk Algınlığı Şikayetleri", "Minör Kulak Ağrısı", "Minör İzole Uzuv Ağrısı", "Böcek Isırıkları", "Dikiş Alımı"]
    let yellowDiagnoses = ["Karın Ağrısı", "Yutma Zorluğu - Boğaz Ağrısı", "Orta Derece Yanıklar", "Böbrek Taşları", "Uzun Kemik - Kalça Kırıkları", "Ampütasyon İle Olmayan Kesikler", "Çoklu - Açık Kırıklar", "Ateşsiz Ciddi Baş Ağrısı"]
    
    var datas = loadCSV(from: "ornek_hastane_verisi")
    // Veri tabanının derlenmesi.
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        mapView.delegate = self
        locationManager.delegate = self
        label.text = "\(chosenProvince)"
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // ALGORİTMANIN YAZILMASI
        
        if datas.count > 0 {
                for data in datas {
                    // Verilerin Derlenmesi.
                    if data.il == chosenProvince {
                        for diagnosis in greenDiagnoses {
                            // Hastanın seçtiği hastalık belirtisine göre triyaj bölgesinin belirlenmesi.
                            if diagnosis == chosenDiagnosis {
                                label2.text = "Yeşil Triyaj Bölgesi"
                                label2.textColor = .systemGreen
                                if let density_data = Double(data.greenDensity) {
                                    momentaryDensity = density_data
                                }
                                if let capacity_data = Double(data.greenCapacity) {
                                    hospitalCapacity = capacity_data
                                }
                            }
                        }
                        for diagnosis in yellowDiagnoses {
                            if diagnosis == chosenDiagnosis {
                                label2.text = "Sarı Triyaj Bölgesi"
                                label2.textColor = .systemYellow
                                if let density_data = Double(data.yellowDensity) {
                                    momentaryDensity = density_data
                                }
                                if let capacity_data = Double(data.yellowCapacity) {
                                    hospitalCapacity = capacity_data
                                }
                            }
                        }
                                if let latitude_data = Double(data.latitude)  {
                                    latitude = latitude_data                                                            // Hastane enleminin veri tabanından çekilmesi.
                                }
                                if let longitude_data = Double(data.longitude) {
                                    longitude = longitude_data                                                          // Hastane boylamının veri tabanından çekilemsi.
                                }
                                if let hastaneisim_data = String?(data.hastane_ismi) {
                                    hospitalName = hastaneisim_data
                                }
                        
                                if let hospitalID_data = String?(data.id) {
                                    hospitalID = hospitalID_data
                                }
                                let location = CLLocationCoordinate2D(latitude: latitude  , longitude: longitude )
                                let annotation: MyAnnotation = MyAnnotation()
                                annotation.customHospitalId = hospitalID
                                annotation.coordinate = location
                                // Pinin hastane kordinatlarına işaretlenmesi.
                                annotation.title = "\(hospitalName)"
                                // Hastane isminin pin üzerine yazdırılması.
                                emergencyService_Density = momentaryDensity/hospitalCapacity * 100
                                // Seçilen triyaj bölgesinin yoğunluğunun hesaplanması.
                                annotation.subtitle = "Yoğunluk: %\(Int(emergencyService_Density))"
                                // Triyaj Yoğunluğunun pin üzerine yazdırılması.
                                mapView.addAnnotation(annotation)
                                // Pinin harita arayüzüne eklenmesi.
                        }
                    }
                }
            }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {                    // Kullanıcı konumunun alınması
       
       let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        print(location)
       let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
       let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Konumum"
        mapView.addAnnotation(annotation)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Harita üzerindeki pin işaretinin özelleştirilmesi.
        
        if annotation is MKUserLocation {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if pinView == nil {
            
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            pinView?.canShowCallout = true
            pinView?.tintColor = .blue
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) { // Navigasyon özelliğinin eklenmesi.
        
        
        let annotation = view.annotation as? MyAnnotation
        
        for data in datas {
            if annotation?.customHospitalId == data.id {
                if let latitude_data = Double(data.latitude)  {
                    latitude = latitude_data
                }
                if let longitude_data = Double(data.longitude) {
                    longitude = longitude_data
                }
                
                if let hospitalName_data = String?(data.hastane_ismi) {
                    hospitalName = hospitalName_data
                }
            }
        }
        
        let requestLocation = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarkDizisi, error in
            
            if let placemarks = placemarkDizisi {
                if placemarks.count > 0 {
                 let yeniPLacemark = MKPlacemark(placemark: placemarks[0])
                    let item  = MKMapItem(placemark: yeniPLacemark)
                    item.name = self.hospitalName
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
            
        }
    }
    
    
}

class MyAnnotation : MKPointAnnotation {
    var customHospitalId : String?
}
