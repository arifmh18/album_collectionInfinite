//
//  AlbumsController.swift
//  Album Kenangan
//
//  Created by Muhammad Arif Hidayatulloh on 09/03/20.
//  Copyright © 2020 ENGINEERING TEST. All rights reserved.
//

import UIKit
import Moya

class AlbumsController: UIViewController {

    @IBOutlet weak var album_list: UICollectionView!
    
    var data = [GetAlbum.Results]()
    var fetchingMore = false
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.callData(page: page)
    }
    
    func callData(page:Int){
        let callNet = MoyaProvider<DataNetwork>()
        callNet.request(.albums(page: page)) { (result) in
            switch result {
            case .success(let respon):
                print(respon.debugDescription)
                do {
                    let response = try respon.filterSuccessfulStatusCodes()
                    let data = try response.map(GetAlbum.self)
                    let temp = data.result ?? []
                    
                    for i in 0 ..< temp.count {
                        let dataTemp = temp[i]
                        
                        self.data.append(dataTemp)
                    }
                    self.album_list.delegate = self
                    self.album_list.dataSource = self
                    DispatchQueue.main.async {
                        self.album_list.reloadData()
                    }
                } catch {
                    print("Gagal")
                }
            case .failure(_):
                print("Gagal")
            }
        }
    }
}

extension AlbumsController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AlbumDelegate{
    func getPhoto(id: String) {
        print(id)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "photo") as! PhotoController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.data.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let data = self.data[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCell
            cell.setData(data: data)
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.loading.startAnimating()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 12, height: 170.0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > (contentHeight - scrollView.frame.height) {
            if !fetchingMore {
                beginBatchFetch()
            }

        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        self.album_list.reloadSections(IndexSet(integer: 1))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.page = self.page + 1
            self.fetchingMore = false
            self.callData(page: self.page)
        })
    }
}
