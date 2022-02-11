//
//  ColorChangerViewController.swift
//  New Color Changer
//
//  Created by Александр Муратов on 10.02.2022.
//

import UIKit

protocol ColorChangerViewControllerDelegate: AnyObject {
    func setBackgroundColor(_ color: UIColor)
}

class ColorChangerViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    // MARK: - Public Properties
    weak var delegate: ColorChangerViewControllerDelegate?
    var mainViewColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 16
        
        redSlider.tintColor = .systemRed
        greenSlider.tintColor = .systemGreen
        blueSlider.tintColor = .systemBlue
        
        colorView.backgroundColor = mainViewColor
        
        setSliders()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
        addDoneButton(to: redTextField, greenTextField, blueTextField)
    }
    
    // MARK: - IB Actions
    // Changing color and values in labels and text fields
    @IBAction func rgbSlider(_ sender: UISlider) {
        setColor()
        
        switch sender.tag {
        case 0:
            redLabel.text = string(for: sender)
            redTextField.text = string(for: sender)
        case 1:
            greenLabel.text = string(for: sender)
            greenTextField.text = string(for: sender)
        case 2:
            blueLabel.text = string(for: sender)
            blueTextField.text = string(for: sender)
        default:
            break
        }
    }
    
    @IBAction func doneButtonPressed() {
        delegate?.setBackgroundColor(colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
}

//MARK: - Private Methods
extension ColorChangerViewController {
    
    // Sets the background color based on the value in the sliders
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value) / 255,
            green: CGFloat(greenSlider.value) / 255,
            blue: CGFloat(blueSlider.value) / 255,
            alpha: 1
        )
    }
    
    private func setValue(for labels: UILabel...) {
        for label in labels {
            switch label.tag {
            case 0:
                label.text = string(for: redSlider)
            case 1:
                label.text = string(for: greenSlider)
            case 2:
                label.text = string(for: blueSlider)
            default:
                break
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        for textField in textFields {
            switch textField.tag {
            case 0:
                textField.text = string(for: redSlider)
            case 1:
                textField.text = string(for: greenSlider)
            case 2:
                textField.text = string(for: blueSlider)
            default:
                break
            }
        }
    }
    
    private func setSliders() {
        let ciColor = CIColor(color: mainViewColor)
        
        redSlider.value = Float(ciColor.red) * 255
        greenSlider.value = Float(ciColor.green) * 255
        blueSlider.value = Float(ciColor.blue) * 255
    }
    
    // Returns an integer value of the slider as a string
    private func string(for slider: UISlider) -> String {
        return String(Int(slider.value))
    }
    
    private func addDoneButton(to textFields: UITextField...) {
        
        textFields.forEach { textField in
            let keyboardToolbar = UIToolbar()
            textField.inputAccessoryView = keyboardToolbar
            keyboardToolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(
                title:"Done",
                style: .done,
                target: self,
                action: #selector(didTapDone)
            )
            
            let flexBarButton = UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            )
            
            keyboardToolbar.items = [flexBarButton, doneButton]
        }
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension ColorChangerViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            textField.attributedPlaceholder = NSAttributedString(string: string(for: redSlider))
        case 1:
            textField.attributedPlaceholder = NSAttributedString(string: string(for: greenSlider))
        case 2:
            textField.attributedPlaceholder = NSAttributedString(string: string(for: blueSlider))
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text), currentValue <= 255 {
            switch textField.tag {
            case 0:
                redSlider.setValue(currentValue, animated: true)
                setValue(for: redLabel)
            case 1:
                greenSlider.setValue(currentValue, animated: true)
                setValue(for: greenLabel)
            case 2:
                blueSlider.setValue(currentValue, animated: true)
                setValue(for: blueLabel)
            default:
                break
            }
            
            setColor()
            return
        } else if let currentValue = Float(text), currentValue > 255 {
            switch textField.tag {
            case 0:
                redSlider.setValue(255, animated: true)
                setValue(for: redLabel)
                setValue(for: redTextField)
            case 1:
                greenSlider.setValue(255, animated: true)
                setValue(for: greenLabel)
                setValue(for: greenTextField)
            case 2:
                blueSlider.setValue(255, animated: true)
                setValue(for: blueLabel)
                setValue(for: blueTextField)
            default:
                break
            }
            
            setColor()
        } else {
            switch textField.tag {
            case 0:
                setValue(for: redLabel)
                setValue(for: redTextField)
            case 1:
                setValue(for: greenLabel)
                setValue(for: greenTextField)
            case 2:
                setValue(for: blueLabel)
                setValue(for: blueTextField)
            default:
                break
            }
            
            setColor()
        }
        
        showAlert(title: "Wrong format!", message: "Please enter correct value.")
    }
}
