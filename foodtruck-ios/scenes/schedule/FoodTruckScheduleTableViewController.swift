//
//  FoodTruckScheduleTableViewController.swift
//  foodtruck-ios
//
//  Created by Chris Kwok on 11/28/19.
//  Copyright © 2019 Chris Kwok. All rights reserved.
//

import UIKit

class FoodTruckScheduleTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var viewModels = [FoodTruckScheduleViewModel]()
    fileprivate var presenter: FoodTruckSchedulePresenter!
    fileprivate let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        tableView.register(UINib(nibName: "FoodTruckScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        presenter = FoodTruckSchedulePresenter(presentingView: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.load()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FoodTruckScheduleTableViewController: FoodTruckSchedulePresentingView {
    func update(viewModels: [FoodTruckScheduleViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func updateError(errMsg: String) {
        self.viewModels = []
        tableView.reloadData()
        //TODO: show alert
    }
}


extension FoodTruckScheduleTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            as? FoodTruckScheduleTableViewCell else {
                return UITableViewCell()
        }
        
        let viewModel = self.viewModels[indexPath.row]
        cell.addressTitle.text = viewModel.address
        cell.menuTitle.text = viewModel.menu
        cell.nameTitle.text = viewModel.name
        cell.businessHoursTitle.text = viewModel.hours
        return cell
    }
}
