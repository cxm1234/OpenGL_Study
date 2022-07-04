//
//  GLPaintViewController.swift
//  Lyman_OpenGL_Demo
//
//  Created by  generic on 2022/7/4.
//

import UIKit

class GLPaintViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

extension GLPaintViewController {
    
    private func setup() {
        setupPaintView()
        
    }
    
    private func setupPaintView() {
        let ratio: CGFloat = view.frame.size.height / view.frame.size.width
        let width: CGFloat = 1500
        let textureSize = CGSize(width: width, height: width * ratio)
        let image = UIImage(named: "paper.jpg")
        
    }
}
