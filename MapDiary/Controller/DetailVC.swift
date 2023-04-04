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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        modelView.loadItems()
        

        collectionView.delegate = self
        collectionView.dataSource = self

        setupUI()
//
    }
    //Dark - light theme adjustment
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        setupUI()
    }
    
    //Setting up textView placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = ""
            textView.textColor = UIColor.label
            }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let savedDesc: String
        
        if textView.text.isEmpty {
       
            textView.text = "Write your note!"
            textView.textColor = UIColor.placeholderText
            savedDesc = ""
            
            
        }else {
            savedDesc = descTextView.text
        }
        
        DispatchQueue.main.async {
            self.modelView.updateDesc(currentText: savedDesc, currentIndex: self.currentIndex)

        }
 

    }
    
    // Setup UI
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

            if selectedItem.desc == ""{
                
                descTextView.text = "Write your note!"
                descTextView.textColor = UIColor.placeholderText
                
            }else {
                descTextView.text = selectedItem.desc

            }
            
            
            title = selectedItem.name
            
        }

        let attrs = [
            NSAttributedString.Key.foregroundColor: navigationFontColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.tintColor = navigationFontColor
        view.backgroundColor = backgroundColor
        descTextView.layer.borderWidth = 1.0
        descTextView.layer.borderColor = UIColor.placeholderText.cgColor
        descTextView.layer.cornerRadius = 5.0
        descTextView.backgroundColor = backgroundCellColor
        
        
    }
    
    //Navigate to MapVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MapVC else {return}
        if let itemObject = itemObject {
            destinationVC.longituteV = itemObject.lon
            destinationVC.latitudeV = itemObject.lat
            
            if let name = itemObject.name {
            destinationVC.title = name
            }
            
        }
        
    }
    
    //Page Controller size and function
    
    @IBAction func pageControllTap(_ sender: UIPageControl) {

        let page: Int? = sender.currentPage
         var frame: CGRect = self.collectionView.frame
         frame.origin.x = frame.size.width * CGFloat(page ?? 0)
         frame.origin.y = 0
         self.collectionView.scrollRectToVisible(frame, animated: true)
}

}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //Resizing Collection View for rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let collectionView = collectionView else { return }
        let offset = collectionView.contentOffset
        let width = collectionView.bounds.size.width

        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)

        coordinator.animate(alongsideTransition: { (context) in
            collectionView.reloadData()
            collectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }

    //Sizing collectionview content and updating pagecontroller
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
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    
}


