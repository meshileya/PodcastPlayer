//
//  PodDetailsController.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit

class PodDetailsController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ControllerDelegate {
    
    var videoData : Channel?
    
    var itemList : [Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(backArrowImageView)
        
        initViews()
        itemList = videoData?.items
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initViews(){
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
        backArrowImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backArrowImageView.isUserInteractionEnabled = true
        
        backArrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackClicked)))
    }
    
    @objc func onBackClicked(){
        headerView?.animator?.startAnimation()
        headerView?.animator?.pauseAnimation()
                headerView?.animator?.fractionComplete = CGFloat(0.1)
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.headerView?.animator?.pauseAnimation()
                    self.headerView?.animator?.stopAnimation(true)
                    self.headerView?.animator?.finishAnimation(at: .current)
                    self.navigationController?.popViewController(animated: true)
                }
//        dismiss(animated: true, completion: nil)
    }
    
    lazy var collectionView : DynamicCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PodDetailsCell.self, forCellWithReuseIdentifier: "890")
        collectionView.register(PodHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "891")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    lazy var backArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_back_arrow")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return imageView
    }()
    
    var headerView: PodHeaderCell?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print(contentOffsetY)
        
        if contentOffsetY > 0 {
            headerView?.animator.fractionComplete = 0
            return
        }
        
        headerView?.animator.fractionComplete = abs(contentOffsetY) / 100
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "891", for: indexPath) as? PodHeaderCell
        headerView?.video = videoData
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: ((view.frame.width) - 40), height: 150)
        }
        else {
            return CGSize(width: view.frame.width, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Handle on item seleted here
        playerDetailsView.show()
        maximizePlayerDetails(episode: itemList?[indexPath.item], playlistEpisodes: self.videoData!.items!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom :0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "890", for: indexPath) as! PodDetailsCell
        cell.video = itemList?[indexPath.item]
        return cell
    }
    
    let playerDetailsView = PlayerDetailsView()
    
    @objc func minimizePlayerDetails() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.view.transform = .identity
            self.playerDetailsView.maximizedStackView.isHidden = true
            self.playerDetailsView.minimizedStackView.isHidden = false
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        })
    }
    
    func maximizePlayerDetails(episode: Item?, playlistEpisodes: [Item] = []) {
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        playerDetailsView.playlistEpisodes = playlistEpisodes
    }
}
