//
//  DetailVC.swift
//  MapDiary
//
//  Created by canberk yılmaz on 2023-03-05.
//

import UIKit
import CoreData
import ImageViewer_swift


class DetailVC: UIViewController, UITextViewDelegate {
    
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
//        overrideUserInterfaceStyle = ColorHelper.getSelectedAppearance()

        modelView.loadItems()
        
//        descTextView.text = descText
        collectionView.delegate = self
        collectionView.dataSource = self
        
//       setupUI()

//        setUpNavBarTitle()
        setupUI()
//
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        setupUI()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = ""
            textView.textColor = UIColor.label
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Write your note!"
            textView.textColor = UIColor.systemGray
            
        }
        modelView.updateDesc(currentText: descTextView.text, currentIndex: currentIndex)

       

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        if descTextView.textColor == UIColor.systemGray {
//            descTextView.text = "Write your note!"
//        }
        
//        modelView.updateDesc(currentText: descTextView.text, currentIndex: currentIndex)

        
    }
    
    func setupUI(){
        descTextView.delegate = self
        
        let backgroundColor: UIColor
        let backgroundCellColor: UIColor
        let navigationFontColor: UIColor
   
         if traitCollection.userInterfaceStyle ==  .light{
             backgroundColor = UIColor.getColors.lightModeBlueColor
             backgroundCellColor = UIColor.getColors.lightModeCyanColor
             navigationFontColor = UIColor.getColors.lightModeTextColor

             
         }else {
             backgroundColor = UIColor.getColors.darkModeBlueColor
             backgroundCellColor = UIColor.getColors.darkModeCyanColor
             navigationFontColor = UIColor.getColors.darkModeTextColor

         }

        
        if let selectedItem = itemObject {
            descTextView.text = selectedItem.desc

            if selectedItem.desc == "Write your note!"{
                
                descTextView.textColor = UIColor.systemGray
                
            }
            
            
            title = selectedItem.name
            
        }

//        view.backgroundColor = UIColor.systemBlue
        let attrs = [
            NSAttributedString.Key.foregroundColor: navigationFontColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.tintColor = navigationFontColor
        view.backgroundColor = backgroundColor
        descTextView.layer.borderWidth = 1.0
        descTextView.layer.borderColor = UIColor.systemGray.cgColor
        descTextView.layer.cornerRadius = 5.0
        descTextView.backgroundColor = backgroundCellColor
        
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)


        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MapVC else {return}
        if let itemObject = itemObject {
            destinationVC.longituteV = itemObject.lon
            destinationVC.latitudeV = itemObject.lat
          
            destinationVC.titleV = itemObject.name!
            destinationVC.title = itemObject.name!
            
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
        cell.slidableImageView.setupImageViewer(images: imageArray, initialIndex: indexPath.row)
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


