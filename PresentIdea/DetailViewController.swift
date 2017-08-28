//
//  DetailViewController.swift
//  PresentIdea
//
//  Created by Markus Fox on 28.08.17.
//  Copyright © 2017 Markus Fox. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var present: Present?

    @IBOutlet weak var presentImage: UIImageView!
    
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var presentName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receiverName.text = present?.person
        presentName.text = present?.presentName
        if let presentImage = UIImage(data: (present?.image)! as Data) {
            self.presentImage.image = presentImage
        }
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