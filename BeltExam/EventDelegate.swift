//
//  EventDelegate.swift
//  BeltExam
//
//  Created by Chao-I Chen on 1/27/18.
//  Copyright © 2018 Chao-I Chen. All rights reserved.
//

import Foundation

protocol EventDelegate: class {
    func itemSaved(by controller: AddEventViewController, with text: String, with info: String, and date: Date, and index: IndexPath?)
    func itemCancle(by controller: AddEventViewController)
}
