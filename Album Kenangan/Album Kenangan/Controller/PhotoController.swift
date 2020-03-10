//
//  PhotoController.swift
//  Album Kenangan
//
//  Created by Muhammad Arif Hidayatulloh on 09/03/20.
//  Copyright © 2020 ENGINEERING TEST. All rights reserved.
//

import UIKit
import Moya

class PhotoController: UIViewController {

    var data : [GetPhoto.Results] = []
    var estimateWidth = 50.0
    var cellMargin = 3.0
    var fetchingMore = false
    var page = 1
    
    @IBOutlet weak var photo_list: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(false, animated:true)
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Album Photo"

        callData()
    }
    
    func callData(){
        let callNet = MoyaProvider<DataNetwork>()
        callNet.request(.photo(page: self.page)) { (result) in
            switch result {
            case .success(let respon):
                do {
                    let response = try respon.filterSuccessfulStatusCodes()
                    let data = try response.map(GetPhoto.self)
                    let temp = data.result ?? []
                    
                    for i in 0 ..< temp.count {
                        let dataTemp = temp[i]
                        
                        self.data.append(dataTemp)
                    }
                    self.photo_list.dataSource = self
                    self.photo_list.delegate = self
                    
                } catch {
                    print("Gagal")
                }
            case .failure(_):
                print("Gagal")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gridLayout()
        
        DispatchQueue.main.async {
            self.photo_list.reloadData()
        }
    }
    
    func gridLayout(){
        let layout = self.photo_list.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = CGFloat(self.cellMargin)
        layout.minimumLineSpacing = CGFloat(self.cellMargin)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoController :UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.setData(data: data)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        print("offsetY \(offsetY) content \(contentHeight - scrollView.frame.height)")
        if offsetY > (contentHeight - scrollView.frame.height) {
            if !fetchingMore {
                beginBatchFetch()
            }

        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.page = self.page + 1
            self.fetchingMore = false
            self.callData()
        })
    }
}
extension PhotoController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: (screenWidth/3)-6, height: (screenWidth/3)-6)
    }
    
    func calculate() -> CGFloat {
        let estWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estWidth))
        let margin = CGFloat(cellMargin * 3)
        let width = (self.view.frame.size.width - CGFloat(cellMargin) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}
