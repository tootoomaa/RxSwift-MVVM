//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by 김광수 on 2020/08/23.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import Foundation

// viewModel 해당 스트럭트는 뷰에 표기될 정보를 모아둠
struct Menu {
  var id: Int
  var name: String
  var price: Int
  var count: Int
}

extension Menu {
  static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
    return Menu(id: id, name: item.name, price: item.price, count: 0)
  }
}
