//
//  TrainViewController.swift
//  MathTrainerApp
//
//  Created by Иван Курганский on 02/01/2025.
//

import UIKit

final class TrainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var buttonsCollection: [UIButton]!
    
    //MARK: - Properties
    var type: MathTypes = .add {
        didSet {
            print(type)
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    //MARK: - Methods
    private func configureButtons() {
        // MARK: Add shadow for buttons
        buttonsCollection.forEach { button in
            button.layer.shadowColor = UIColor.red.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.4
            button.layer.shadowRadius = 3
        }
    }
}
