//
//  MenuVC.swift
//  GambitMVP
//
//  Created by Асельдер on 02.09.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit
import SDWebImage

class MenuVC: UIViewController, BasketViewPresentable {
    
    var isBasketVisible = false
    func openBasket() { }
    
    
    // Protocol
    var presentorDish: MenuPresenterProtocol?
    
    //Reload TV
    var menuItems: [MenuItem] = [] { didSet { dishTable.reloadData() } }
    
    // Outlet
    @IBOutlet weak var dishTable: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleImg()
        
        Observer.shared.observe(self, selector: #selector(showBasketViewEvent), key: MenuBasketUD.shared.showBasketEvent)
        Observer.shared.observe(self, selector: #selector(hideBasketViewEvent), key: MenuBasketUD.shared.hideBasketEvent)
        
        presentorDish = MenuPresenter(view: self)
        
        dishTable.delegate = self
        dishTable.dataSource = self
        
        dishTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    // Ремув обсерверов
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Observer.shared.removeObserver(self)
        hideBasketView()
    }
    
    //
    func titleImg() {
        let logo = UIImage(named: "titleImg")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.8883533478, green: 0.07642378658, blue: 0.559297204, alpha: 1)
        
    }
    
    //MARK: - Basket method
    
    @objc func showBasketViewEvent() {
        showBasketView()
    }
    
    @objc func hideBasketViewEvent() {
        hideBasketView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Basket on scene
        if MenuBasketUD.shared.showBasket() {
            showBasketView()
        }
    }
}

//MARK: - TableView Configuration

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = dishTable.dequeueReusableCell(withIdentifier: "DishMenuCell", for: indexPath) as! DishCell
        
        
        menuCell.delegate = self
        menuCell.index = indexPath
        menuCell.setData(item: menuItems[indexPath.row], delegate: self)
        menuCell.selectionStyle = .none
        
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = indexPath.row
        let isFav = MenuBasketUD.shared.isFavorite(item: self.menuItems[index])
        
        let action = UIContextualAction(style: .normal, title: "") { (action, view, complitionHandler) in
            let item = self.menuItems[indexPath.row]
            MenuBasketUD.shared.addOrRemoveFavorite(item: item)
            complitionHandler(true)
        }
        
        action.image = isFav ? UIImage(named: "favorite") : UIImage(named: "noFavorite")
        action.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04)
        
        let actions = UISwipeActionsConfiguration(actions: [action])
        return actions
    }
    
}

// MARK: - Protocol

