//
//  AddEventViewController.swift
//  BeltExam
//
//  Created by Chao-I Chen on 1/27/18.
//  Copyright © 2018 Chao-I Chen. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    weak var delegate: EventDelegate?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var infoText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    
    var timeDate: Date?
    var infoString: String?
    var titleString: String?
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if infoString != nil{
            infoText.text = infoString
            titleText.text = titleString
            timePicker.setDate(timeDate!, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancleButtonPressed(_ sender: UIButton) {
        delegate?.itemCancle(by: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.itemSaved(by: self, with: titleText.text!, with: infoText.text!, and: timePicker.date, and: index)
    }
}
