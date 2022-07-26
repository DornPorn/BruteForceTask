import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bruteForceActiviryIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var hackedPasswordLabel: UILabel!
    
    // MARK: - Properties
    
    var isCancellationUserInitiated: Bool = false
    var operationQueue = OperationQueue()
    var operation: BruteForceOperation!
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        operation.cancel()
        isCancellationUserInitiated = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        operation = BruteForceOperation()
        var pw = ""
        
        DispatchQueue.main.async {
            self.resetUI()
            self.bruteForceActiviryIndicator.startAnimating()
        }
        
        if let text = self.passwordTextField.text, !text.isEmpty {
            pw = text
        }

        self.operation.updatePw(password: pw)
        self.operation.delegate = self
        self.operationQueue.addOperation(self.operation)
    }
    
    func resetUI() {
        self.passwordTextField.isSecureTextEntry = true
        self.hackedPasswordLabel.text = "Hacked password"
        self.bruteForceActiviryIndicator.isHidden = false
    }
}

// MARK: - Brute force delegate

extension ViewController: BruteForceDelegate {
    func updateLabel(pw: String) {
        self.hackedPasswordLabel.text = pw
    }
    
    func updateUI(password: String, pwToUnlock: String) {
        self.hackedPasswordLabel.text = self.operation.isCancelled && self.isCancellationUserInitiated ? "Password \(pwToUnlock) hasn't been hacked" : password
        self.passwordTextField.isSecureTextEntry = self.operation.isCancelled
        self.bruteForceActiviryIndicator.stopAnimating()
        self.bruteForceActiviryIndicator.isHidden = true
        self.isCancellationUserInitiated = false
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }
}







