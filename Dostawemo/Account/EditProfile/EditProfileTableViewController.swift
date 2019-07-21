//
//  EditProfileTableViewController.swift
//  Dostawemo
//
//  Created by fnm8 on 19/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var chngePhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: EditProfileViewModel!
    private let date = PublishSubject<Date>()
    
     let datePicker = UIDatePicker()
    
    var showCloseButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateChangePhotoButton()
        configurateSaveChangeButton()
        cCloseButton()
        
        
        viewModel = EditProfileViewModel(
            name: nameTextField.rx.text.orEmpty.asDriver(),
            lastName: lastNameTextField.rx.text.orEmpty.asDriver(),
            birthDate: date.asDriver(onErrorJustReturn: Date()),
            city: cityTextField.rx.text.orEmpty.asDriver(),
            save: saveChangesButton.rx.tap.asDriver()
        )
        showDatePicker()
        cSaveButton()
    }
    
    private func cCloseButton(){
        if showCloseButton {
            let close = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: nil, action: nil)
            close.rx.tap
                .asDriver()
                .drive(onNext: {[weak self] in self?.dismiss(animated: true, completion: nil) })
                .disposed(by: disposeBag)
            navigationItem.leftBarButtonItem = close
        }
    }
    
    private func cSaveButton(){
        viewModel.enableButton
            .asDriver()
            .drive(onNext: {[weak self] value in
                self?.saveChangesButton.isEnabled = !value
                self?.saveChangesButton.alpha = value ? 1 : 0.5
            }).disposed(by: disposeBag)
    }
    
    private func configurateChangePhotoButton(){
        chngePhotoButton.layer.cornerRadius = chngePhotoButton.bounds.height / 2
        chngePhotoButton.layer.borderWidth = 1
        chngePhotoButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configurateSaveChangeButton(){
        saveChangesButton.layer.cornerRadius = saveChangesButton.bounds.height / 2
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .bordered, target: self, action: "donedatePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .bordered, target: self, action: "cancelDatePicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        birthDateTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        birthDateTextField.inputView = datePicker
        
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthDateTextField.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }

}
