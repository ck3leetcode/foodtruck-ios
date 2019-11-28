//
//  FoodTruckSchedulePresenter.swift
//  foodtruck-ios
//
//  Created by Chris Kwok on 11/28/19.
//  Copyright © 2019 Chris Kwok. All rights reserved.
//

import Foundation

protocol FoodTruckSchedulePresentingView {
    func update(schedules: [FoodTruckSchedule])
    func updateError(errMsg: String)
}

class FoodTruckSchedulePresenter {
    private let dataProvider: FoodTruckScheduleDataProvider
    private let presentingView: FoodTruckSchedulePresentingView
    
    init(presentingView: FoodTruckSchedulePresentingView,
         dataProvider: FoodTruckScheduleDataProvider = SocrataFoodTruckScheduleDataProvider()) {
        self.presentingView = presentingView
        self.dataProvider = dataProvider
    }
    
    
    func load() {
        let now = Date()
        dataProvider.fetch(by: now) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error): strongSelf.presentingView.updateError(errMsg: "fail to fetch data:  \(error.localizedDescription)")
            case .success(let schedules): strongSelf.presentingView.update(schedules: schedules)
            }
        }
    }
}
