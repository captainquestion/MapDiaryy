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


    @IBOutlet weak var mapButtonOutlet: UIBarButtonItem!
    var currentIndex = Int()
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    @IBOutlet weak var descTextView: UITextView!
    
    var itemObject: Items?
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelView.loadItems()
        
//        descTextView.text = descText
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let itemObject = itemObject {
            print("Clickedddddddd")
            descTextView.text = itemObject.desc
            title = itemObject.name
            
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)

        modelView.updateDesc(currentText: descTextView.text, currentIndex: currentIndex)

        
    }
    
//    func isMapEnabled(){
//        if modelView.itemsArray[currentIndex].lat == 0.0{
//            mapButtonOutlet.isEnabled = false
//            mapButtonOutlet.customView?.alpha = 0.5
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MapVC else {return}
        if let itemObject = itemObject {
            destinationVC.longituteV = itemObject.lon
            destinationVC.latitudeV = itemObject.lat
        }
        
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


