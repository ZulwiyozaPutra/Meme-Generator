//
//  SavedMemeCollectionViewController.swift
//  Meme Generator
//
//  Created by Zulwiyoza Putra on 12/28/16.
//  Copyright © 2016 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeCollectionViewController: UICollectionViewController {
    
    var memes : [Meme]!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    func setupFlowLayout(orientation: UIDeviceOrientation) -> Void {
        let space: CGFloat = 3.0
        let dimension: CGFloat
        
        if orientation == UIDeviceOrientation.portrait {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        } else {
            dimension = (view.frame.size.height - (2 * space)) / 3.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
        
        subscribeToOrientationNotification()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowLayout(orientation: UIDevice.current.orientation)
    }
    
    func subscribeToOrientationNotification() -> Void {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceDidRotate(_ notification: NSNotification) -> Void {
        
        switch UIDevice.current.orientation {
        case .portrait:
            setupFlowLayout(orientation: .portrait)
        case .landscapeLeft:
            setupFlowLayout(orientation: .landscapeLeft)
        default:
            setupFlowLayout(orientation: .landscapeRight)
        }
        
    }
    
    
    
    

}
