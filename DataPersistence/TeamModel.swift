//
//  TeamModel.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
struct TeamModel {
    var name: String
    var gruppe: String
    var pkt: Int
    
    init(name: String,gruppe: String, pkt: Int){
        self.name = name
        self.gruppe = gruppe
        self.pkt = pkt
    }
}