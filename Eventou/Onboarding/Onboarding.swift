//
//  ViewController.swift
//  AnimatedPageView
//
//  Created by Alex K. on 12/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import paper_onboarding

class Onboarding: UIViewController {
    
    @IBOutlet var skipButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "CalendarImage")!,
                           title: "Não perca nada!",
                           description: "Veja de forma rápida todos os eventos que estão acontecendo no campus",
                           pageIcon: UIImage(named: "CheckIcon")!,
                           color: UIColor(red: 21/255, green: 208/255, blue: 207/255, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "StarImage")!,
                           title: "Favorite seus eventos",
                           description: "Salve seus eventos favoritos, basta clicar no ícone da bandeira ou em salvar evento",
                           pageIcon: UIImage(named: "StarIcon")!,
                           color: UIColor(red: 1/255, green: 170/255, blue: 196/255, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "PlusImage")!,
                           title: "Crie e divulgue",
                           description: "Crie novos eventos de maneira fácil e rápida, basta clicar em + e não esquecer das tags ;)",
                           pageIcon: UIImage(named: "PlusIcon")!,
                           color: UIColor(red: 0, green: 174/255, blue: 247/255, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "TagImage")!,
                           title: "Escolha suas tags",
                           description: "Elas irão criar uma sessão no seu feed de eventos que combinam com você, mas não se preocupe, você poderá edita-las depois!",
                           pageIcon: UIImage(named: "TagIcon")!,
                           color: UIColor(red: 237/255, green: 217/255, blue: 0, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPaperOnboardingView()
        view.bringSubviewToFront(skipButton)

        
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
            
        }
    }
}

// MARK: Actions

extension Onboarding {
    
    @IBAction func skipButtonTapped(_: UIButton) {
        print(#function)
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        performSegue(withIdentifier: "showNavigation", sender: nil)
    }
}

// MARK: PaperOnboardingDelegate

extension Onboarding: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        //skipButton.isHidden = index == 2 ? false : true
        print("INDEX DO BAGUI: ", index)
        if(index == onboardingItemsCount() - 1){
            skipButton.setTitle("Done", for: .normal)
            skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            
        }else{
            skipButton.setTitle("Skip", for: .normal)
            skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension Onboarding: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
}


//MARK: Constants
extension Onboarding {
    
    private static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}

