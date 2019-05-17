//
//  UserTagsViewController.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 29/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class UserTagsViewController: UIViewController {
    
    //MARK: - Variables
    var tags: [String] = []
    
    //MARK: - Outlets
    @IBOutlet weak var gestaoTag: UIButton!
    @IBOutlet weak var modaTag: UIButton!
    @IBOutlet weak var arquiteturaTag: UIButton!
    @IBOutlet weak var saudeTag: UIButton!
    @IBOutlet weak var gastronomiaTag: UIButton!
    @IBOutlet weak var comunicacaoTag: UIButton!
    @IBOutlet weak var arteTag: UIButton!
    @IBOutlet weak var hotelariaTag: UIButton!
    @IBOutlet weak var tecnologiaTag: UIButton!
    @IBOutlet weak var meioAmbienteTag: UIButton!
    @IBOutlet weak var fotografiaTag: UIButton!
    @IBOutlet weak var designTag: UIButton!
    @IBOutlet weak var tiTag: UIButton!
    @IBOutlet weak var esportesTag: UIButton!
    
    
    //MARK: - Actions
    @IBAction func clickedGestao(_ sender: Any) {
        tagChooser(button: gestaoTag)
    }
    @IBAction func clickedModa(_ sender: Any) {
        tagChooser(button: modaTag)
    }
    @IBAction func clickedArquitetura(_ sender: Any) {
        tagChooser(button: arquiteturaTag)
    }
    @IBAction func clickedSaude(_ sender: Any) {
        tagChooser(button: saudeTag)
    }
    @IBAction func clickedGastronomia(_ sender: Any) {
        tagChooser(button: gastronomiaTag)
    }
    @IBAction func clickedComunicacao(_ sender: Any) {
        tagChooser(button: comunicacaoTag)
    }
    @IBAction func clickedArte(_ sender: Any) {
        tagChooser(button: arteTag)
    }
    @IBAction func clickedHotelaria(_ sender: Any) {
        tagChooser(button: hotelariaTag)
    }
    @IBAction func clickedTecnologia(_ sender: Any) {
        tagChooser(button: tecnologiaTag)
    }
    @IBAction func clickedMeioAmbiente(_ sender: Any) {
        tagChooser(button: meioAmbienteTag)
    }
    @IBAction func clickedFotografia(_ sender: Any) {
        tagChooser(button: fotografiaTag)
    }
    @IBAction func clickedDesign(_ sender: Any) {
        tagChooser(button: designTag)
    }
    @IBAction func clickedTi(_ sender: Any) {
        tagChooser(button: tiTag)
    }
    @IBAction func clickedEsportes(_ sender: Any) {
        tagChooser(button: esportesTag)
    }
    
    
    
    @IBAction func salvarTags(_ sender: Any){
        UserCoreData.init().deleteAllTags()
        UserCoreData.init().addTagsToUser(tags: tags)
        performSegue(withIdentifier: "unwindToProfile", sender: self)
    }
    
    //MARK: - Custom Methods
    
    func tagChooser(button: UIButton){
        let selectedTag = button.titleLabel!.text!
        if self.tags.contains(selectedTag) {
            let index = tags.index(of: selectedTag)
            tags.remove(at: index!)
            button.backgroundColor = #colorLiteral(red: 0.6251067519, green: 0.6256913543, blue: 0.6430284977, alpha: 1)
        }
        else {
            tags.append(selectedTag)
            button.backgroundColor = #colorLiteral(red: 0.9447152615, green: 0.8682671785, blue: 0, alpha: 1)
        }
    }
}
