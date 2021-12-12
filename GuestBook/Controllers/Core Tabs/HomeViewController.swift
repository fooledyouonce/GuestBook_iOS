//  HomeViewController.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/1/21.

import FirebaseAuth
import UIKit

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {

    private var feedRenderModels = [HomeFeedRenderViewModel]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        //register cells
        tableView.register(GBFeedPostTableViewCell.self,
                           forCellReuseIdentifier: GBFeedPostTableViewCell.identifier)
        tableView.register(GBFeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: GBFeedPostHeaderTableViewCell.identifier)
        tableView.register(GBFeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: GBFeedPostActionsTableViewCell.identifier)
        tableView.register(GBFeedPostGeneralCellTableViewCell.self,
                           forCellReuseIdentifier: GBFeedPostGeneralCellTableViewCell.identifier)

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "guestBookBG")
        createMockModels()
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(named: "guestBookBG")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func createMockModels() {
        let user = User(username: "@alanturing314",
                        bio: "",
                        name: (first: "", last: ""),
                        profilePhoto: URL(string: "https://www.google.com")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 1, posts: 1),
                        joinDate: Date())
        let post = UserPost(identifier: "",
                            postType: .photo,
                            thumbnailImage: URL(string: "https://www.google.com/")!,
                            postURL: URL(string: "https://www.google.com/")!,
                            caption: nil,
                            likeCount: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUsers: [],
                            owner: user)

        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(
                PostComment(
                    identifier: "\(x)",
                    username: "@sherlock",
                    text: "Elementary, my dear Watson",
                    createdDate: Date(),
                    likes: []
                )
            )
        }

        for x in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }

    private func handleNotAuthenticated() {
        //check auth status
        if Auth.auth().currentUser == nil {
            //show log in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }

        let subSection = x % 4

        if subSection == 0 {
            //header
            return 1
        }
        else if subSection == 1 {
            //post
            return 1
        }
        else if subSection == 2 {
            //actions
            return 1
        }
        else if subSection == 3 {
            //comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .header, .actions, .primaryContent: return 0
            }
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }

        let subSection = x % 4

        if subSection == 0 {
            //header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostHeaderTableViewCell.identifier,
                                                         for: indexPath) as! GBFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 1 {
            //post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostTableViewCell.identifier,
                                                         for: indexPath) as! GBFeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            //actions
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostActionsTableViewCell.identifier,
                                                         for: indexPath) as! GBFeedPostActionsTableViewCell
                cell.delegate = self
                return cell
            case .comments, .header, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 3 {
            //comments
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostGeneralCellTableViewCell.identifier,
                                                         for: indexPath) as! GBFeedPostGeneralCellTableViewCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        if subSection == 0 {
            //header
            return 70
        }
        else if subSection == 1 {
            //post
            return tableView.width
        }
        else if subSection == 2 {
            //actions (like/comment)
            return 60
        }
        else if subSection == 3 {
            //comment row
            return 50
        }

        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
}

extension HomeViewController: GBFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "post options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "report post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }

    func reportPost() {

    }
}

extension HomeViewController: GBFeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        print("like")
    }

    func didTapCommentButton() {
        print("comment")
    }

    func didTapSendButton() {
        print("send")
    }
}
