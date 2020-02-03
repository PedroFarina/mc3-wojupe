//
//  PageViewController.swift
//  PageController
//
//  Created by Julia Santos on 04/09/19.
//  Copyright © 2019 Julia Santos. All rights reserved.
//

import UIKit

class CustomPageViewController: UIPageViewController, UIPageViewControllerDelegate,
UIPageViewControllerDataSource, UIScrollViewDelegate {

    @IBOutlet weak var pgControl: UIPageControl!
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "Introducao"),
                self.newVc(viewController: "Campainhas"),
                self.newVc(viewController: "Protecao"),
                self.newVc(viewController: "Exportar")]
    }()
    var ultimoIndice: Int = 0
    @IBAction func pageChanged(_ sender: Any) {
        var direction: UIPageViewController.NavigationDirection = .forward
        if pgControl.currentPage < ultimoIndice {
            direction = .reverse
        }

        setViewControllers([orderedViewControllers[pgControl.currentPage]],
                           direction: direction,
                           animated: true,
                           completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        view.addSubview(pgControl)
        pgControl.center = view.center
        pgControl.center.y += view.frame.height / 10 * 4

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Tutorial", bundle: nil)
            .instantiateViewController(withIdentifier: viewController)
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1

        pgControl.currentPage = viewControllerIndex

        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        ultimoIndice = previousIndex
        return orderedViewControllers[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1

        pgControl.currentPage = viewControllerIndex

        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        ultimoIndice = nextIndex
        return orderedViewControllers[nextIndex]
    }

}
