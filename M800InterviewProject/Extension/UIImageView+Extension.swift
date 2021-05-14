//
//  UIImageView+Extension.swift
//  M800InterviewProject
//
//  Created by 李泰儀 on 2021/5/14.
//

import UIKit

extension UIImageView {
    
    public func load(data: Data) {
        image = UIImage(data: data)
        animation()
    }

    public func load(urlString: String, getImageData: ((String, Data) -> ())? = nil) {
        alpha = 0
        if let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    getImageData?(urlString, data)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            self?.animation()
                        }
                    }
                }
            }
        }
    }
    
    private func animation() {
        alpha = 0
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.alpha = 1
        }, completion: { _ in })
    }
}
