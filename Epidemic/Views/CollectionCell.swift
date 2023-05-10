//
//  CollectionCell.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 07.05.2023.
//

import Foundation
import UIKit

enum TypeOfPeople {
    case healthy
    case sick
    case invisible
}

class CollectionCell: UICollectionViewCell {
    var smile = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: TypeOfPeople) {
        switch type {
        case .healthy:
            smile.text = "🙂"
        case .sick:
            smile.text = "🤢"
        case .invisible:
            break
        }
    }
    
    func prepare() {
        self.contentView.addSubview(smile)
        smile.translatesAutoresizingMaskIntoConstraints = false
        smile.stretch()
        smile.textAlignment = .center
        smile.font = smile.font.withSize(40)
        smile.backgroundColor = .systemMint
        smile.layer.masksToBounds = true
        smile.layer.cornerRadius = 10
    }
    
}
