//
//  NetworkManager.swift
//  ReusableGenerator
//
//  Created by Can Yoldaş on 31.12.2022.
//

import UIKit

class NetworkManager {
    
    var session = URLSession.shared
    
    func getData(completion: @escaping (CellResponse) -> Void) {
        let url = URL(string: "http://localhost:3000/")!
        
        session.dataTask(with: URLRequest(url: url)) { (data,_,error) in
            guard error == nil else {
                return
            }
            
            if let data {
                do {
                    let decodedData = try JSONDecoder().decode(CellResponse.self, from: data)
                    completion(decodedData)
                } catch {
                    print("decoding error.")
                }
            }
        }.resume()
    }
}


struct CellResponse: Codable {
    let type, parent: String
    let constraints: [Constraint]
    let background, id: String

    enum CodingKeys: String, CodingKey {
        case type, parent, constraints, background
        case id = "_id"
    }
}

// MARK: - Constraint
struct Constraint: Codable {
    let direction: String
    let distance: Int
    let parentAnchor: String
    let parent: String?
    
    var dir: Direction {
        .init(rawValue: direction)!
    }
    
    var parentDir: Direction {
        .init(rawValue: parentAnchor)!
    }

    enum CodingKeys: String, CodingKey {
        case direction, distance, parentAnchor
        case parent
    }
}

enum Direction: String, Codable {
    case leading,top,trailing,bottom
}

extension UIViewController {
    
    @discardableResult
    func applyConstraint(child: UIView, _ constraint: Constraint) -> Bool {
        guard let parent = self.value(forKey: constraint.parent!) as? UIView else {
            return false
        }
        var constraints: [NSLayoutConstraint] = []
        
        switch constraint.dir {
        case .leading:
            switch constraint.parentDir {
            case .leading:
                constraints.append(child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(constraint.distance)))
//            case .top:
//                const = child.leadingAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(constraint.distance))
            case .trailing:
                constraints.append(child.leadingAnchor.constraint(equalTo: parent.trailingAnchor, constant: CGFloat(constraint.distance)))
            default: break
//            case .bottom:
//                const = child.leadingAnchor.constraint(equalTo: parent.bottomAnchor, constant: CGFloat(constraint.distance))
            }
        case .top:
            switch constraint.parentDir {
//            case .leading:
//                constraints.append(child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(constraint.distance)))
            case .top:
                constraints.append(child.topAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(constraint.distance)))
//            case .trailing:
//                constraints.append(child.leadingAnchor.constraint(equalTo: parent.trailingAnchor, constant: CGFloat(constraint.distance)))
            case .bottom:
                constraints.append(child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: CGFloat(constraint.distance)))
            default: break
            }
        case .trailing:
            switch constraint.parentDir {
            case .leading:
                constraints.append(child.trailingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(constraint.distance)))
//            case .top:
//                const = child.leadingAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(constraint.distance))
            case .trailing:
                constraints.append(child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: CGFloat(constraint.distance)))
            default: break
//            case .bottom:
//                const = child.leadingAnchor.constraint(equalTo: parent.bottomAnchor, constant: CGFloat(constraint.distance))
            }
        case .bottom:
            switch constraint.parentDir {
//            case .leading:
//                constraints.append(child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: CGFloat(constraint.distance)))
            case .top:
                constraints.append(child.bottomAnchor.constraint(equalTo: parent.topAnchor, constant: CGFloat(constraint.distance)))
//            case .trailing:
//                constraints.append(child.leadingAnchor.constraint(equalTo: parent.trailingAnchor, constant: CGFloat(constraint.distance)))
            case .bottom:
                constraints.append(child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: CGFloat(constraint.distance)))
            default: break
            }
        }
        NSLayoutConstraint.activate(constraints)
        return true
    }
}
