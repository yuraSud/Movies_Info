//
//  CreateViewController.swift
//  Movies
//
//  Created by Olga Sabadina on 05.01.2024.
//

import UIKit

class CreateViewController: UIViewController {
    
    let circleView = UIView()
    let circleView1 = UIView()
    let circleView2 = UIView()
    var didSendEventClosure: ((TabBarPage) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setCircleView()
        circleView.circleStrokeView(total: 10, current: 2)
        circleView1.circleStrokeView(total: 10, current: 5)
        circleView2.circleStrokeView(total: 10, current: 8)
        deleteProfile()
        
       
    }
    
    func setCircleView() {
        view.addSubview(circleView)
        circleView.frame = .init(x:150, y: 100, width: 80, height: 80)
        
        view.addSubview(circleView1)
        circleView1.frame = .init(x:150, y: 200, width: 80, height: 80)
        
        view.addSubview(circleView2)
        circleView2.frame = .init(x:150, y: 300, width: 80, height: 80)
    }
    
    func deleteProfile() {
        let database = DatabaseService.shared
        let action = UIAction { _ in
            Task {
                await database.deleteProfileAsync()
            }
        }
        let button = UIButton(type: .system, primaryAction: action)
        view.addSubview(button)
        button.frame = .init(x: 110, y: 500, width: 100, height: 45)
        button.setTitle("Create circle", for: .normal)
    }

}
