//
//  SignInTableViewController.swift
//  Dostawemo
//
//  Created by Stanislav Tashlykov on 14/06/2019.
//  Copyright © 2019 beer-pool. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PhoneNumberKit

enum SignInState{
    case phone, code
}

class SignInTableViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    
    private var state = SignInState.phone
    private var viewModel: SignInViewModel!
    
    enum Section: Int {
        case title, phone, code, button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setAppTitle()
        registerCell()
        cCloseButton()
        
        viewModel = SignInViewModel()
        cSuccessSendCode()
        cSuccessSignIn()
    
    }
    
    private func cCloseButton(){
        
        let button = UIBarButtonItem(
            image: UIImage(named: "close"),
            style: .plain,
            target: nil,
            action: nil)
        
        button.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in self?.dismiss(animated: true, completion: nil)})
            .disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = button
    }
    
    private func registerCell(){
        
        tableView.register(
            SignInButtonTableViewCell.nib,
            forCellReuseIdentifier: SignInButtonTableViewCell.reuseId
        )
        
        tableView.register(
            SignInTextFieldTableViewCell.nib,
            forCellReuseIdentifier: SignInTextFieldTableViewCell.reuseId)
    }
    
}

extension SignInTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.title.rawValue:
            return 1
            
        case Section.button.rawValue:
            return 1
            
        case Section.phone.rawValue:
            return 2
            
        case Section.code.rawValue:
            return state == .code ? 2 : 0
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.title.rawValue {
            let cell = UITableViewCell()
            let width = tableView.bounds.width - 30
            let frame = CGRect(x: 0, y: 0, width: width, height: 100)
            let label = UILabel(frame: frame)
            label.font = UIFont.boldSystemFont(ofSize: 19)
            label.textAlignment = .center
            label.text = "Вход"
            cell.contentView.addSubview(label)
            return cell
        }
        
        if indexPath.section == Section.phone.rawValue {
            
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                let width = tableView.bounds.width - 30
                let frame = CGRect(x: 30, y: 0, width: width, height: 60)
                let label = UILabel(frame: frame)
                label.text = "Телефон"
                cell.contentView.addSubview(label)
                return cell
            }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SignInTextFieldTableViewCell.reuseId,
                for: indexPath
            ) as! SignInTextFieldTableViewCell
            
            cell.configurate(state: state)
            cell.value = {[weak self] phone in self?.viewModel.phone.onNext(phone)}
            return cell
            
        }
        
        if indexPath.section == Section.code.rawValue{
            
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                let width = tableView.bounds.width - 30
                let frame = CGRect(x: 30, y: 0, width: width, height: 60)
                let label = UILabel(frame: frame)
                label.text = "Код"
                cell.contentView.addSubview(label)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SignInTextFieldTableViewCell.reuseId,
                for: indexPath
            ) as! SignInTextFieldTableViewCell
            
            cell.configurate(state: state)
            cell.value = {[weak self] code in self?.viewModel.code.onNext(code)}
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SignInButtonTableViewCell.reuseId,
            for: indexPath) as! SignInButtonTableViewCell
        let title = state == .phone ? "Выслать код" : "Подтвердить номер телефона"
        cell.configurate(title: title)
        cell.buttonAction = {[weak self] in self?.buttonHandler()}
        return cell
    }
    
    private func buttonHandler(){
        if state == .phone {
            viewModel.sendCode.onNext(())
        } else {
            viewModel.signIn.onNext(())
        }
    }
    
    private func cSuccessSendCode(){
        viewModel.successSendCode
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] code in self?.showAlertCode(code: code)})
            .disposed(by: disposeBag)
    }
    
    private func showAlertCode(code: Int){
        let alert = UIAlertController(
            title: "Ваш код подтверждения",
            message: "\(code)", preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.state = .code
                DispatchQueue.main.async {
                    self.tableView.reloadSections(
                        [Section.code.rawValue, Section.button.rawValue],
                        animationStyle: .automatic
                    )
                }
            })
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    private func cSuccessSignIn(){
        viewModel.successSignIn
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in self?.showSuccessSignInAlert()})
            .disposed(by: disposeBag)
    }
    
    private func showSuccessSignInAlert(){
        let alert = UIAlertController(
            title: "Вы успешно вошли в Dostawemo",
            message: "Приятных покупок!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: {
                app.coordinator.refreshUserData.onNext(())
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Section.title.rawValue{
            return 100
        }
        return 60
    }
}
