//
//  NavControllerViewController.swift
//  MovieViewer
//
//  Created by Sarah Gemperle on 1/11/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class NavControllerViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor.init(red:  1,
                         green: 0.463,
                         blue: 0.2745,
                         alpha: 0.7)
        self.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: color]
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
