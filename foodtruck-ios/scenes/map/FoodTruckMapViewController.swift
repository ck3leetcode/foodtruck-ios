//
//  FoodTruckMapViewController.swift
//  foodtruck-ios
//
//  Created by Chris Kwok on 11/28/19.
//  Copyright © 2019 Chris Kwok. All rights reserved.
//

import UIKit
import MapKit

class FoodTruckMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate var viewModels = [FoodTruckScheduleViewModel]()
    fileprivate var presenter: FoodTruckSchedulePresenter!
    
    fileprivate var cell: FoodTruckScheduleTableViewCell?
    
    @IBAction func onListNavItemTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter = FoodTruckSchedulePresenter(presentingView: self)
        mapView.delegate = self
        configBottomView()
        
        self.navigationItem.hidesBackButton = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.load()
    }
    
    private func configBottomView() {
        cell = UINib(nibName: "FoodTruckScheduleTableViewCell", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as? FoodTruckScheduleTableViewCell
        
        if let cell = cell {
            let contentView = cell.contentView
            contentView.isHidden = true
            contentView.backgroundColor = .white
            view.addSubview(cell.contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: contentView,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .leading,
                                   multiplier: 1, constant: 0.0),
                NSLayoutConstraint(item: contentView,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .width,
                                   multiplier: 1, constant: 0.0),
                NSLayoutConstraint(item: contentView,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .bottom,
                                   multiplier: 1, constant: 0.0),
            ])
        }
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

extension FoodTruckMapViewController: FoodTruckSchedulePresentingView {
    func update(viewModels: [FoodTruckScheduleViewModel]) {
        self.viewModels = viewModels
        
        let annotations: [MKAnnotation] =
            viewModels.map { vm in FoodTruckPinAnnotation(viewModel: vm) }
        mapView.showAnnotations(annotations, animated: false)
    }
    
    func updateError(errMsg: String) {
        self.viewModels = []
        mapView.removeAnnotations(mapView.annotations)
        //TODO: show alert
    }
}

extension FoodTruckMapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let cell = cell,
            let annotation = view.annotation as? FoodTruckPinAnnotation else {
                return
        }
        
        let viewModel = annotation.viewModel
        cell.addressTitle.text = viewModel.address
        cell.menuTitle.text = viewModel.menu
        cell.nameTitle.text = viewModel.name
        cell.businessHoursTitle.text = viewModel.hours
        cell.contentView.isHidden = false
        mapView.setCenter(annotation.coordinate, animated: true)
    }
}


fileprivate class FoodTruckPinAnnotation: MKPointAnnotation {
    let viewModel: FoodTruckScheduleViewModel
    init(viewModel: FoodTruckScheduleViewModel) {
        self.viewModel = viewModel
        super.init()
        self.coordinate = viewModel.location.coordinate
    }
}
