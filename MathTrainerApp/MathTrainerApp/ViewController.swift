//
//  ViewController.swift
//  MathTrainerApp
//
//  Created by Иван Курганский on 02/01/2025.
//

import UIKit

enum MathTypes: Int, CaseIterable {
    case add, subtract, multiply, divide
    
    var key: String {
        switch self {
        case .add:
            return "addCount"
        case .subtract:
            return "subtractCount"
        case .multiply:
            return "multiplyCount"
        case .divide:
            return "divideCount"
        }
    }
}
    //MARK: - /*, ... */ -> For delegate
class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var subtractLabel: UILabel!
    @IBOutlet weak var multiplyLabel: UILabel!
    @IBOutlet weak var divideLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var additionalResultLabel: UILabel!
    @IBOutlet weak var subtractionResultLabel: UILabel!
    @IBOutlet weak var multiplicationResultLabel: UILabel!
    @IBOutlet weak var divisionResultLabel: UILabel!
    
    //MARK: - Properties
    private var selectedType: MathTypes = .add
    
    //MARK: - CALLBACK:
    private var receivedDataAdd: Int = 0
    private var receivedDataSubtract: Int = 0
    private var receivedDataMultiply: Int = 0
    private var receivedDataDivide: Int = 0
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationLabels()
        configureButtons()
        setCountLabels()
        configView()
    }
    
    // MARK: - Actions
    @IBAction func buttonsAction(_ sender: UIButton) {
        selectedType = MathTypes(rawValue: sender.tag) ?? .add
        performSegue(withIdentifier: "goToNext", sender: sender)
    }
    
    @IBAction func clearActionButton(_ sender: Any) {
        MathTypes.allCases.forEach { type in
            let key = type.key
            UserDefaults.container?.removeObject(forKey: key)
            
            if receivedDataAdd != 0 || receivedDataDivide != 0 ||
                receivedDataMultiply != 0 || receivedDataSubtract != 0 {
                            additionalResultLabel.text = "Additional: -"
                            divisionResultLabel.text = "Division: -"
                            multiplicationResultLabel.text = "Multiplication: -"
                            subtractionResultLabel.text = "Subtraction: -"
            }
        }
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
        setCountLabels()
    }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TrainViewController {
            viewController.type = selectedType
            
    //MARK: - CALLBAACK
            viewController.onDataSend = { [weak self] add, subtract, multiply, divide in
                self?.receivedDataAdd += add
                self?.receivedDataSubtract += subtract
                self?.receivedDataMultiply += multiply
                self?.receivedDataDivide += divide
                self?.updateUI()
            }
        }
    }
     
        private func configView() {
        recordView.layer.cornerRadius = 16
        recordView.layer.masksToBounds = true
    }
    
    private func setCountLabels() {
        MathTypes.allCases.forEach { type in
            let key = type.key
            guard let count = UserDefaults.standard.object(forKey: key) as? Int else { return }
            let stringValue = String(count)
            
            switch type {
            case .add:
                additionalResultLabel.text = stringValue
            case .subtract:
                subtractionResultLabel.text = stringValue
            case .multiply:
                multiplicationResultLabel.text = stringValue
            case .divide:
                divisionResultLabel.text = stringValue
            }
        }
    }
    
    //MARK: - Method fo CALLBACK
    private func updateUI() {
        additionalResultLabel.text = String("Additional: \(receivedDataAdd)")
        subtractionResultLabel.text = String("Subtraction: \(receivedDataSubtract)")
        multiplicationResultLabel.text = String("Multiplication: \(receivedDataMultiply)")
        divisionResultLabel.text = String("Division: \(receivedDataDivide)")
        sumLabel.text = "Additional"
        subtractLabel.text = "Subtraction"
        divideLabel.text = "Division"
        multiplyLabel.text = "Multiplication"
        sumLabel.font = .italicSystemFont(ofSize: 15)
        subtractLabel.font = .italicSystemFont(ofSize: 15)
        divideLabel.font = .italicSystemFont(ofSize: 15)
        multiplyLabel.font = .italicSystemFont(ofSize: 15)
    }
    
    private func configurationLabels() {
        sumLabel.text = "Additional"
        subtractLabel.text = "Subtraction"
        divideLabel.text = "Division"
        multiplyLabel.text = "Multiplication"
        sumLabel.font = .italicSystemFont(ofSize: 15)
        subtractLabel.font = .italicSystemFont(ofSize: 15)
        divideLabel.font = .italicSystemFont(ofSize: 15)
        multiplyLabel.font = .italicSystemFont(ofSize: 15)
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
