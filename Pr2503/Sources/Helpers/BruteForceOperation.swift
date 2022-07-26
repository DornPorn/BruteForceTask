//
//  BruteForceOperation.swift
//  Pr2503
//
//  Created by Stanislav Rassolenko on 7/25/22.
//

import Foundation

// MARK: - BruteForceDelegate

protocol BruteForceDelegate: AnyObject {
    func updateLabel(pw: String)
    func updateUI(password: String, pwToUnlock: String)
}

class BruteForceOperation: Operation {
    
    // MARK: - Properties
    
    var pw: String = ""
    weak var delegate: BruteForceDelegate?
    
    func updatePw(password: String) {
        self.pw = password
    }
    
    // MARK: - Main
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        bruteForce(passwordToUnlock: pw)
    }
    
    // MARK: - Brute force
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""
        let pwArrayToUnlock = passwordToUnlock.intoArray(interval: 2)
        
        // Takes 1-3 seconds to find the password of any length and complexity
        while password != passwordToUnlock {
            for i in 0..<pwArrayToUnlock.count {
                var newPw = ""
                while newPw != pwArrayToUnlock[i] {
                    newPw = generateBruteForce(newPw, fromArray: ALLOWED_CHARACTERS)
                    DispatchQueue.main.async {
                        self.delegate?.updateLabel(pw: newPw)
                    }
                }
                password.append(newPw)
                DispatchQueue.main.async {
                    self.delegate?.updateLabel(pw: password)
                }
            }
            DispatchQueue.main.async {
                self.delegate?.updateLabel(pw: password)
            }
        }
        DispatchQueue.main.async {
            self.delegate?.updateUI(password: password, pwToUnlock: passwordToUnlock)
        }
        self.cancel()
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1, with: characterAt(index: (indexOf(character: str.last ?? Character(""), array) + 1) % array.count, array))

            if indexOf(character: str.last ?? Character(""), array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last ?? Character(""))
            }
        }
        return str
    }
    
    // Generate random password string (this task uses user input)
    func generateRandomPasswordTounlock(length: Int) -> String {
        let letters = String().printable
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
