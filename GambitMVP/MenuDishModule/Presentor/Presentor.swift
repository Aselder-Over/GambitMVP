//
//  Presentor.swift
//  GambitMVP
//
//  Created by Асельдер on 02.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation
import Alamofire

protocol MenuPresenterProtocol {
//    var itemsArray: [MenuItem]? {get set}
    
    func getMenuItems()
    
    init(view: MenuViewProtocol)
}

class MenuPresenter: MenuPresenterProtocol {
    
    // MARK: - init
    
    required init (view: MenuViewProtocol) {
        self.view = view
        getMenuItems()
    }

    // MARK: - getItems
    
    var view: MenuViewProtocol?
    
//    var itemsArray: [MenuItem]?
    
    func getMenuItems() {
        self.view?.showLoading()
        AF.request("https://api.gambit-app.ru/category/39?page=1").responseData { response in
            switch response.result {
            case .success(let resultJSON):
                print(resultJSON)
                let resultArray = try? JSONDecoder().decode([MenuItem].self, from: resultJSON)
                print(resultArray ?? "resultArray = nil")
                self.view?.setMenuItems(items: resultArray ?? [])
        
            case .failure(let error):
                print(error)
            }
            self.view?.hideLoading()
        }
    
    }
}
