import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bruteForceActiviryIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var hackedPasswordLabel: UILabel!
    
    private let handler = BruteForceHandler()
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        var pw = ""
        DispatchQueue.main.async {
            self.resetUI()
            self.bruteForceActiviryIndicator.startAnimating()
            pw = self.handler.generateRandomPasswordTounlock(length: 4)
            self.passwordTextField.text = pw
            
            DispatchQueue.global().async {
                self.bruteForce(passwordToUnlock: pw)
            }
        }
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""
        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = handler.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
        }
        
        DispatchQueue.main.async {
            self.hackedPasswordLabel.text = password
            self.passwordTextField.isSecureTextEntry = false
            self.bruteForceActiviryIndicator.stopAnimating()
            self.bruteForceActiviryIndicator.isHidden = true
        }
    }
    
    func resetUI() {
        self.passwordTextField.isSecureTextEntry = true
        self.hackedPasswordLabel.text = "Hacked password"
        self.bruteForceActiviryIndicator.isHidden = false
    }
}







