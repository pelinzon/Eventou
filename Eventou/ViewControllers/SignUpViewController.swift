//
//  SignUpViewController.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Variables
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retryPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    //MARK: - Actions
    @IBAction func SignUp(_ sender: Any) {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: { (user, error) in
            if error == nil {
                Auth.auth().signIn(withEmail: emailText, password: passwordText)
                
                //chamando changeRequest para colocar displayName e URLPhoto
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.nameTextField.text!
                
                changeRequest?.commitChanges(completion: {error in
                    if let error = error{
                        //error to update profile
                        print("ERRO AO MODIFICAR USUÁRIO")
                    }else{
                        //profile updated
                        print("USUARIO MODIFICADO COM SUCESSO")
                    }
                })
                
                //Salvando usuario no Firebase Database
                let id = Auth.auth().currentUser?.uid
                let completeName = self.nameTextField.text
                let photoURL = "default"
                let email = self.emailTextField.text
                
                let user = User(id: id!, completeName: completeName!, photoURL: photoURL, email: email!)
                
                let firebaseUser = FirebaseUser()
                firebaseUser.saveUser(user: user)
            }
            else{
                print(error ?? "An unspecified error has occurred.")
            }
        })
    }
    
    //MARK: - Custom Methods
//    func showActivityIndicatory() {
//        self.activityIndicator.center = self.view.center
//        self.activityIndicator.hidesWhenStopped = true
//        self.activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
//        self.activityIndicator.color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//        self.view.addSubview(activityIndicator)
//        se.factivityIndicator.startAnimating()
//    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Define os delegates das TextFields
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.retryPasswordTextField.delegate = self
        
        // Faz com que o teclado seja escondido ao tocar fora da TextField selecionada
        hideKeyboardWhenTappedAround()
        
        nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        retryPasswordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        // Faz com que o textField nao seja coberto pelo keyboard
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Define o gradiente da view utilizada como background
        var gl:CAGradientLayer!
        let colorTop = UIColor(red: 21.0 / 255.0, green: 208.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.0 / 255.0, green: 174.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0).cgColor
        
        gl = CAGradientLayer()
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.0, 1.0]
        
        
        backgroundView.backgroundColor = UIColor.clear
        let backgroundLayer = gl
        backgroundLayer?.frame = backgroundView.frame
        backgroundView.layer.insertSublayer(backgroundLayer!, at: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    //MARK: - Custom Methods
    // Função utilizada para esconder o teclado quando o usuário apertar Return/Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Elevar a UIView para que o keyboard nao cubra o textfield
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 200
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 200
                
            }
        }
    }
}
