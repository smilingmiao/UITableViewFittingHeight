//
//  ViewController.swift
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/30.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private var tableView: UITableView!
  private var store: FeedStore!
  
  private weak var bookTextField: UITextField?
  private weak var summaryTextField: UITextField?
  private weak var confirmAction: UIAlertAction?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Books"
    navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addBook))
    
    NotificationCenter.default.addObserver(self, selector: #selector(feedItemDidChange), name: .feedStoreDidChangeNotification, object: nil)
    
    setupTableView()
    store = FeedStore()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0))
    view.addConstraint(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10))
    view.addConstraint(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10))
    let margin = UIScreen.main.bounds.size.height >= 812 ? CGFloat(35): CGFloat(0)
    view.addConstraint(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin))
  }
  
  private func setupTableView() {
    tableView = UITableView(frame: .zero, style: .plain)
    tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 100
    tableView.sectionHeaderHeight = 0
    tableView.sectionFooterHeight = 0
    
    let nibName = UINib(nibName: "AdaptiveTableViewCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    
    view.addSubview(tableView)
  }
  
  @objc func addBook(sender: Any) {
    
    let alert = UIAlertController(title: "增加条目", message: "填写书名和简介", preferredStyle: .alert)
    
    alert.addTextField { (textField) in
      textField.placeholder = "请填写书名"
      textField.addTarget(self, action: #selector(self.inputText), for: .editingChanged)
      self.bookTextField = textField
    }
    alert.addTextField { (textField) in
      textField.placeholder = "请填写简介"
      textField.addTarget(self, action: #selector(self.inputText), for: .editingChanged)
      self.summaryTextField = textField
    }
    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
      self.dismiss(animated: true, completion: nil)
    }))
    
    let confirm = UIAlertAction(title: "提交", style: .destructive) { (_) in
      let title = self.bookTextField?.text ?? ""
      let content = self.summaryTextField?.text ?? ""
      let feed = FeedItem(title: title, content: content)
      self.store.add(item: feed, at: 0)
    }
    alert.addAction(confirm)
    confirm.setValue(UIColor.blue, forKey: "titleTextColor")
    confirm.isEnabled = false
    confirmAction = confirm
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func inputText(_ textField: UITextField) {
    let title = bookTextField?.text ?? ""
    let content = summaryTextField?.text ?? ""
    if title.count > 0 && content.count > 0 {
      confirmAction?.isEnabled = true
    } else {
      confirmAction?.isEnabled = false
    }
  }
  
  @objc func feedItemDidChange(_ notification: Notification) {
    let behavior = notification.getUserInfo(for: .feedStoreDidChangedChangeBehaviorKey)
    switch behavior {
    case .add(let index):
      let indexPathes = index.map { IndexPath(row: $0, section: 0) }
      self.tableView.insertRows(at: indexPathes, with: .automatic)
      
    case .remove(let index):
      let indexPathes = index.map { IndexPath(row: $0, section: 0) }
      tableView.deleteRows(at: indexPathes, with: .automatic)
    case .reload:
      tableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return store.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? AdaptiveTableViewCell {
      if indexPath.row >= 0 && indexPath.row < store.count {
        cell.bindData(current: store.item(at: indexPath.row))
      }
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let contextualAction = UIContextualAction(style: .normal, title: "删除") { (_, _, done) in
      self.store.remove(at: indexPath.row)
      done(true)
    }
    contextualAction.backgroundColor = .orange
    let configuration = UISwipeActionsConfiguration(actions: [contextualAction])
    configuration.performsFirstActionWithFullSwipe = false
    
    return configuration
  }
  
  
}
