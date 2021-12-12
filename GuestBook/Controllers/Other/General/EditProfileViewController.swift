//  EditProfileViewController.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/1/21.

import UIKit

struct EditProfileFormModel {
    let label: String
    let placeholder: String
    var value: String?
}

final class EditProfileViewController: UIViewController, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    
    private var models = [[EditProfileFormModel]]() //two-dimensional array for data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView) //allows for view to be shown!
        view.backgroundColor = UIColor(named: "guestBookBG")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
    private func configureModels() {
        //name, username, website, bio
        let section1Labels = ["event name", "event password", "description"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "enter \(label)", value: nil)
            section1.append(model)
        }
        models.append(section1) //array appended to larger array
        
        //email, phone, gender
        let section2Labels = ["number", "address", "website"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels {
            let model = EditProfileFormModel(label: label, placeholder: "enter \(label)", value: nil)
            section2.append(model)
        }
        models.append(section2) //array appended to larger array
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: tableview
    private func createTableHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4).integral)
        let size = header.height/1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width-size)/2, y: (header.height - size)/2, width: size, height: size))
        
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2
        profilePhotoButton.tintColor = .gray
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        return header
    }
    
    @objc private func didTapProfilePhotoButton() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "venue information"
    }
    
    //MARK: action
    @objc private func didTapSave() {
        //save info to DB
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChangeProfilePicture() {
        let actionSheet = UIAlertController(title: "profile picture", message: "change profile picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "take photo", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "choose from library", style: .default, handler: { _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }
}

extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        //update the model
        //print(updatedModel.value ?? "nil") //for testing
    }
}
