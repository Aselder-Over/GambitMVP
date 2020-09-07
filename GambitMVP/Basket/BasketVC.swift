//
//  BasketVC.swift
//  GambitMVP
//
//  Created by Асельдер on 07.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit

class BasketVC: UIView {

//    @IBOutlet weak var basketTitleLabel: UILabel!
    @IBOutlet weak var priceBasketLabel: UILabel!
    @IBOutlet weak var countDishLabel: UILabel!
    
    private var currentItem: MenuItem?
    
    // ввключает настройки фрейма в конфигурации ниба
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // - хз
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // открывает корзину Делегат написать на нужном контроллере
    var openBasket: (() -> Void)?
    
    // отлавливает нажатие и инициализирует слушаетель (Сендер)
    func configure() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToBasket)))
        Observer.shared.observe(self, selector: #selector(updateData), key: MenuBasketUD.shared.updateBasketEvent)
        updateData()
    }
    
    // - доступ к навигейшн контроллеру
    @objc func goToBasket() {
        openBasket?()
    }
    
    // - Будет обновлять цену и название рестоарана0
    @objc func updateData() {
        priceBasketLabel.text = String(MenuBasketUD.shared.countAllPrice()) + " ₽"
        
        let itemInCard = MenuBasketUD.shared.countItems()
        
    
        countDishLabel.text = String(itemInCard)
        
    }

}
