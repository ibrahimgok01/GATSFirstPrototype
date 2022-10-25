//
//  ViewController.swift
//  triyaj_takip_prototip2
//
//  Created by Ibrahim Gok on 4.01.2022.
//

import UIKit

class menu: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var hastaneAra: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    var provincePickerView = UIPickerView()
    var diagnosisPickerView = UIPickerView()
    var Provinces = ["İzmir", "Manisa"]
    var diagnoses = ["Burkulmalar", "Kronik Eklem Ağrıları", "Kronik Baş Ağrısı", "Döküntü", "Yara Bakımı", "Vajinal Akıntı", "Soğuk Algınlığı Şikayetleri", "Minör Kulak Ağrısı", "Minör İzole Uzuv Ağrısı", "Böcek Isırıkları", "Dikiş Alımı", "Karın Ağrısı", "Yutma Zorluğu - Boğaz Ağrısı", "Orta Derece Yanıklar", "Böbrek Taşları", "Uzun Kemik - Kalça Kırıkları", "Ampütasyon İle Olmayan Kesikler", "Çoklu - Açık Kırıklar", "Ateşsiz Ciddi Baş Ağrısı"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        provincePickerView.delegate = self
        provincePickerView.dataSource = self
        diagnosisPickerView.delegate = self
        diagnosisPickerView.dataSource = self
        
        // Menü arayüzünün kodlanması.
        
        textField.inputView = provincePickerView
        textField.placeholder = "Hangi İlde Bulunuyorsunuz?"
        textField.textAlignment = .center
        
        textField2.inputView = diagnosisPickerView
        textField2.placeholder = "Ana Belirtiniz Nedir?"
        textField2.textAlignment = .center
        
        provincePickerView.tag = 1
        diagnosisPickerView.tag = 2
        hastaneAra.isEnabled = false
        
    }
    
    // İl ve Belirti seçimleri için kaydırmalı şeçim butonlarının kodlanması.
    
    @objc func selectProvince() {
        textField.resignFirstResponder()
    }
    @objc func selectdiagnosis() {
        textField2.resignFirstResponder()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Provinces.count
        case 2:
            return diagnoses.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return Provinces[row]
        case 2:
            return diagnoses[row] 
        default:
            return "Error!"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
               let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectProvince))
               textField.text = Provinces[row]
               view.addGestureRecognizer(gestureRecognizer)
        case 2:
               let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectdiagnosis))
               textField2.text = diagnoses[row]
               view.addGestureRecognizer(gestureRecognizer)
        default:
            return
        }
        
        if textField.text != "" && textField2.text != "" {
            hastaneAra.isEnabled = true
        }
    }
    @IBAction func hastaneAraTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "tohospitalMapVC", sender: nil)
    }
    // "il seçimi" ve "hastalık belirti seçimi" verilerinin algoritmanın yazıldığı dosyaya aktarılması.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tohospitalMapVC" {
            let destinationVC = segue.destination as! hospital_map
            destinationVC.chosenProvince = textField.text!
            destinationVC.chosenDiagnosis = textField2.text!
        }
    }
}

