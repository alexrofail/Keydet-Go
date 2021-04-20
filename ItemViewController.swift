//
//  ItemViewController.swift
//  KeydetGoo
//
//  Created by brian lipscomb on 4/23/18.
//  Copyright © 2018 codewithlips. All rights reserved.
// help rec'd: https://www.youtube.com/watch?v=TsmlLyL1VLc

import UIKit

class ItemViewController: UIViewController {

    
    
    @IBOutlet weak var navBar: UINavigationBar!
    var itemIndex: Int = 0
    let vc = ViewController()
    var building = ""
    var imageName: String = "" {
        didSet {
            if let imageView = contentImageView{
                imageView.image = UIImage(named: imageName)
               
           
            }
        }
    }
    @IBOutlet weak var contentImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ViewController.GlobalVariable.myStruct
   
        contentImageView.image = UIImage(named: imageName)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
