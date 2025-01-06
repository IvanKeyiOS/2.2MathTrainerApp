//
//  TrainViewController.swift
//  MathTrainerApp
//
//  Created by Иван Курганский on 02/01/2025.
//

import UIKit

protocol TrainViewControllerDelegate: AnyObject {
    func didReceiveData(_ add: Int, _ subtract: Int, _ multiply: Int, _ divide: Int)
}

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
    
    weak var delegate: TrainViewControllerDelegate?

    private var add: Int = 0
    private var subtract: Int = 0
    private var multiply: Int = 0
    private var divide: Int = 0
    
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
        getCount()
        configureButtons()
        calculationAnswer()
    }
    
    //MARK: - IBActions
    @IBAction func leftButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }
    @IBAction func rightButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }
    
    @IBAction func sendDataAndDismiss() {
        delegate?.didReceiveData(add, subtract, multiply, divide)
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
                self?.passCountSumToViewController()
            }
        }
    }
    
    private func getCount() {
        if type == MathTypes.add {
            countAdd = count
            countLabel.text = "Ваш результат: \(String(countAdd))"
        } else if type == MathTypes.subtract {
            countSubtract = count
            countLabel.text = "Ваш результат: \(String(countSubtract))"
        } else if type == MathTypes.multiply {
            countMultiply = count
            countLabel.text = "Ваш результат: \(String(countMultiply))"
        } else {
            countDivide = count
            countLabel.text = "Ваш результат: \(String(countDivide))"
        }
    }
    
    private func passCountSumToViewController() {
        if type == MathTypes.add {
            add = countAdd
        } else if type == MathTypes.subtract {
            subtract = countSubtract
        } else if type == MathTypes.multiply {
            multiply = countMultiply
        } else {
            divide = countDivide
        }
    }
}
