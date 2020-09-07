//
//  Observer.swift
//  GambitMVP
//
//  Created by Асельдер on 07.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation

class Observer {
    
    //MARK: - Singleton
    static let shared = Observer()
    
    //MARK: - Method
    
    // Создаем нотификация для создания событий отслеживания
    func notify(_ key: String?, object:AnyObject? = nil) {
        DispatchQueue.main.async {
            if let actualKey = key {
                NotificationCenter.default.post(name: Notification.Name(rawValue: actualKey), object: object)
            }
        }
    }
    
    // Создаем отслеживатель
    func observe(_ observer: AnyObject?, selector: Selector, key: String?) {
        if let actualKey = key  {
            if let actualObserver: AnyObject = observer {
                NotificationCenter.default.addObserver(actualObserver, selector: selector, name: NSNotification.Name(rawValue: actualKey), object: nil)
            }
        }
    }
    
    // Функция удаления обсервера
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
