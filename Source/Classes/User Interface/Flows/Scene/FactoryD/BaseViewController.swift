//
//  ViewC.swift
//  events
//
//  Created by Halcyon on 16/01/2019.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit

protocol BaseFunc {
    func setupView()
    func setupConstraints()
}

class BaseViewController: UIViewController, BaseFunc {    
    func setupView() {
        view.backgroundColor =  Color.white
    }
    
    func setupConstraints() {}
}
