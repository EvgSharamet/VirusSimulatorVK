//
//  StartScreen.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 09.05.2023.
//

import Foundation
import UIKit

class StartScreenController: UIViewController {
    let humansTextField = UITextField()
    let forceOfInfectionTextField = UITextField()
    let timeTextField = UITextField()
    let startButton = UIButton()
    let out: ((EpidemicService) -> Void)
    
    private let numbersRegex = try! NSRegularExpression(pattern: "^[0-9]*$", options: [])
    private let notZeroHumansRegex = try! NSRegularExpression(pattern: "^[1-9][0-9]*$", options: [])
    
    init(out: @escaping (EpidemicService) -> Void) {
        self.out = out
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemIndigo
        hideKeyboardWhenTappedAround()
        setup()
    }
    
    func setup()  {
        // MARK: - Stack
        let stack = UIStackView()
        self.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 230).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        
        //MARK: - Humans text field
        stack.addArrangedSubview(humansTextField)
        humansTextField.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        humansTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        humansTextField.textAlignment = .center
        humansTextField.layer.masksToBounds = true
        humansTextField.layer.cornerRadius = 10
        humansTextField.placeholder = "Enter humans"
        humansTextField.textContentType = .creditCardNumber
        humansTextField.backgroundColor = .systemMint
        
        //MARK: - // force of infection text field
        stack.addArrangedSubview(forceOfInfectionTextField)
        forceOfInfectionTextField.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        forceOfInfectionTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        forceOfInfectionTextField.textAlignment = .center
        forceOfInfectionTextField.layer.masksToBounds = true
        forceOfInfectionTextField.layer.cornerRadius = 10
        forceOfInfectionTextField.textContentType = .creditCardNumber
        forceOfInfectionTextField.placeholder = "Enter force of infection"
        forceOfInfectionTextField.backgroundColor = .systemMint
        
        //MARK: - // time text field
        stack.addArrangedSubview(timeTextField)
        timeTextField.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        timeTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeTextField.textAlignment = .center
        timeTextField.layer.masksToBounds = true
        timeTextField.layer.cornerRadius = 10
        timeTextField.textContentType = .creditCardNumber
        timeTextField.placeholder = "Enter time"
        timeTextField.backgroundColor = .systemMint
        
        //MARK: - // Start Button
        stack.addArrangedSubview(startButton)
        startButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        startButton.setTitle("Start", for: .normal)
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 10
        startButton.backgroundColor = .darkGray
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    func checkinText(input: String?) -> Bool {
        guard let input = input, !input.isEmpty else { return false }
        let matches = self.numbersRegex.matches(in: input, options: [], range: NSRange(location:0, length: input.count))
        
        if matches.isEmpty {
            return false
        }
        return true
    }
    
    func checkinHumans(input: String?) -> Bool {
        guard let input = input, !input.isEmpty else { return false }
        let matches = self.notZeroHumansRegex.matches(in: input, options: [], range: NSRange(location:0, length: input.count))
        
        if matches.isEmpty {
            return false
        }
        return true
    }
    
    func checkInput() ->  Bool {
        if checkinText(input: humansTextField.text) &&
            checkinHumans(input: humansTextField.text) &&
            checkinText(input: forceOfInfectionTextField.text) &&
            checkinText(input: timeTextField.text) {
            startButton.backgroundColor = .systemPink
            return true
        }
        startButton.backgroundColor = .darkGray
        return false
    }
    
    @objc func startButtonTapped() {
        guard let humans = Int(humansTextField.text ?? ""),
              let force = Int(forceOfInfectionTextField.text ?? ""),
              let time = Int(timeTextField.text ?? "") else
        {
            return
        }
        
        if checkInput() {
            let service = EpidemicService(count: humans, m_infectiousness: force, time: time)
            out(service)
        }
    }
}

extension StartScreenController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        _ = self.checkInput()
    }
}
