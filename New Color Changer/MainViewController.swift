//
//  MainViewController.swift
//  New Color Changer
//
//  Created by Александр Муратов on 10.02.2022.
//

import UIKit

class MainViewController: UIViewController, ColorChangerViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let colorChangerVC = segue.destination as! ColorChangerViewController
        colorChangerVC.delegate = self
        colorChangerVC.mainViewColor = view.backgroundColor
    }
    
    func setBackgroundColor(_ color: UIColor) {
        
        view.backgroundColor = color
    }
    
}
