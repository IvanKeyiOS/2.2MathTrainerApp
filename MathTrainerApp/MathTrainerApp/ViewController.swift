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
    //MARK: - /*, ... */ -> For delegate
class ViewController: UIViewController/*, TrainViewControllerDelegate*/ {
    // MARK: - IBOutlets
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var subtractLabel: UILabel!
    @IBOutlet weak var multiplyLabel: UILabel!
    @IBOutlet weak var divideLabel: UILabel!
    
    //MARK: - Properties
    private var selectedType: MathTypes = .add
    
    //MARK: - CALLBACK:
    var receivedDataAdd: String?
    var receivedDataSubtract: String?
    var receivedDataMultiply: String?
    var receivedDataDivide: String?
    
    
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
            //MARK: - For delegate
            //            viewController.delegate = self
            
            //MARK: - CALLBAACK
            viewController.onDataSend = { [weak self] add, subtract, multiply, divide in
                self?.receivedDataAdd = add
                self?.receivedDataSubtract = subtract
                self?.receivedDataMultiply = multiply
                self?.receivedDataDivide = divide
                self?.updateUI()
            }
            viewController.onDataReceive = { [weak self] in
                return (self?.receivedDataAdd,
                        self?.receivedDataSubtract,
                        self?.receivedDataMultiply,
                        self?.receivedDataDivide)
            }
        }
    }
    
    //MARK: - Method fo CALLBACK
    func updateUI() {
        sumLabel.text = receivedDataAdd
        subtractLabel.text = receivedDataSubtract
        multiplyLabel.text = receivedDataMultiply
        divideLabel.text = receivedDataDivide
    }
    
    //MARK: Method for Delegate
//    func didReceiveData(_ add: Int, _ subtract: Int, _ multiply: Int, _ divide: Int) {
//        sumLabel.text = String(add)
//        subtractLabel.text = String(subtract)
//        multiplyLabel.text = String(multiply)
//        divideLabel.text = String(divide)
//    }
    
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

