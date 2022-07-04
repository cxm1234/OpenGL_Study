//
//  MyHomeTableViewController.swift
//  Lyman_OpenGL_Demo
//
//  Created by  generic on 2022/6/30.
//

import UIKit

class MyHomeTableViewController: UITableViewController {
    
    enum GLStudyStep: String {
    case texture = "纹理渲染"
    case textureForGLSL = "纹理渲染着色器"
    case glPaint = "OpenGL绘图板"
        
        var viewController: UIViewController {
            switch self {
            case .texture:
                return MyTextureViewController()
            case .textureForGLSL:
                return MyTextureForGLSLViewController()
            case .glPaint:
                return GLPaintViewController()
            }
        }
        
    }
    
    var studySteps: [GLStudyStep] = [.texture, .textureForGLSL, .glPaint]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studySteps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard indexPath.row < studySteps.count else {
            return cell
        }
        
        cell.textLabel?.text = studySteps[indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < studySteps.count else {
            return
        }
        let detailVC = studySteps[indexPath.row].viewController
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
