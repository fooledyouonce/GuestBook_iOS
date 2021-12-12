//  ExploreViewController.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/1/21.

import UIKit

class ExploreViewController: UIViewController {

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search"
        searchBar.backgroundColor = UIColor(named: "guestBookBG")
        return searchBar
    }()

    private var models = [UserPost]()

    private var collectionView: UICollectionView?

    private var tabbedSearchCollectionView: UICollectionView?

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "guestBookBG")
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "guestBookBG")
        configureSearchbar()
        configureExploreCollection()
        configureDimmedView()
        configureSearchbar()
    }

    private func configureTabbedSearch() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        tabbedSearchCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: layout)
        tabbedSearchCollectionView?.backgroundColor = UIColor(named: "guestBookBG")
        tabbedSearchCollectionView?.isHidden = false
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }

    private func configureDimmedView() {
        view.addSubview(dimmedView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }

    private func configureSearchbar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }

    private func configureExploreCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
//        tabbedSearchCollectionView?.frame = CGRect(
//            x: 0,
//            y: view.safeAreaInsets.top,
//            width: view.width,
//            height: 72
//        )
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }

        query(text)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "cancel",
            style: .plain,
            target: self,
            action: #selector(didCancelSearch)
        )

        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }) { done in
            if done {
                self.tabbedSearchCollectionView?.isHidden = false
            }
        }
    }

    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.tabbedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) { done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
    }

    private func query(_ text: String) {
        //perform the search in the back end
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView {
            return 0
        }
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                            for: indexPath) as? PhotoCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
//        cell.configure(with: )
        cell.configure(debug: "test")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == tabbedSearchCollectionView {
            // change search context
            return
        }
        //let model = models[indexPath.row]
        let user = User(username: "alan",
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
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue
        navigationController?.pushViewController(vc, animated: true)
    }
}
