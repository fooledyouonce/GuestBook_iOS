//  SettingsViewController.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/1/21.

import SafariServices
import UIKit

struct SettingsCellModel {
    let title: String
    let handler: (() -> Void)
}

///View Controller to show user settings
final class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingsCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = UIColor(named: "guestBookBG")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        data.append([SettingsCellModel(title: "edit event") { [weak self] in
            self?.didTapEditProfile()
            },
            SettingsCellModel(title: "edit profile") { [weak self] in
            self?.didTapInviteFriends()
            },
            SettingsCellModel(title: "past events") { [weak self] in
            self?.didTapSaveOriginalPosts()
            }
        ])
        
        data.append([SettingsCellModel(title: "terms of service") { [weak self] in
            self?.openURL(type: .terms)
            },
            SettingsCellModel(title: "privacy policy") { [weak self] in
            self?.openURL(type: .privacy)
            },
            SettingsCellModel(title: "help") { [weak self] in
            self?.openURL(type: .help)
            }
        ])
        
        data.append([SettingsCellModel(title: "log out") { [weak self] in
            self?.didTapLogOut()
            }
        ])
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "edit event"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapInviteFriends() {
        //show a share sheet to invite friends
    }
    
    private func didTapSaveOriginalPosts() {}
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType) {
        let urlString: String
        switch type {
            case .terms: urlString = "https://www.lipsum.com/"
            case .privacy: urlString = "https://www.lipsum.com/"
            case .help: urlString = "https://www.lipsum.com/"
        }
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "log out", message: "are you sure you want to log out?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "log out", style: .destructive, handler: { _ in
        
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        //present login
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        //error occurred
                        fatalError("could not log out user")
                    }
                }
            })
            
        }))
        popoverPresentationController?.sourceView = tableView
        popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //handle cell selection
        data[indexPath.section][indexPath.row].handler()
    }
}
