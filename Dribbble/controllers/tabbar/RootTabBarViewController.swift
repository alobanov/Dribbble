//
//  RootTabBarViewController.swift
//  Tavern
//
//  Created by Lobanov Aleksey on 24.11.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class RootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        if let t1: UITabBarItem = self.tabBar.items?[0] {
            t1.setFAIcon(icon: FAType.FADribbble)
        }
        
        if let t2: UITabBarItem = self.tabBar.items?[1] {
            t2.setFAIcon(icon: FAType.FAUser)
            t2.title = "Player"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
