//
//  ListPageViewController.swift
//  Search
//
//  Created by guanho on 2017. 2. 3..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

@objc protocol ListPageViewControllerDelegate: class {
    @objc optional func pageViewController(_ pageViewController: UIPageViewController, didUpdatePageCount count: Int)
    @objc optional func pageViewController(_ pageViewController: UIPageViewController, didUpdatePageIndex index: Int)
}

class ListPageViewController: UIPageViewController{
    weak var pageViewDelegate: ListPageViewControllerDelegate?
    let storyBoard = "Main"
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.newViewController("searchVC"),
                self.newViewController("heartVC")]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        if let searchVC = self.orderedViewControllers[0] as? SearchViewController, let heartVC = self.orderedViewControllers[1] as? HeartViewController{
            heartVC.delegate = searchVC
        }
        self.pageViewDelegate?.pageViewController?(self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
    fileprivate func newViewController(_ id: String) -> UIViewController {
        return UIStoryboard(name: self.storyBoard, bundle: nil).instantiateViewController(withIdentifier: "\(id)")
    }
    
    fileprivate func scrollToViewController(_ viewController: UIViewController, direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],direction: direction,animated: true,completion: { (finished) -> Void in
            self.notifyDelegateOfNewIndex()
        })
    }
    
    fileprivate func notifyDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            self.pageViewDelegate?.pageViewController?(self, didUpdatePageIndex: index)
        }
    }
    
}
extension ListPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifyDelegateOfNewIndex()
    }
}
extension ListPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0{
            return nil
        }
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        if nextIndex > 1{
            return nil
        }
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
}
