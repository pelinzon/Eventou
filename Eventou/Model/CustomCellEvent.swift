//
//  CustomCellEvent.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 08/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class CustomCellEvent: UITableViewCell {

    @IBOutlet weak var eventMonth: UILabel!
    @IBOutlet weak var eventDay: UILabel!
    @IBOutlet weak var eventHours: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var setEventFavoriteIcon: UIImageView!
    @IBOutlet weak var dateBackground: UIView!
    var idEventClicked = ""
    var rotated = false
    var event: Event?
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        dateBackground.layer.cornerRadius = 10
        
        createTapRecognizer()
    }
    
    func createTapRecognizer(){
        var tapRecognizer: UITapGestureRecognizer
        
        setEventFavoriteIcon.isUserInteractionEnabled = true
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveButtonClick))
        setEventFavoriteIcon.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func saveButtonClick(){
        let eventCoreData = EventCoreData()
            if(self.setEventFavoriteIcon.image == UIImage(named: "frame_00001")){
                var frameNumber = 5
                
                //Animação
                Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: {thread in
                    self.setEventFavoriteIcon.image = UIImage(named: "frame_" + String(format: "%05d", frameNumber))
                    
                    frameNumber += 1
                    if(frameNumber == 27){
                        thread.invalidate()
                    }
                })
                eventCoreData.saveEvent(event: event!)
            }
            else{
                self.setEventFavoriteIcon.image = UIImage(named:"frame_00001")
                eventCoreData.deleteSavedEvent(id: event!.id)
            }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
