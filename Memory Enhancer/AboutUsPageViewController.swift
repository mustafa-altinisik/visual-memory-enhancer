//
//  AboutUsPageViewController.swift
//  Memory Enhancer
//
//  Created by Asım Altınışık on 6.10.2022.
//

import UIKit

class AboutUsPageViewController: UIViewController {

    //Close button closes the about us page with an animation.
    @IBAction func closeButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
