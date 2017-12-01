//
//  HapperReportViewController.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 11..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//

import UIKit

class HapperReportViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentVIew: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.delegate = self
        self.scrollView.contentSize = self.contentVIew.bounds.size
        self.scrollView.addSubview(contentVIew)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func touchBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
