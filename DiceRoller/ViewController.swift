//
//  ViewController.swift
//  DiceRoller
//
//  added by Дмитрий Назаров on 08.01.2024.
//

import UIKit
import SceneKit


final class ViewController: UIViewController {
    
    var sceneView: SCNView!
    var button: UIButton!
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton()
        addScene()
        addLightSourceNode()
        addCamera()
        addNodes(geometry: createBoostDieGeometry())
        configureConstraints()
    }
    
    private func createBoostDieGeometry() -> SCNBox {
        let diceGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.15)
        diceGeometry.materials = addRandomMaterials()
        return diceGeometry
    }
    
    private func addRandomMaterials() -> [SCNMaterial] {
        
        let randomIndex = Int.random(in: 0...5)

        let emptySide = SCNMaterial()
        emptySide.diffuse.contents = UIImage(named: "empty")
        
        let triumphBoostTexture = SCNMaterial()
        triumphBoostTexture.diffuse.contents = UIImage(named: "triboo")
        
        let boostTexture = SCNMaterial()
        boostTexture.diffuse.contents = UIImage(named: "boo")
        
        let triumphTexture = SCNMaterial()
        triumphTexture.diffuse.contents = UIImage(named: "tri")
        
        let doubleBoostTexture = SCNMaterial()
        doubleBoostTexture.diffuse.contents = UIImage(named: "arrow")
        
        let defaultArray = [
            emptySide,
            emptySide,
            triumphTexture,
            triumphBoostTexture,
            doubleBoostTexture,
            boostTexture
        ]
        
        var newArray: [SCNMaterial] = [SCNMaterial] (repeating: SCNMaterial(), count: 6)
        
        for i in randomIndex...defaultArray.count - 1 {
            newArray[i - randomIndex] = defaultArray[i]
        }
        
        let diff = defaultArray.count - randomIndex
        
        for i in 0..<randomIndex {
            newArray[i + diff] = defaultArray[i]
        }
        
        return newArray
    }
    
    private func addButton() {
        button = UIButton(type: .system)
        button.setTitle("Бросить", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func addNodes(geometry: SCNBox) {
        let diceNode = SCNNode(geometry: geometry)
        diceNode.position = SCNVector3(x: 0, y: 0, z: 0)
        diceNode.name = "node1"
        
        
        scene.rootNode.addChildNode(diceNode)
    }
    
    private func addScene() {
        sceneView = SCNView(frame: view.frame)
        view.addSubview(sceneView)

        scene = SCNScene()
        sceneView.scene = scene
    }
    
    private func addCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func addLightSourceNode() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.gray
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    private func configureConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    @objc func didTapButton() {
        button.isEnabled = false
        
        scene.rootNode.childNodes.forEach { childNode in
            if ["node1"].contains(childNode.name) {

                let rotate = SCNAction.rotateBy(
                    x: 6 * CGFloat.pi,
                    y: 6 * CGFloat.pi,
                    z: 0,
                    duration: 0.8
                )
                childNode.runAction(rotate, completionHandler: {
                    DispatchQueue.main.async { [weak self] in
                        childNode.geometry?.materials = self?.addRandomMaterials() ?? []
                        self?.button.isEnabled = true
                    }
                })
            }
        }
    }
}
