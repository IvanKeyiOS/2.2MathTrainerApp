//
//  TrainViewController.swift
//  MathTrainerApp
//
//  Created by Иван Курганский on 02/01/2025.
//

import UIKit

final class TrainViewController: UIViewController {
    //MARK: - Properties
    var type: MathTypes = .add {
        didSet {
            print(type)
        }
    }
}
