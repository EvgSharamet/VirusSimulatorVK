//
//  MainNavigationController.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 09.05.2023.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startScreen = StartScreenController(out: openEpidemicScreen)
        setViewControllers([startScreen], animated: true)
    }
    
    func openEpidemicScreen(service: EpidemicService) {
        let infectModel = InfectHumansModel(humans: service.count)
        let epidemicScreen = CollectionViewController(service: service, infectModel: infectModel)
        self.pushViewController(epidemicScreen, animated: true)
    }
}
