//
//  ViewController.swift
//  ReusableGenerator
//
//  Created by Can Yoldaş on 31.12.2022.
//

import UIKit

class GenericTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

class ViewController: UIViewController {
    
    var service = NetworkManager()
    
    private lazy var tableViewComponent: UITableView = {
        let temp = UITableView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.delegate = self
        temp.dataSource = self
        temp.separatorStyle = .none
        temp.estimatedRowHeight = UITableView.automaticDimension
        temp.rowHeight = UITableView.automaticDimension
        temp.register(GenericTableViewCell.self, forCellReuseIdentifier: GenericTableViewCell.identifier)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        // Do any additional setup after loading the view.
        
        service.getData { [weak self] response in
            print(response.background)
            self?.setupView(with: response)
        }
    }
    
    private func setupView(with cell: CellResponse) {
        DispatchQueue.main.async {
            if cell.type == "UIView" {
                let vw = UIView()
                vw.translatesAutoresizingMaskIntoConstraints = false
                let color = UIColor(hexaRGB: cell.background)
                vw.backgroundColor = color
                let parent = self.value(forKey: cell.parent) as? UIView
                if let parent {
                    parent.addSubview(vw)
                }
                
                for con in cell.constraints {
                    let x = self.applyConstraint(child: vw, con)
                    print(x)
                }
            }

        }
    }
    
    private func setupTableView() {
        view.addSubview(tableViewComponent)
        
        NSLayoutConstraint.activate([
        
            tableViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension UIView {
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return GenericTableViewCell()
    }
    
    
}

