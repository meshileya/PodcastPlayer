//
//  HomeFeedController.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit

class HomeFeedController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ControllerDelegate {
    
    var itemList: [RSSFeed] = [];
    let mApiService = ApiService()
    
    lazy var collectionView : DynamicCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 4
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ChannelCell.self, forCellWithReuseIdentifier: "890")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "PODCAST"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.addSubview(collectionView)
        initViews()
        fetchData()
    }
    
    
    
    func fetchData () {
        showProgress()
        let feedParser = ApiService()
        feedParser.userFetchVideoDetail(){
            (result,data, error) in
            self.hideProgress()
            if (result){
                self.itemList = [data, data, data, data]
                self.collectionView.reloadData()
            }else{
                print("RETURNEDFAILURE")
            }

        }

    }
    
    func initViews(){
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: view.frame.width, height: 500)
        }
        else {
            return CGSize(width: view.frame.width, height: 300)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Handle on item seleted here
        let vc = PodDetailsController()
        vc.videoData = itemList[indexPath.item].channel
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom :0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "890", for: indexPath) as! ChannelCell
        cell.rssItem = itemList[indexPath.item]
        if(indexPath.item % 2 == 0){
            cell.setGradientBackground(colorTop: UIColor.rgb(255, green: 107, blue: 0), colorBottom: UIColor.rgb(255, green: 149, blue: 0))
        }else{
            cell.setGradientBackground(colorTop: UIColor.rgb(0, green: 121, blue: 255), colorBottom: UIColor.rgb(9, green: 169, blue: 233))
        }
        return cell
    }
    
    
}

