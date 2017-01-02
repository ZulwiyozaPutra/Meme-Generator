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
    @IBAction func addMeme(_ sender: Any) {
        let memeEditor = storyboard!.instantiateViewController(withIdentifier: "MemeEditorRootViewController") as! UINavigationController
        self.present(memeEditor, animated: true, completion: nil)
    }
    
    func noDataLabelSetup(dataIsAvailable: Bool) -> UILabel {
        let frame = CGRect(x: 0, y: 0, width: (collectionView?.bounds.size.width)!, height: (collectionView?.bounds.size.height)!)
        let label = UILabel(frame: frame)
        
        if dataIsAvailable == false {
            label.text = "Tap + to create a new meme"
            label.backgroundColor = UIColor.lightGray
            
        } else {
            label.text = ""
            label.backgroundColor = UIColor.white
        }
        
        label.textColor        = UIColor.darkGray
        label.textAlignment    = .center
        
        return label
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        
        if memes?.count == 0 {
            
            collectionView.backgroundView = noDataLabelSetup(dataIsAvailable: false)
            
        } else {
            
            numOfSections = 1
            collectionView.backgroundView = noDataLabelSetup(dataIsAvailable: true)
            
        }

        return numOfSections
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    func setupFlowLayout(orientation: UIDeviceOrientation) -> Void {
        let space: CGFloat = 3.0
        let dimension: CGFloat
        
        if orientation == .portrait {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        } else if orientation == .portraitUpsideDown {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        } else {
            dimension = (view.frame.size.height - (2 * space)) / 3.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //passing data when a cell in collection view tapped
        let memeDetailViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memes[indexPath.row]
        navigationController!.pushViewController(memeDetailViewController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
        
        print("\(memes.count) is the amount of meme")
        
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
        case .portraitUpsideDown:
            setupFlowLayout(orientation: .portraitUpsideDown)
        case .landscapeLeft:
            setupFlowLayout(orientation: .landscapeLeft)
        default:
            setupFlowLayout(orientation: .landscapeRight)
        }
        
    }

}
