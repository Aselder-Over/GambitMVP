//
//  MenuViewProtocol.swift
//  GambitMVP
//
//  Created by Асельдер on 03.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation
import UIKit

protocol MenuViewProtocol {
    func setMenuItems(items: [MenuItem])
    func showLoading()
    func hideLoading()
}

extension MenuVC: MenuViewProtocol {
    func setMenuItems(items: [MenuItem]) {
        menuItems.append(contentsOf: items)
    }

    func showLoading() {
        self.dishTable.separatorStyle = .none
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
    }

    func hideLoading() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }

}

extension MenuVC: DishCellButtonsProtocol {
    func inBaketButtonAction(index: Int, senderCell: DishCell) {
        let countInCard =  MenuBasketUD.shared.addToCart(item: menuItems[index])
        if countInCard > 0 {
            senderCell.priceCountLabel.text = String(countInCard)
            senderCell.hideCardButton()
        }
    }
    
    func plusFunc(index: Int, senderCell: DishCell) {
        let countInCard =  MenuBasketUD.shared.addToCart(item: menuItems[index])
        if countInCard > 0 {
            senderCell.priceCountLabel.text = String(countInCard)
        }
    }
    
    func minusFunc(index: Int, senderCell: DishCell) {
        let countInCard =  MenuBasketUD.shared.removeFromCart(item: menuItems[index])
        if countInCard > 0 {
            senderCell.priceCountLabel.text = String(countInCard)
        } else {
            senderCell.showCardButton()
        }
    }
    
    
}
    
