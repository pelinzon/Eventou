//
//  LoginViewController.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
// Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate, GIDSignInDelegate {
    
    //MARK: - Variables
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let googleButton = GIDSignInButton()
    var segueBefore = ""
    
    //MARK: - Outlets
    @IBOutlet weak var loginGoogle: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpText: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Actions
    @IBAction func clickLoginEmail(){
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign in Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default ))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func clickSignUp(){
        self.performSegue(withIdentifier: "showSignUp", sender: nil)
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleButton()
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        // Define os delegates das TextFields
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Faz com que o teclado seja escondido ao tocar fora da TextField selecionada
        hideKeyboardWhenTappedAround()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
        
        loginButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        loginButton.layer.shadowOpacity = 1.0
        loginButton.layer.shadowRadius = 20.0
        loginButton.layer.masksToBounds = false
        
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    //MARK: - Custom Methods
    func showActivityIndicatory() {
        activityIndicator.center = CGPoint(x: view.frame.width / 2, y: 295)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = #colorLiteral(red: 0.9844431281, green: 0.9844661355, blue: 0.9844536185, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    
    // Função utilizada para esconder o teclado quando o usuário apertar Return/Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Elevar a UIView para que o keyboard nao cubra o textfield

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                
            }
        }
    }
    
    
    fileprivate func setupGoogleButton() {
        googleButton.frame = CGRect(x: 30, y: 275, width: view.frame.width - 60, height: 41)
        view.addSubview(googleButton)
        
        //googleButton.removeFromSuperview()
        //googleButton.add
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        // Inicia uma thread para verificar se o usuário está logado. Ao realizar o login, finaliza a thread realiza um unwind para o ProfileViewController.
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { thread in
            if Auth.isLoggedIn() {
                if(self.segueBefore == "showFeedToLogin"){
                    self.performSegue(withIdentifier: "showLoginToNewEvent", sender: self)
                }else{
                    self.performSegue(withIdentifier: "unwindToProfile", sender: self)
                }
                
                thread.invalidate()
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        } else {
            googleButton.isHidden = true
            showActivityIndicatory()
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {thread in
                if(Auth.isLoggedIn() == true){
                    print("LOGOU")
                    
                    let firebaseUser = FirebaseUser()
                    let id = Auth.auth().currentUser?.uid
                    let completeName = Auth.auth().currentUser?.displayName
                    let photoURL = Auth.auth().currentUser?.photoURL?.absoluteString
                    let email = Auth.auth().currentUser?.email
                    
                    let user = User(id: id!, completeName: completeName!, photoURL: photoURL! ,email: email!)
                    
                    firebaseUser.getUserById(id: id!){userWrapped in
                        let userFirebase = userWrapped!
                        let userBlackList = userFirebase.userBlackList
                        let eventBlackList = userFirebase.eventBlackList
                        
                        user.userBlackList = userBlackList
                        user.eventBlackList = eventBlackList
                        
                        firebaseUser.saveUser(user: user)
                        
                        self.activityIndicator.stopAnimating()
                        thread.invalidate()
                    }
                }
                print("TA LOGANDO")
            })
        }
        
        print("Successfully logged into Google", user.profile.name)
        guard let idToken = user.authentication.idToken, let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
                
            }
            guard let uid = user?.user.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
        }
        
    }
}


