//
//  PresentationBaseViewController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol PresentationBaseViewControllerNavigationPane: class {
    var delegate: PresentationBaseViewControllerNavigationPaneDelegate? { get set }
    
    var destinations: [String] { get set }
    
    func requestMoveToDestination(index: Int)
}

class PresentationBaseViewController: UIViewController, PresentationBaseViewControllerNavigationPaneDelegate {
    
    weak var navigationPane: PresentationBaseViewControllerNavigationPane?
    
    var client: Client?

    @IBOutlet weak var mainContentView: UIView!
    lazy var destinations: [(destinationName: String, destinationViewController: UIViewController)] = setupDefaultDestinations()
    
    @IBOutlet var navigationBarPreviousButton: UIBarButtonItem!
    @IBOutlet weak var navigationBarNextButton: UIBarButtonItem!
    @IBOutlet weak var navigationBarClientButton: UIBarButtonItem!
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.brandBlue
    }
    
    // MARK: - Configure Embedded VCs

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEmbeddedNavigationVC" {
            guard let navigationTVC = segue.destination as? PresentationBaseViewControllerNavigationPane else {return}
            navigationTVC.delegate = self
            var destinationNames: [String] = []
            for destination in destinations {
                destinationNames.append(destination.destinationName)
            }
            navigationTVC.destinations = destinationNames
            navigationPane = navigationTVC
        }
    }
    
    func selectedDestinationAtIndex(_ index: Int) {
        currentIndex = index
        let destination = destinations[index].destinationViewController
        addChildViewController(destination)
        for subview in mainContentView.subviews {
            subview.removeFromSuperview()
        }
        mainContentView.addSubview(destination.view)
        destination.view.frame = mainContentView.bounds
        destination.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupNavBarAppearance(){
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.red,
            NSAttributedStringKey.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        
        navigationBarPreviousButton.setTitleTextAttributes(attrs, for: .normal)
    }
    
    private func setupDefaultDestinations() ->  [(String, UIViewController)]{
        var defaultDestinations: [(String, UIViewController)] = []
        let growthCalculatorSB = UIStoryboard(name: "GrowthCalculator", bundle: nil)
        let growthCalculatorVC = growthCalculatorSB.instantiateViewController(withIdentifier: "growthCalculator")
        defaultDestinations.append(("Growth Calculator", growthCalculatorVC))
        let marketingOptionSB = UIStoryboard(name: "MarketingOptions", bundle: nil)
        let foundationOptionsVC = marketingOptionSB.instantiateViewController(withIdentifier: "marketingOptionsVC")
        defaultDestinations.append(("Foundation", foundationOptionsVC))
        //TODO: Replace this temporary test implementation
        guard let foundationVC = foundationOptionsVC as? MarketingOptionsViewController else { fatalError() }
        foundationVC.category = MarketingPlan.OptionCategory.foundation
        guard let internalVC = marketingOptionSB.instantiateViewController(withIdentifier: "marketingOptionsVC") as? MarketingOptionsViewController else { fatalError() }
        internalVC.category = MarketingPlan.OptionCategory.internal
        defaultDestinations.append(("Internal", internalVC))
        let externalStoryboard = UIStoryboard(name: "ExternalMarketing", bundle: nil)
        if let externalVC = externalStoryboard.instantiateInitialViewController(){
            defaultDestinations.append(("External", externalVC))
        }
        let summaryStoryboard = UIStoryboard(name: "SummaryAndConfirmation", bundle: nil)
        if let summaryVC = summaryStoryboard.instantiateInitialViewController(){
            defaultDestinations.append(("Summary + Confirmation", summaryVC))
        }
        return defaultDestinations
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        if currentIndex - 1 >= 0 {
            navigationPane?.requestMoveToDestination(index: currentIndex - 1)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if currentIndex + 1 < destinations.count {
            navigationPane?.requestMoveToDestination(index: currentIndex + 1)
        }
    }
    
    
}
