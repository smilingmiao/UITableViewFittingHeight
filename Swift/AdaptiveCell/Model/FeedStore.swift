//
//  FeedStore.swift
//  AdaptiveCell
//
//  Created by smilingmiao on 2019/3/30.
//  Copyright © 2019 smilingmiao. All rights reserved.
//

import Foundation

extension Notification {
  struct UserInfoKey<ValueType>: Hashable {
    let key: String
  }
  
  func getUserInfo<T>(for key: Notification.UserInfoKey<T>) -> T {
    return userInfo![key] as! T
  }
}

extension Notification.UserInfoKey {
  static var feedStoreDidChangedChangeBehaviorKey: Notification.UserInfoKey<FeedStore.ChangeBehavior> {
    return Notification.UserInfoKey(key: "smilingmiao.FeedStoreDidChangeBehaviorKey")
  }
}

extension Notification.Name {
  static let feedStoreDidChangeNotification = Notification.Name(rawValue: "smilingmiao.FeedsChangedNotificationName")
}

extension NotificationCenter {
  func post<T>(name aName: NSNotification.Name, object anObject: Any?, typedUserInfo aUserInfo: [Notification.UserInfoKey<T> : T]? = nil) {
    post(name: aName, object: anObject, userInfo: aUserInfo)
  }
}

struct FeedItem: Hashable {
  
  let id: UUID
  let title: String
  let content: String
  
  init(title: String, content: String) {
    self.id = UUID()
    self.title = title
    self.content = content
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(title)
    hasher.combine(content)
  }
}

extension FeedItem: Equatable {
  public static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
    return lhs.id == rhs.id
  }
}

class FeedStore {
  
  public init() {
    loadContents()
  }
  
  func loadContents() {
    DispatchQueue.global(qos: .default).async {
      if let url = Bundle.main.url(forResource: "books", withExtension: "json") {
        do {
          let data = try Data(contentsOf: url, options: [])
          let dict = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
          if dict.isEmpty { return }
          
          let books = dict["books"] as! [[String: String]]
          var feeds = [FeedItem]()
          books.forEach {
            let title = $0["title"] ?? ""
            let content = $0["content"] ?? ""
            let feed = FeedItem(title: title, content: content)
            feeds.append(feed)
          }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.items.append(contentsOf: feeds)
          })
          
        } catch {}
      }
    }
  }
  
  enum ChangeBehavior {
    case add([Int])
    case remove([Int])
    case reload
  }
  
  static func diff(old: [FeedItem], new: [FeedItem]) -> ChangeBehavior {
    let oldSet = Set(old)
    let newSet = Set(new)
    
    if oldSet.isSubset(of: newSet) {
      let added = newSet.subtracting(oldSet )
      let indexes = added.compactMap { new.firstIndex(of: $0) }
      return .add(indexes)
    } else if (newSet.isSubset(of: oldSet)) {
      let removed = oldSet.subtracting(newSet)
      let indexes = removed.compactMap { old.firstIndex(of: $0) }
      return .remove(indexes)
    } else {
      return .reload
    }
  }
  
  private var items: [FeedItem] = [] {
    didSet {
      let behavior = FeedStore.diff(old: oldValue, new: items)
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: .feedStoreDidChangeNotification, object: self, typedUserInfo: [.feedStoreDidChangedChangeBehaviorKey: behavior])
      }
    }
  }
  
  func add(item: FeedItem, at index: Int) {
    if index >= 0 && index <= count {
      items.insert(item, at: index)
    }
  }
  
  func remove(at index: Int) {
    if index >= 0 && index < items.count {
        items.remove(at: index)
    }
  }
  
  func item(at index: Int) -> FeedItem {
    return items[index]
  }
  
  var count: Int {
    return items.count
  }
  
}
