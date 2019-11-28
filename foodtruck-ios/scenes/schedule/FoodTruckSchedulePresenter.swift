//
//  FoodTruckSchedulePresenter.swift
//  foodtruck-ios
//
//  Created by Chris Kwok on 11/28/19.
//  Copyright © 2019 Chris Kwok. All rights reserved.
//

import Foundation
import MapKit

protocol FoodTruckSchedulePresentingView: class {
    func update(viewModels: [FoodTruckScheduleViewModel])
    func updateError(errMsg: String)
}

struct FoodTruckScheduleViewModel {
    let name: String
    let address: String
    let menu: String
    let hours: String
    let location: CLLocation
    let selected: Bool
}

class FoodTruckSchedulePresenter {
    private let dataProvider: FoodTruckScheduleDataProvider
    private weak var presentingView: FoodTruckSchedulePresentingView?
    
    init(presentingView: FoodTruckSchedulePresentingView,
         dataProvider: FoodTruckScheduleDataProvider = SocrataFoodTruckScheduleDataProvider()) {
        self.presentingView = presentingView
        self.dataProvider = dataProvider
    }
    
    
    func load() {
        let now = Date()
        dataProvider.fetch(by: now) { [weak self] (result) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    strongSelf.presentingView?.updateError(errMsg: "fail to fetch data: \(error.localizedDescription)")
                case .success(let schedules):
                    let vms = schedules.map { s in
                        FoodTruckScheduleViewModel(
                            name: s.name,
                            address: s.address,
                            menu: s.description,
                            hours: "\(s.starttime) - \(s.endtime)",
                            location: s.location,
                            selected: false)
                    }
                    strongSelf.presentingView?.update(viewModels: vms)
                }
            }
        }
    }
}
