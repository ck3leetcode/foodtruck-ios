//
//  FoodTruckScheduleDataProvider.swift
//  foodtruck-ios
//
//  Created by Chris Kwok on 11/28/19.
//  Copyright © 2019 Chris Kwok. All rights reserved.
//

import Foundation
import MapKit

struct FoodTruckSchedule {
    let name: String
    let address: String
    let location: CLLocation
    let starttime: String
    let endtime: String
    let description: String
}

protocol FoodTruckScheduleDataProvider {
    func fetch(by date: Date, completion: @escaping ((Result<[FoodTruckSchedule], Error>) -> Void))
}
