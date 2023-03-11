//
//  DetailVC.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-05.
//

import UIKit
import CoreData
import ImageViewer_swift


class DetailVC: UIViewController {
    
    @IBOutlet weak var pageController: UIPageControl!
    
    let modelView = ModelView()

    var imageArray = [UIImage]()
    var descText = String()

    @IBOutlet weak var collectionView: UICollectionView!
   
    
    @IBOutlet weak var descTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        descTextView.text = descText
        collectionView.delegate = self
        collectionView.dataSource = self
        


    }
    }




extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
                        let index = scrollView.contentOffset.x / witdh
                        let roundedIndex = round(index)
                        self.pageController?.currentPage = Int(roundedIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageController.numberOfPages = imageArray.count
        return imageArray.count
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDetail", for: indexPath) as! DetailsImageCell
        cell.slidableImageView.setupImageViewer(images: imageArray)
        cell.slidableImageView.image = imageArray[indexPath.item]
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //pageController.currentPage = Int(collectionView.contentOffset.x) / Int(collectionView.frame.width)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
//
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//
//        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }
    
    
}


