//
//  DishCell.swift
//  GambitMVP
//
//  Created by Асельдер on 02.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit
import SDWebImage

protocol DishCellButtonsProtocol {
    func inBaketButtonAction(index: Int, senderCell: DishCell)
    func plusFunc(index: Int, senderCell: DishCell)
    func minusFunc(index: Int, senderCell: DishCell)
}

class DishCell: UITableViewCell {
    
    
    // Outlet
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var contentDishView: UIView!
    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var inBasketView: UIView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var priceCountLabel: UILabel!
    @IBOutlet weak var inBasketButton: UIButton!
    
    
    
    var delegate: DishCellButtonsProtocol?
    var index: IndexPath?
    
    // Заполнение ячейки данными
    func setData(item: MenuItem, delegate: DishCellButtonsProtocol) {
        let imageURL = item.image
        
        self.delegate = delegate
        self.dishImage.sd_setImage(with: URL(string: imageURL), completed: nil)
        self.nameDishLabel.text = item.name
        self.priceLabel.text = String(item.price) + " ₽"
        
        if MenuBasketUD.shared.isAddedToCart(item: item) {
            let countInCart = MenuBasketUD.shared.checkCount(item: item)
            if countInCart > 0 {
                self.priceCountLabel.text = String(countInCart)
                hideCardButton()
            } else {
                showCardButton()
            }
        } else {
            showCardButton()
        }
    }
    
    func showCardButton() { inBasketButton.isHidden = false }
    func hideCardButton() { inBasketButton.isHidden = true  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func inBaketButtonAction(_ sender: Any) {
        inBasketButton.isHidden = true
        delegate?.plusFunc(index: index!.row, senderCell: self)
    }
    
    @IBAction func plusAction(_ sender: Any) {
        delegate?.plusFunc(index: index!.row, senderCell: self)
    }
    @IBAction func minusAction(_ sender: Any) {
        delegate?.minusFunc(index: index!.row, senderCell: self)
    }
}
