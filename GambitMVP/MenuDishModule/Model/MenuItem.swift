//
//  MainModel.swift
//  GambitMVP
//
//  Created by Асельдер on 02.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation

// Позиция меню
struct MenuItem: Codable {
    var id: Int
    var name: String
    var image: String
    var price: Int
}
