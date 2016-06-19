//
//  Weightcalculator.swift
//  DataPersistence
//
//  Created by Florian M. on 14/06/16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation

public func CalculateWeight (maxWeight: Int, repNumber: Int) -> Double {
    var weight: Double
    
    weight = Double(maxWeight)*0.86 - Double(repNumber - 5)*0.00375*Double(maxWeight)
    return weight
}