//
//  datafactory.swift
//  triyaj_takip_prototip2
//
//  Created by Ibrahim Gok on 4.01.2022.
//

import Foundation
import UIKit

// veri tababnından çekilen verilerin derlenmesi için kod yapısının oluşturulması.

struct hospital_data: Identifiable {
    
    var il : String = ""
    var hastane_ismi : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var greenDensity : String = ""
    var greenCapacity : String = ""
    var yellowDensity : String = ""
    var yellowCapacity : String = ""
    var id : String = "" 
    
    init(raw: [String]) {
        
        il = raw[0]
        id = raw[1]
        hastane_ismi = raw[2]
        latitude = raw[3]
        longitude = raw[4]
        greenDensity = raw[5]
        greenCapacity = raw[6]
        yellowDensity = raw[7]
        yellowCapacity = raw[8]
        
    }
}

// Veri tabanından verilerin çekilemsi için kod yapısının oluşturulması. 

func loadCSV(from csvName: String) -> [hospital_data] {
    var csvToStruct = [hospital_data]()
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return []
    }
    
    var data = ""
    
    do {
      data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return[]
    }
    
    var rows = data.components(separatedBy: "\n")
    
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
        let hospitalDataStruct = hospital_data.init(raw: csvColumns)
        csvToStruct.append(hospitalDataStruct)
        }
    }
    return csvToStruct
}






