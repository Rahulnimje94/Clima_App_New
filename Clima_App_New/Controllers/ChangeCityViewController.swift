//
//  ChangeCityViewController.swift
//  Clima_App_New
//
//  Created by Anand Nimje on 04/02/18.
//  Copyright © 2018 Anand. All rights reserved.
//

import UIKit
import ANLoader

protocol ChangeCityDelegate {
    func userEnteredANewCityName(City: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    @IBAction func getWeatherPressed(_ sender: UIButton) {
        let cityName = changeCityTextField.text!
        dismiss(animated: true, completion: nil)
        delegate?.userEnteredANewCityName(City: cityName)
    }
    
    @IBAction func backbuttennPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
