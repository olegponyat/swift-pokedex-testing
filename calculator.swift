import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!

    var firstNumber = 0.0
    var secondNumber = 0.0
    var currentOperation: Operation?

    enum Operation {
        case addition, subtraction, multiplication, division
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let currentNumberText = sender.titleLabel?.text else { return }

        if let currentDisplayText = displayLabel.text, currentDisplayText != "0" {
            displayLabel.text = currentDisplayText + currentNumberText
        } else {
            displayLabel.text = currentNumberText
        }
    }

    @IBAction func operationButtonTapped(_ sender: UIButton) {
        guard let operationString = sender.titleLabel?.text else { return }

        if let displayText = displayLabel.text, let currentNumber = Double(displayText) {
            firstNumber = currentNumber
            displayLabel.text = "0"
            setCurrentOperation(operationString)
        }
    }

    @IBAction func equalsButtonTapped(_ sender: UIButton) {
        if let displayText = displayLabel.text, let secondNumber = Double(displayText) {
            self.secondNumber = secondNumber
            performOperation()
        }
    }

    @IBAction func clearButtonTapped(_ sender: UIButton) {
        displayLabel.text = "0"
        firstNumber = 0.0
        secondNumber = 0.0
        currentOperation = nil
    }

    func setCurrentOperation(_ operationString: String) {
        switch operationString {
        case "+":
            currentOperation = .addition
        case "-":
            currentOperation = .subtraction
        case "x":
            currentOperation = .multiplication
        case "÷":
            currentOperation = .division
        default:
            break
        }
    }

    func performOperation() {
        guard let operation = currentOperation else { return }

        switch operation {
        case .addition:
            displayLabel.text = "\(firstNumber + secondNumber)"
        case .subtraction:
            displayLabel.text = "\(firstNumber - secondNumber)"
        case .multiplication:
            displayLabel.text = "\(firstNumber * secondNumber)"
        case .division:
            if secondNumber != 0 {
                displayLabel.text = "\(firstNumber / secondNumber)"
            } else {
                displayLabel.text = "Error"
            }
        }
    }
} 