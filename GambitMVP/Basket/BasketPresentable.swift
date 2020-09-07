//
//  BasketPresentable.swift
//  GambitMVP
//
//  Created by Асельдер on 07.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit

protocol BasketViewPresentable: class {
    
    var isBasketVisible: Bool { get set }
    
    func openBasket()
}


// Показать / скрыть корзину + Анимация
extension BasketViewPresentable where Self: UIViewController {
    
    func showBasketView() {
        
        // Отслеживаем вызов корзины и не допускаем повторной анимации
        Observer.shared.notify(MenuBasketUD.shared.updateBasketEvent)
        
        guard !isBasketVisible else { return }
        
        self.isBasketVisible = true
        
        // регистрация ниба
        let basketView = UINib(nibName: "Basket", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BasketVC
        
        // конфиг ниба
        basketView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 60)
        basketView.backgroundColor = .clear
        basketView.configure()
        basketView.openBasket = { self.openBasket() }
        
        // показ ниба на всех экранах
        // UIApplication.shared.keyWindow!.addSubview(basketView)
        
        let margin = (view.frame.width - view.frame.width * 0.8) / 2
        
        UIView.animate(withDuration: 0.3, animations: {
            basketView.frame = CGRect(x: margin, y: self.view.frame.height - 60, width: self.view.frame.width * 0.8, height: 52)
            

        })
        
        
//        basketView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 60)
        
//        basketView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        basketView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.addSubview(basketView)
    }
    
    func hideBasketView() {
                
        self.isBasketVisible = false
        
        //Ремов (СабВью - то есть наше вью долбаеба)
        view.subviews.forEach { (subView) in
            
            if (subView.isKind(of: BasketVC.self)) {
                
                UIView.animate(withDuration: 0.3, animations: {
                    subView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 60)
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    subView.removeFromSuperview()
                })
            }
        }
    }
}

