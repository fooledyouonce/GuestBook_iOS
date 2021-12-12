//  PostViewController.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/1/21.

import UIKit

/*
Section
- Header model
Section
- Post Cell model
Section
- Action Buttons Cell model
Section
- n Number of general models for commments
*/

/// States of a rendered cell
enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost) //post
    case actions(provider: String) //like, comment, share
    case comments(comments: [PostComment])
}

/// Model of rendered post
struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {

    private let model: UserPost?

    private var renderModels = [PostRenderViewModel]()

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

    //MARK: - init

    init(model: UserPost?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureModels() {
        guard let userPostModel = self.model else {
            return
        }
        //header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))

        //post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))

        //actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))

        //four comments
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(
                PostComment(
                    identifier: "123_\(x)",
                    username: "@alanTuring",
                    text: "Great post!",
                    createdDate: Date(),
                    likes: []
                )
            )
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor(named: "guestBookBG")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .actions(_): return 1
        case .comments(let comments): return comments.count > 4 ? 4 : comments.count
        case .primaryContent(_): return 1
        case .header(_): return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]

        switch model.renderType {
            case .actions(let actions):
                let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostActionsTableViewCell.identifier,
                                                         for: indexPath) as! GBFeedPostActionsTableViewCell
                return cell

        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostGeneralCellTableViewCell.identifier,
                                                     for: indexPath) as! GBFeedPostGeneralCellTableViewCell
            return cell

        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostTableViewCell.identifier,
                                                     for: indexPath) as! GBFeedPostTableViewCell
            return cell

        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: GBFeedPostHeaderTableViewCell.identifier,
                                                     for: indexPath) as! GBFeedPostHeaderTableViewCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(_): return 60
        case .comments(_): return 50
        case .primaryContent(_): return tableView.width
        case .header(_): return 70
        }
    }
}
