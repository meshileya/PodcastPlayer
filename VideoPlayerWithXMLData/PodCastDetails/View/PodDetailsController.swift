//
//  PodDetailsController.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit

class PodDetailsController : UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UIViewDialogProtocol {
    
    var itemList : [Item]?
    var videoData : Channel?{
        didSet{
            
            itemList = videoData?.items
            collectionView.reloadData()
            
        }
    }
    
    var delegate : HomeFeedDelegate?
    let playerDetailsView = PlayerDetailsView()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        sizeToFit()
        addSubview(collectionView)
        addSubview(backArrowImageView)
        widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
        initViews()
        
        if playerDetailsView.player.rate != 0{
            print("LAMIDI")
        }else{
            print("LAMIDI TEST STATUS")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(){
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        backArrowImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
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
//                    self.navigationController?.popViewController(animated: true)
                }
        self.dismiss()
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
        imageView.image = UIImage(named: "icon_back_arrow")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
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
        if contentOffsetY > 280{
            backArrowImageView.tintColor = .black
        }
        
        headerView?.animator.fractionComplete = abs(contentOffsetY) / 100
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "891", for: indexPath) as? PodHeaderCell
        headerView?.video = videoData
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: frame.width, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: ((frame.width) - 40), height: 150)
        }
        else {
            return CGSize(width: frame.width, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Handle on item seleted here
        playerDetailsView.videoData = videoData
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
    
    
    
    func maximizePlayerDetails(episode: Item?, playlistEpisodes: [Item] = []) {
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        playerDetailsView.playlistEpisodes = playlistEpisodes
    }
}
