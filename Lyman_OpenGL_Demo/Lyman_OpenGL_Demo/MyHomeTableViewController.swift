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
    }
    
    var studySteps: [GLStudyStep] = [.texture, .textureForGLSL]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
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
        switch studySteps[indexPath.row] {
        case .texture:
            let vc = MyTextureViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .textureForGLSL:
            let vc = MyTextureForGLSLViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
