//
//  TrainViewController.swift
//  MathTrainerApp
//
//  Created by Иван Курганский on 02/01/2025.
//

import UIKit
import SnapKit

final class TrainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    @IBOutlet weak var wordOfAdmirationLabel: UILabel!
    
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
    private var add: Int = 0
    private var subtract: Int = 0
    private var multiply: Int = 0
    private var divide: Int = 0
    
    //MARK: - Callback properties
    var onDataSend: ((Int, Int, Int, Int) -> Void)?

    private var sendDataAdd: Int?
    private var sendDataSubtract: Int?
    private var sendDataMultiply: Int?
    private var sendDataDivide: Int?
    
    private var isRightAnswer: Bool = true
        
    private var firstNumber: Int = 0
    private var secondNumber: Int = 0
    
    private var sign: String = ""
    private var count: Int = 0 {
        didSet {
            getCount()
           
            let numberForCount = count
            
            let result = switch numberForCount {
          
            case 10: "Amazing"
            case 15: "Incredible"
            case 20: "Wonderful"
            case 25: "Brilliant"
            case 30: "Impressive"
            case 35: "Awesome"
            case 40: "Superb"
            case 45: "Stunning"
            case 50: "Outstanding"
            case 55: "Marvelous"
            case 60: "Fascinating"
            case 65: "Breathtaking"
            default: ""
            }
            
            wordOfAdmirationLabel.text = result
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.wordOfAdmirationLabel.text = result
            }
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
        getCount()
    }

    //MARK: - IBActions
    @IBAction func leftButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }
    @IBAction func rightButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }

    @IBAction func leftBottomButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }

    @IBAction func rightBottomButtonAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "", for: sender)
    }

    @IBAction func sendDataAndDismiss() {
        //MARK: - Callback send data
        onDataSend?(
        (sendDataAdd ?? 0),
        (sendDataSubtract ?? 0),
        (sendDataMultiply ?? 0),
        (sendDataDivide ?? 0)
        )
        
        //MARK: - Delegate
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods
    private func configureButtons() {
        let buttonsArray = [leftButton, rightButton, bottomLeftButton, bottomRightButton]
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
    
    private func saveCount() {
        if let count = UserDefaults.standard.object(forKey: type.key) as? Int {
            self.count = count
        }
    }
    
    private func calculationAnswer () {
        let isRightButton = Int.random(in: 1...4)
        var randomAnswer: Int
        var randomAnswerTwo: Int
        var randomAnswerThree: Int
        var randomAnswerFour: Int
        
        repeat {
            randomAnswer = Int.random(in: (answer + 8)...(answer + 9))
            randomAnswerTwo = Int.random(in: (answer + 6)...(answer + 7))
            randomAnswerThree = Int.random(in: (answer + 4)...(answer + 5))
            randomAnswerFour = Int.random(in: (answer + 2)...(answer + 3))
        } while randomAnswer == answer
        
        leftButton.setTitle(isRightButton == 1 ? String(answer) : String(randomAnswer),
                            for: .normal)
        rightButton.setTitle(isRightButton == 2 ? String(answer) : String(randomAnswerTwo),
                            for: .normal)
        bottomLeftButton.setTitle(isRightButton == 3 ? String(answer) : String(randomAnswerThree),
                            for: .normal)
        bottomRightButton.setTitle(isRightButton == 4 ? String(answer) : String(randomAnswerFour),
                            for: .normal)
    }
    
    private func configureQuestion() {
        if type != MathTypes.divide {
            firstNumber = Int.random(in: 1...99)
            secondNumber = Int.random(in: 1...99)
            
            let question: String = "\(firstNumber) \(sign) \(secondNumber) = ?"
            questionLabel.text = question
            configForWordAdmiration()
        }
    }
    
    private func configForWordAdmiration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.wordOfAdmirationLabel.text = ""
            self?.wordOfAdmirationLabel.font = .italicSystemFont(ofSize: 70)
            self?.wordOfAdmirationLabel.backgroundColor = .systemYellow
            self?.wordOfAdmirationLabel.textColor = .blue
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
            let isSecondAttempt = rightButton.backgroundColor == .red || leftButton.backgroundColor == .red || bottomLeftButton.backgroundColor == .red ||
            bottomRightButton.backgroundColor == .red
            count += isSecondAttempt ? 0 : 1
            if isSecondAttempt == true {
                wordOfAdmirationLabel.text = ""
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.configureQuestionDivide()
                self?.configureQuestion()
                self?.calculationAnswer()
                self?.configureButtons()
            }
        }
    }
    
    private func getCount() {
        if type == MathTypes.add {
            sendDataAdd = count
            countLabel.text = "Your current score: \(String(sendDataAdd ?? 0))"
        } else if type == MathTypes.subtract {
            sendDataSubtract = count
            countLabel.text = "Your current score: \(String(sendDataSubtract ?? 0))"
        } else if type == MathTypes.multiply {
            sendDataMultiply = count
            countLabel.text = "Your current score: \(String(sendDataMultiply ?? 0))"
        } else {
            sendDataDivide = count
            countLabel.text = "Your current score: \(String(sendDataDivide ?? 0))"
        }
    }
}

//MARK: Create storage
extension UserDefaults {
    static let container = UserDefaults(suiteName: "conteiner")
}
