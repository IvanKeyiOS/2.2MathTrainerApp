//
//  ViewController.swift
//  MathTrainerApp
//
//  Created by Иван Курганский on 02/01/2025.
//

import UIKit

enum MathTypes: Int {
    case add, subtract, multiply, divide
}

class ViewController: UIViewController, TrainViewControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var subtractLabel: UILabel!
    @IBOutlet weak var multiplyLabel: UILabel!
    @IBOutlet weak var divideLabel: UILabel!
    
    //MARK: - Properties
    private var selectedType: MathTypes = .add
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    // MARK: - Actions
    @IBAction func buttonsAction(_ sender: UIButton) {
        selectedType = MathTypes(rawValue: sender.tag) ?? .add
        performSegue(withIdentifier: "goToNext", sender: sender)
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) { }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TrainViewController {
            viewController.type = selectedType
            
            viewController.delegate = self
        }
    }
    
    func didReceiveData(_ add: Int, _ subtract: Int, _ multiply: Int, _ divide: Int) {
        sumLabel.text = String(add)
        subtractLabel.text = String(subtract)
        multiplyLabel.text = String(multiply)
        divideLabel.text = String(divide)
    }
    
    private func configureButtons() {
        // MARK: Add shadow for buttons
        buttonsCollection.forEach { button in
            button.layer.shadowColor = UIColor.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowOpacity = 0.4
            button.layer.shadowRadius = 3
        }
    }
}

