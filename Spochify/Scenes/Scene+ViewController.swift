//
//  SearchBuilder.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

extension Scene {
    
    func viewController() -> UIViewController {
        switch self {
            //    case .tasks(let viewModel):
            //      let nc = storyboard.instantiateViewController(withIdentifier: "Tasks") as! UINavigationController
            //      var vc = nc.viewControllers.first as! TasksViewController
            //      vc.bindViewModel(to: viewModel)
            //      return nc
            //
            //    case .editTask(let viewModel):
            //      let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
            //      var vc = nc.viewControllers.first as! EditTaskViewController
            //      vc.bindViewModel(to: viewModel)
        //      return nc
        case .home:
            return HomeBuilder()
                .build()
        case .start(let viewModel):
            return StartBuilder()
                .build()
        case .search(let viewModel):
            return SearchBuilder()
                .build()
        case .login:
            return LoginViewController()
        }
    }
}
