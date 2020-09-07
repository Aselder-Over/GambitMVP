//
//  UserDefaults.swift
//  GambitMVP
//
//  Created by Асельдер on 04.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation

struct BasketUD: Codable {
    var menuItem: MenuItem
    var countInCart: Int
}


final class MenuBasketUD {
    
    let showBasketEvent   = "SHOW_BASKET"
    let hideBasketEvent   = "HIDE_BASKET"
    let updateBasketEvent = "UPDATE_BASKET"
    
    
    static let shared = MenuBasketUD()
    
    private let key = "GAMBIT_KEY"
    private var menu: [BasketUD] = [] {
        didSet {
            // Когда записывается или удаляется один объект из ЮД то
            if (menu.isEmpty) {
                // Зарегай нотификацию хайд баскет
                Observer.shared.notify(hideBasketEvent, object: nil)
            } else {
                // Зарегай нотификацию шов баскет
                Observer.shared.notify(showBasketEvent, object: nil)
            }
        }
    }
    
    private let keyFav = "FAV_KEY"
    private var favInDB: [MenuItem] = []
    
    private init() {
        guard
            
        let data = UserDefaults.standard.data(forKey: key),
        let menuFromDataBase = try? JSONDecoder().decode([BasketUD].self, from: data),
        
        let favData = UserDefaults.standard.data(forKey: keyFav),
        let favFromDB = try? JSONDecoder().decode([MenuItem].self, from: favData)
        
        else { return }
        
        menu.append(contentsOf: menuFromDataBase)
        favInDB.append(contentsOf: favFromDB)
    }
    
    // Проверка на нахождение в ЮД
    func isAddedToCart(item: MenuItem?) -> Bool {
        print(menu)
        print(item)
        if let _ = menu.firstIndex(where: { $0.menuItem.id == item?.id } ) {
            return true
        } else {
            return false
        }
    }
    
    // Добавление и увеличение колличества
    func addToCart(item: MenuItem) -> Int {
        if let index = menu.firstIndex(where: { $0.menuItem.id == item.id } ) {
            menu[index].countInCart += 1
            synchronize()
            return menu[index].countInCart
        } else {
            let newItem = BasketUD(menuItem: item, countInCart: 1)
            menu.append(newItem)
            synchronize()
            return 1
        }
    }
    
    // Проверка количества
    func checkCount(item: MenuItem) -> Int {
        if let index = menu.firstIndex(where: { $0.menuItem.id == item.id } ) {
            let countInCart = menu[index].countInCart
            return countInCart
        } else {
            return 0
        }
    }
    
    // Проверка и удаление записи
    func removeFromCart(item: MenuItem) -> Int {
        if let index = menu.firstIndex(where: { $0.menuItem.id == item.id } ) {
            if menu[index].countInCart > 1 {
                menu[index].countInCart -= 1
                synchronize()
                return menu[index].countInCart
            } else {
                menu.remove(at: index)
                synchronize()
                return 0
            }
        } else {
            return 0
        }
    }
    
    // Очистка
    func clear() {
        menu.removeAll()
        synchronize()
    }
    
    // Проверка отображения корзины
    func showBasket() -> Bool {
        if menu.count > 0 {
            return true
        } else {
            return false
        }
    }

    
    // Обновление данных
    private func synchronize() {
        guard
            let menu = try? JSONEncoder().encode(menu),
            let favItems = try? JSONEncoder().encode(favInDB)
            else { return }
        UserDefaults.standard.set(menu, forKey: key)
        UserDefaults.standard.set(favItems, forKey: keyFav)
    }
    
    // Подсчет общей суммы корзины
    func countAllPrice() -> Int {
        var allPrice = 0
        for i in menu {
            let count = i.countInCart
            let price = i.menuItem.price
            allPrice += count * price
        }
        return allPrice
    }
    
    // Подсчет количества позиций в корзине
    func countItems() -> Int {
        return menu.count
    }
    
//     MARK: - favorite
    
//     Проверка на нахождение в избранном
    func isFavorite(item: MenuItem) -> Bool {
        if let _ = favInDB.firstIndex(where: { $0.id == item.id}) {
            return true
        } else {
            return false
        }
    }
    
    // Добавление и удаление из избранного
    func addOrRemoveFavorite(item: MenuItem) -> Bool {
        if let index = favInDB.firstIndex(where: { $0.id == item.id}) {
            favInDB.remove(at: index)
    
            //обновление данных юзерфалс
            synchronize()
            return false
        } else {
            favInDB.append(item)
            synchronize()
            return true
        }
    }
    
}
