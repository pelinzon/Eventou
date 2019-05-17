//
//  AddEventViewController.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddEventViewController: UITableViewController, UITextFieldDelegate {

    //MARK: - Variables
    var event: Event?
    var firebaseEvent = FirebaseEvent()
    var tags: [String] = []
    var datePickerIndexPath: IndexPath?
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var linkLabel: UITextField!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var idata: UILabel!
    @IBOutlet weak var edata: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var errorTagLabel: UILabel!
    
    // Tag Outlets
    
    @IBOutlet weak var gestaoTag: UIButton!
    @IBOutlet weak var meioAmbienteTag: UIButton!
    @IBOutlet weak var arquiteturaTag: UIButton!
    @IBOutlet weak var comunicacaoTag: UIButton!
    @IBOutlet weak var gastronomiaTag: UIButton!
    @IBOutlet weak var hotelariaTag: UIButton!
    @IBOutlet weak var designTag: UIButton!
    @IBOutlet weak var tiTag: UIButton!
    @IBOutlet weak var saudeTag: UIButton!
    @IBOutlet weak var fotografiaTag: UIButton!
    @IBOutlet weak var esportesTag: UIButton!
    @IBOutlet weak var modaTag: UIButton!
    @IBOutlet weak var arteTag: UIButton!
    @IBOutlet weak var tecnologiaTag: UIButton!
    
    //MARK: - Actions
    
    @IBAction func clickedGestao(_ sender: Any) {
        tagChooser(button: gestaoTag)
    }
    
    @IBAction func clickedMeioAmbiente(_ sender: Any) {
        tagChooser(button: meioAmbienteTag)
    }
    
    @IBAction func clickedArquitetura(_ sender: Any) {
        tagChooser(button: arquiteturaTag)
    }
    
    @IBAction func clickedComunicacao(_ sender: Any) {
        tagChooser(button: comunicacaoTag)
    }
    
    @IBAction func clickedGastronomia(_ sender: Any) {
        tagChooser(button: gastronomiaTag)
    }
    
    @IBAction func clickedHotelaria(_ sender: Any) {
        tagChooser(button: hotelariaTag)
    }
    
    @IBAction func clickedDesign(_ sender: Any) {
        tagChooser(button: designTag)
    }
    
    @IBAction func clickedTi(_ sender: Any) {
        tagChooser(button: tiTag)
    }
    
    @IBAction func clickedSaude(_ sender: Any) {
        tagChooser(button: saudeTag)
    }
    
    @IBAction func clickedFotografia(_ sender: Any) {
        tagChooser(button: fotografiaTag)
    }
    
    @IBAction func clickedEsportes(_ sender: Any) {
        tagChooser(button: esportesTag)
    }
    
    @IBAction func clickedModa(_ sender: Any) {
        tagChooser(button: modaTag)
    }
    
    @IBAction func clickedArte(_ sender: Any) {
        tagChooser(button: arteTag)
    }
    
    @IBAction func clickedTecnologia(_ sender: Any) {
        tagChooser(button: tecnologiaTag)
    }

    
    @IBAction func defineEventImage(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster ?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: {(action: UIAlertAction)in
                self.selectPicture(sourceType: .camera)
                
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) {(action: UIAlertAction)in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        startDateLabel.text = DateFormatter.localizedString(from: startDatePicker.date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        
        // Verifica se a data de ínicio é futura à data de início
        if startDatePicker.date > endDatePicker.date {
            startDateLabel.textColor = UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)
        }
        else {
            startDateLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            endDateLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    @IBAction func endDateChanged(_ sender: Any) {
        endDateLabel.text = DateFormatter.localizedString(from: endDatePicker.date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        
        // Verifica se a data de ínicio é futura à data de início
        if startDatePicker.date > endDatePicker.date {
            endDateLabel.textColor = UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)
        }
        else {
            startDateLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            endDateLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Esconde os labels de erro
        errorTagLabel.isHidden = true
  
        // Define os delegates das TextFields
        self.titleLabel.delegate = self
        self.descriptionLabel.delegate = self
        self.locationLabel.delegate = self
        
        // Faz com que o teclado seja escondido ao tocar fora da TextField selecionada
        hideKeyboardWhenTappedAround()
        
        // Define as propriedades dos pickers
        startDatePicker.date = NSDate() as Date
        startDateLabel.text = "Hoje"
        endDateLabel.text = "Hoje"
        startDatePicker.isHidden = true
        endDatePicker.isHidden = true
        
        // Adiciona o botão de criar um novo evento
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Criar", style: .done, target: self, action: #selector(createEvent))
    }
    
    //MARK: - Custom Methods
    @objc func createEvent(){
        if(errorHandler() == true){
            return
        }
        
        
        //Mandando a data padrão ISO para o Firebase
        let ISODateFormat = ISO8601DateFormatter()
        let today = Date()
        
        let startDateISO = ISODateFormat.string(from: startDatePicker.date)
        let endDateISO = ISODateFormat.string(from: endDatePicker.date)
        let postDateISO = ISODateFormat.string(from: today)
        
        event = Event(title: titleLabel.text!, image: eventImage.image!, idCreator: "", description: descriptionLabel.text!, date: postDateISO, location: locationLabel.text!, startingTime: startDateISO, endingTime: endDateISO, tags: tags)
        
        event?.idCreator = (Auth.auth().currentUser?.uid)!
        event?.location = locationLabel.text!
        event?.link = linkLabel.text!
        
        firebaseEvent.addEvent(event: event!)
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    func errorHandler() -> Bool{
        var error: Bool = false
        
        if(titleLabel.text == ""){
            titleLabel.text = "*É obrigatório colocar um título"
            titleLabel.textColor = UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)
            error = true
            titleLabel.addAction(for: .editingDidBegin, {
                self.titleLabel.text = ""
                self.titleLabel.textColor = UIColor.darkText
                self.titleLabel.removeTarget(nil, action: nil, for: .allEvents)
            })
        }
        else if(titleLabel.text!.count >= 25){
            titleLabel.text = "*Não pode mais de 25 caracteres"
            titleLabel.textColor = UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)
            error = true
            titleLabel.addAction(for: .editingDidBegin, {
                self.titleLabel.text = ""
                self.titleLabel.textColor = UIColor.darkText
                self.titleLabel.removeTarget(nil, action: nil, for: .allEvents)
            })
        }
        if(descriptionLabel.text == ""){
            descriptionLabel.text = "*É obrigatório preencher este campo"
            descriptionLabel.textColor = UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)
            descriptionLabel.addAction(for: .editingDidBegin, {
                self.descriptionLabel.text = ""
                self.descriptionLabel.textColor = UIColor.darkText
                self.descriptionLabel.removeTarget(nil, action: nil, for: .allEvents)
            })
            error = true
        }
        if(locationLabel.text == ""){
            locationLabel.text = "*É obrigatório preencher este campo"
            locationLabel.textColor = UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)
            locationLabel.addAction(for: .editingDidBegin, {
                self.locationLabel.text = ""
                self.locationLabel.textColor = UIColor.darkText
                self.locationLabel.removeTarget(nil, action: nil, for: .allEvents)
            })
            error = true
        }
        if(linkLabel.text == ""){
            linkLabel.text = "*É obrigatório preencher este campo"
            linkLabel.textColor = UIColor(displayP3Red: 202/255, green: 9/255, blue: 33/255, alpha: 1)
            linkLabel.addAction(for: .editingDidBegin, {
                self.linkLabel.text = ""
                self.linkLabel.textColor = UIColor.darkText
                self.linkLabel.removeTarget(nil, action: nil, for: .allEvents)
            })
            error = true
        }
        if(startDateLabel.textColor == UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)){
            startDateLabel.text = "*Insira uma data válida"
        }
        if(endDateLabel.textColor == UIColor(red: 202/255, green: 9/255, blue: 33/255, alpha: 1)){
            endDateLabel.text = "*Insira uma data válida"
        }
        
        if(eventImage.image == UIImage(named: "cameraImage")){
            error = true
        }
        if(tags.isEmpty){
            errorTagLabel.isHidden = false
            error = true
        }
        
        
        return error
    }
    
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
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - TableView Necessary Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 6 {
            let height:CGFloat = startDatePicker.isHidden ? 0.0 : 216.0
            return height
        }
        else if indexPath.section == 0 && indexPath.row == 8 {
            let height:CGFloat = endDatePicker.isHidden ? 0.0 : 216.0
            return height
        }

        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dobIndexPath = NSIndexPath(row: 5, section: 0)
        let startIndexPath = NSIndexPath(row: 7, section: 0)
        
        if dobIndexPath as IndexPath == indexPath {
            startDatePicker.isHidden = !startDatePicker.isHidden
            if(endDatePicker.isHidden == false){
                endDatePicker.isHidden = true
            }
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            })
        }
        else if startIndexPath as IndexPath == indexPath{
            endDatePicker.isHidden = !endDatePicker.isHidden
            if(startDatePicker.isHidden == false){
                startDatePicker.isHidden = true
            }
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            })
        }
    }
    
    //MARK: - Default Methods
    // Esconde o teclado quando o usuário apertar Return/Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AddEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        eventImage.image = image
        dismiss(animated: true, completion: nil)
    }
}
