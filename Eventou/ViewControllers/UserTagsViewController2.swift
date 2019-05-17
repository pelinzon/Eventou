//
//  UserTagsViewController.swift
//  Jardim Apura
//
//  Created by Lucas Pelinzon on 29/10/18.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class UserTagsViewController2: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var tagsFlowLayout: UICollectionViewFlowLayout!
    
    let userCoreData = UserCoreData()
    var tags: [String] = []
    
    override func viewDidLoad() {
        tags = userCoreData.loadTags()
        
        tagsCollectionView.layer.cornerRadius = 7
        tagsFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        
        if(tags.count == 0){
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        }
    }
    
    @objc func doneTapped(){
        userCoreData.deleteAllTags()
        userCoreData.addTagsToUser(tags: tags)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gastronomia", for: indexPath)
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Comunicação", for: indexPath)
        case 2:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hotelaria", for: indexPath)
        case 3:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gestão", for: indexPath)
        case 4:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Design", for: indexPath)
        case 5:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Arquitetura", for: indexPath)
        case 6:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Moda", for: indexPath)
        case 7:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cinema", for: indexPath)
        case 8:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Música", for: indexPath)
        case 9:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Arte", for: indexPath)
        case 10:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fotografia", for: indexPath)
        case 11:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tecnologia", for: indexPath)
        case 12:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Meio Ambiente", for: indexPath)
        case 13:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Saúde", for: indexPath)
        case 14:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Esportes", for: indexPath)
        case 15:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TI", for: indexPath)
            
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gastronomia", for: indexPath)

        }
        cell.layer.cornerRadius = 7
        
        let tagName = cell.reuseIdentifier!
        if(tags.contains(tagName)){
            cell.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let cell = collectionView.cellForItem(at: indexPath)!
        
        if(!tags.contains(cell.reuseIdentifier!)){
            cell.backgroundColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            tags.append(cell.reuseIdentifier!)
        }else{
            cell.backgroundColor = UIColor(red: 21/255, green: 208/255, blue: 207/255, alpha: 1)
            tags.index(of: cell.reuseIdentifier!).map { tags.remove(at: $0) }
        }
        
        //checagem para o done
        if(tags.count >= 1){
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }else{
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        }
        
    }
    
    
    //função que define o tamanho das células como auto-layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Compute the dimension of a cell for an NxN layout with space S between
        // cells.  Take the collection view's width, subtract (N-1)*S points for
        // the spaces between the cells, and then divide by N to find the final
        // dimension for the cell's width and height.
        
        let cellsAcross: CGFloat = 2
        let spaceBetweenCells: CGFloat = 6
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim - 7, height: 97)
    }
    
    
    
    
}
