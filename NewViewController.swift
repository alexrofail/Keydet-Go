//
//  NewViewController.swift
//  KeydetGoo
//
//  Created by brian lipscomb on 4/23/18.
//  Copyright © 2018 codewithlips. All rights reserved.
//  help Rec'd: https://www.youtube.com/watch?v=TsmlLyL1VLc
//

import UIKit

class NewViewController: UIViewController, UIPageViewControllerDataSource {

 
    
    var pageViewController: UIPageViewController?
    var images = ["Mallory Hall", "Scott Shipp Hall" ]
    let vc = ViewController()
    let newVC = ItemViewController()
    var image: UIImage!
    var building = ViewController.GlobalVariable.myStruct
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = buildImages()
        print(buildImages())
        self.title = ViewController.GlobalVariable.myStruct
        
        image = vc.cameraImage
        createPageViewController()
        setupPageControl()
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func buildImages() -> [String] {
        
      
        if building == "Preston"{
            
            return ["conferenceRoom", "frontView" , "oldSchool" , "studyroom"]
            
        }
            
        else if (building == "Maury Brooke" ){
            return ["construct", "hallway", "lab", "lab2"]
        }
        else if (building == "Mallory Hall" ){
            
            return ["altView","drone"]
            
        }
        else if (building == "Corps Physical Training Facility" || building == "CPT"){
            return ["CPT"]
        }
        else if (building == "Nichols" ){
            return ["oldSchool1", "statue", "students", "students2"]
            
        }
        else if (building == "JM Hall" || building == "JM hall" || building == "Church"){
            return ["graduate2", "JM_Inisde", "lecture", "nightTime", "portrait","wedding"]
            
        }
        else if (building == "Old Barracks" ){
            return["firstStoop", "inside1", "inside2", "old"]
            
        }
        else if (building == "New Barracks" ){
            return ["Construction", "boxing", "matriculation","secondStoop"]
            
        }
        else if (building == "Third Barracks" ){
            return ["plans","breakout", "evening"]
            
        }
        else if (building == "Cocke Hall" ){
            return ["basketball_cocke","construction", "evening_cocke", "powerLift", "sideView", "weightRoom"]
        }
        else if (building == "Scott Shipp Hall" ){
            return ["Scott Shipp Hall"]
            
        }
        else if (building == "Shell Hall" ){
            return ["Shell Hall"]
            
        }
        else if (building == "Foster Stadium"  ){
            return ["corps", "football1" ,"homeView", "rats", "streetView"]
            
        }
        else if (building == "Crozet Hall" || building == "Dining Hall".lowercased() || building == "Food" || building == "Dining" ){
            return ["daytime", "greyBlouse", "lines", "lines2", "meal1", "ratMeal"]
            
        }
        else if (building == "Kilbourne Hall"  ){
            return ["Kilbourne Hall"]
        }
        else if (building == "Cormack Hall"  ){
            return ["Cormack Hall"]
        }
            
        else if (building == "Post Hospital"  ){
            return ["Post Hospital"]
        }
            
        else if (building == "Carroll Hall"  ){
            return["Caroll Hall" ]
        }
            
        else if (building == "Cameron Hall"  ){
            
            return ["banners", "basketball", "bigRed", "court", "graduate", "matric", "outside"]
        }
        else{
            
            print("error")
            return ["no pics"]
        }
        

        
        
    }
    func createPageViewController(){
        let pageController = self.storyboard?.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if images.count > 0{
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        
        pageViewController?.didMove(toParentViewController: self)
    }
    
    func setupPageControl(){
        let newButton = UIButton(frame: CGRect(x:10, y:30, width:320,height:40))
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.blue
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray

        appearance.addSubview(newButton)
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! ItemViewController
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! ItemViewController
        if itemController.itemIndex+1 < images.count{
            return getItemController(itemController.itemIndex + 1)
        }
        return nil
    }
    
    
    
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return images.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        return 0
    }
    
    func currentControllerIndex() ->Int{
        let pageItemController = self.currentController()
        if let controller = pageItemController as? ItemViewController{
            return controller.itemIndex
        }
        return -1
    }
    
    func currentController() -> UIViewController? {
        if (self.pageViewController?.viewControllers?.count)! > 0{
            return (self.pageViewController?.viewControllers![0])!
        }
        return nil
    }
    func getItemController(_ itemIndex: Int) -> ItemViewController? {
        if itemIndex < images.count{
            let pageItemController = self.storyboard?.instantiateViewController(withIdentifier: "itemController") as! ItemViewController
            pageItemController.itemIndex = itemIndex
           
            pageItemController.imageName = images[itemIndex]
            return pageItemController
        }
        return nil
    }

   
}
