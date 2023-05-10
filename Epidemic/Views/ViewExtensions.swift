//
//  ViewExtensions.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 07.05.2023.
//

import Foundation
import UIKit

extension UIView {
    func addSubview(_ subview: UIView, andStretchWithInsets insets: UIEdgeInsets) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.stretch(insets: insets)
    }

    func stretch(inset: CGFloat) {
        stretch(insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

    func stretch(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            return
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func stretchSafe(inset: CGFloat = 0) {
        guard let superview = superview else {
            return
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: inset),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -inset)
        ])
    }

    func center(vertically: Bool = false, horizontally: Bool = false) {
        guard let superview = superview else {
            return
        }

        if vertically {
            NSLayoutConstraint.activate([
                centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0)
            ])
        }

        if horizontally {
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0)
            ])
        }
    }
}
