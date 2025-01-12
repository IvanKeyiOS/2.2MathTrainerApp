//
//  TrainViewController.swift
//  MathTrainerApp
//
//  Created by Иван Курганский on 02/01/2025.
//

import UIKit
    //MARK: - Protocol for Delegate
//protocol TrainViewControllerDelegate: AnyObject {
//    func didReceiveData(_ add: Int, _ subtract: Int, _ multiply: Int, _ divide: Int)
//}

final class TrainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    //MARK: - Properties
    var type: MathTypes = .add {
        didSet {
            switch type {
            case .add:
                sign = "+"
            case .subtract:
                sign = "-"
            case .multiply:
                sign = "*"
            case .divide:
                sign = "/"
            }
        }
    }
    
    //MARK: - Properties for Delegate
//    weak var delegate: TrainViewControllerDelegate?

    private var add: Int = 0
    private var subtract: Int = 0
    private var multiply: Int = 0
    private var divide: Int = 0
    
    //MARK: - Callback properties
    var onDataSend: ((String, String, String, String) -> Void)?
    var onDataReceive: (() -> (String?, String?, String?, String?))?
    
    private var sendDataAdd: Int?
    private var sendDataSubtract: Int?
    private var sendDataMultiply: Int?
    private var sendDataDivide: Int?
    
    private var receivedDataAdd: Int?
    private var receivedDataSubtract: Int?
    private var receivedDataMultiply: Int?
    private var receivedDataDivide: Int?
    
    private var isRightAnswer: Bool = true
    
    private var countAdd: Int = 0
    private var countSubtract: Int = 0
    private var countMultiply: Int = 0
    private var countDivide: Int = 0
    
    private var firstNumber: Int = 0
    private var secondNumber: Int = 0
    
    private var sign: String = ""
    private var count: Int = 0 {
        didSet {
            getCount()
        }
    }
    
   
    
    private var answer: Int {
        switch type {
        case .add:
            return firstNumber + secondNumber
        case .subtract:
            return firstNumber - secondNumber
        case .multiply:
            return firstNumber * secondNumber
        case .divide:
            return firstNumber / secondNumber
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureQuestionDivide()
        configureQuestion()
        configureButtons()
        calculationAnswer()
                
        //MARK: - Callback in Life cycle
        if let receivedData = onDataReceive?() {
            receivedDataAdd = Int(receivedData.0 ?? "") ?? 0
            receivedDataSubtract = Int(receivedData.1 ?? "") ?? 0
            receivedDataMultiply = Int(receivedData.2 ?? "") ?? 0
            receivedDataDivide = Int(receivedData.3 ?? "") ?? 0
        }
        getCount()
    }
    
    //MARK: - IBActions
    @IBAction func leftButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }
    @IBAction func rightButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }
    
    @IBAction func sendDataAndDismiss() {
        
        //MARK: - Callback received data
        countAdd = receivedDataAdd ?? 0
        countSubtract = receivedDataSubtract ?? 0
        countMultiply = receivedDataMultiply ?? 0
        countDivide = receivedDataDivide ?? 0
        
        
        //MARK: - Callback send data
        onDataSend?(String(sendDataAdd ?? 0), String(sendDataSubtract ?? 0), String(sendDataMultiply ?? 0), String(sendDataDivide ?? 0))
        
        //MARK: - Delegate
//        delegate?.didReceiveData(add, subtract, multiply, divide)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods
    private func configureButtons() {
        let buttonsArray = [leftButton, rightButton]
        buttonsArray.forEach { button in
            button?.backgroundColor = .systemYellow
        }
        
        // MARK: - Add shadow for buttons
        buttonsArray.forEach { button in
            button?.layer.shadowColor = UIColor.red.cgColor
            button?.layer.shadowOffset = CGSize(width: 0, height: 2)
            button?.layer.shadowOpacity = 0.4
            button?.layer.shadowRadius = 3
        }
    }
    
    private func calculationAnswer () {
        let isRightButton = Bool.random()
        var randomAnswer: Int
        
        repeat {
            randomAnswer = Int.random(in: (answer + 8)...(answer + 9))
        } while randomAnswer == answer
        
        rightButton.setTitle(isRightButton ? String(answer) : String(randomAnswer), for: .normal)
        leftButton.setTitle(isRightButton ? String(randomAnswer) : String(answer), for: .normal)
    }
    
    private func configureQuestion() {
        if type != MathTypes.divide {
            firstNumber = Int.random(in: 1...99)
            secondNumber = Int.random(in: 1...99)
            
            let question: String = "\(firstNumber) \(sign) \(secondNumber) ="
            questionLabel.text = question
        }
    }
    
    private func configureQuestionDivide() {
        secondNumber = Int.random(in: 1...99)
        let multiplier = Int.random(in: 1...99)
        
        firstNumber = secondNumber * multiplier
        
        let question: String = "\(firstNumber) \(sign) \(secondNumber) ="
        questionLabel.text = question
    }
    
    private func check(answer: String, for button: UIButton) {
        isRightAnswer = Int(answer) == self.answer
        
        button.backgroundColor = isRightAnswer ? .green : .red
        
        countRightAnswer()
    }
    
    private func countRightAnswer() {
        if isRightAnswer {
            let isSecondAttempt = rightButton.backgroundColor == .red || leftButton.backgroundColor == .red
            count += isSecondAttempt ? 0 : 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.configureQuestionDivide()
                self?.configureQuestion()
                self?.calculationAnswer()
                self?.configureButtons()
                
                //MARK: Use method for Delegate
//                self?.passCountSumToViewController()
            }
        }
    }
    
    private func getCount() {
        if type == MathTypes.add {
            countAdd = count
            sendDataAdd = countAdd + (receivedDataAdd ?? 0)
            countLabel.text = "Ваш результат: \(String(sendDataAdd ?? 0))"
        } else if type == MathTypes.subtract {
            countSubtract = count
            sendDataSubtract = countSubtract + (receivedDataSubtract ?? 0)
            countLabel.text = "Ваш результат: \(String(sendDataSubtract ?? 0))"
        } else if type == MathTypes.multiply {
            countMultiply = count
            sendDataMultiply = countMultiply + (receivedDataMultiply ?? 0)
            countLabel.text = "Ваш результат: \(String(sendDataMultiply ?? 0))"
        } else {
            countDivide = count
            sendDataDivide = countDivide + (receivedDataDivide ?? 0)
            countLabel.text = "Ваш результат: \(String(sendDataDivide ?? 0))"
        }
    }
    
    //MARK: Method for Delegate
//    private func passCountSumToViewController() {
//        if type == MathTypes.add {
//            add = countAdd
//        } else if type == MathTypes.subtract {
//            subtract = countSubtract
//        } else if type == MathTypes.multiply {
//            multiply = countMultiply
//        } else {
//            divide = countDivide
//        }
//    }
}
