//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 김광수 on 2020/08/23.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MenuListViewModel {
  
  var needUpdataUI: (() -> Void)?
  
  lazy var menuObservable = BehaviorRelay<[Menu]>(value: [])
  
  lazy var itemsCount = menuObservable.map {
    $0.map { $0.count }.reduce(0, +)
  }
  //  var totalPrice: Observable<Int> = Observable.just(10000) - 외부에서 값을 통제 하지 못함
  //  var totalPrice: PublishSubject<Int> = PublishSubject() // 외부에서 값을 통제하기 위한 방법
  lazy var totalPrice = menuObservable.map {
    $0.map { $0.price * $0.count }.reduce(0, +)
  }
  
  //subject : 값을 가져오고, 밖에서 값을 통제할 수도 있음
  
  init() {
    _ = APIService.fetchAllMenuRx()
      .map { data -> [MenuItem] in
        struct Response: Decodable {
          let menus: [MenuItem]
        }
        
        let response  = try JSONDecoder().decode(Response.self, from: data)
        
        return response.menus
    }
    .map { menuItems -> [Menu] in
      var menus: [Menu] = []
      menuItems.enumerated().forEach{ (index, item) in
        let menu = Menu.fromMenuItems(id: index, item: item)
        menus.append(menu)
      }
      return menuItems.map { Menu.fromMenuItems(id: 0, item: $0) }
    }
    .take(1)
    .bind(to: menuObservable)
  }
  
  func clearAllItemSelections() {
    _ = menuObservable
      .map { menus in
        menus.map { m in
          Menu(id: m.id, name: m.name, price: m.price, count: 0)
        }
    }
      .take(1) // 한번만 수행되도록 적용 // 스트림이 계속 남아있게됨
      .subscribe(onNext: {
        self.menuObservable.accept($0)
      })
  }
  
  func changeCount(item: Menu, iscrease: Int) {
    _ = menuObservable
      .map { menus in
        menus.map { m in
          if m.id == item.id {
            return Menu(id: m.id, name: m.name, price: m.price, count: max(m.count + iscrease, 0))
          } else {
            return Menu(id: m.id, name: m.name, price: m.price, count: m.count)
          }
        }
    }
      .take(1) // 한번만 수행되도록 적용 // 스트림이 계속 남아있게됨
      .subscribe(onNext: {
        self.menuObservable.accept($0)
      })
  }
  
  func onOrder() {
    
  }
}
