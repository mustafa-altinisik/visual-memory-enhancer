//
//  HowToPlayPageViewController.swift
//  Memory Enhancer
//
//  Created by Asım Altınışık on 10.10.2022.
//

import UIKit

class HowToPlayPageViewController: UIViewController {

    //Close button closes the how to play page with an animation.
    @IBAction func closeButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
