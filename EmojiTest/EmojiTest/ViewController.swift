//
//  ViewController.swift
//  EmojiTest
//
//  Created by youngjun goo on 20/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    // MARK: - Properties
    // MARK: -
    
    @IBOutlet var sceneView: ARSKView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var drawerView: UIVisualEffectView!
    
    var isDrawerOpen = true
    
    let emojis = ["😂","😁","🍎","😀","😍","😏","🏝","😇","❤️","😴","😔","😭","🖤","🤩","😊","😒","💕","😳","🙈","😓"]
    
    var selectEmoji = "🍎"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        sceneView.delegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func emojiTapped(_ sender: Any) {
        if isDrawerOpen {
            closeDrawer()
        } else {
            openDrawer()
        }
    
    }
    
    func openDrawer() {
        isDrawerOpen = true
        UIView.animate(withDuration: 3) {
            self.drawerView.transform = CGAffineTransform.identity
        }
        
    }
    
    func closeDrawer() {
        isDrawerOpen = false
        
        UIView.animate(withDuration: 0.3) {
            self.drawerView.transform = CGAffineTransform(translationX: 0, y: 100)
        }
    }
    
    
    // MARK: - ARSKViewDelegate
    //SKNode
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let labelNode = SKLabelNode(text: selectEmoji)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as!
        EmojiCollectionViewCell
        
        cell.emojiLabel.text = emojis[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectEmoji = emojis[indexPath.row]
        emojiButton.setTitle(selectEmoji, for: .normal)
        closeDrawer()
    }
    
    
}
