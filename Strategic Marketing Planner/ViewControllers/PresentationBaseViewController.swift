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
    
    func destinationsUpdated(to: [String] )
}

protocol CustomNavigationController: class {
    func insertNewDestination(viewControllerName: String, storyboardName: String, andStoryboardId id: String)
}

class PresentationBaseViewController: UIViewController, PresentationBaseViewControllerNavigationPaneDelegate {
    
    var navigationPane: PresentationBaseViewControllerNavigationPane?
    
    var client: Client? {
        return ClientController.shared.currentClient
    }
    
    @IBOutlet weak var mainContentView: UIView!
    var destinations: [(destinationName: String, destinationViewController: UIViewController)] = [] {
        didSet{
            navigationPane?.destinationsUpdated(to: destinations.map({$0.destinationName}))
        }
    }
    
    weak var delegate: CustomNavigationController?
    
    @IBOutlet var navigationBarPreviousButton: UIBarButtonItem!
    @IBOutlet weak var navigationBarNextButton: UIBarButtonItem!
    
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.brandBlue
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        createClientBarItem()
        destinations = setupDefaultStartingDestinations()
        guard let client = client, let practiceType = client.practiceType else { return }
        switch practiceType {
        case "startup":
            destinations = setupStartupPracticeTypeDestination()
        case "general":
            destinations = setupGeneralPracticeTypeDestination()
        case "specialty":
            destinations = setupSpecialtyPraciceTypeDestination()
        default:
            return
        }
    }
    
    func createClientBarItem() {
        let spacerButton = UIButton(type: .custom)
        let spacerButtonBarItem = UIBarButtonItem(customView: spacerButton)
        spacerButtonBarItem.isEnabled = false
        let clientImageButton = UIButton(type: .custom)
        let clientImage = client?.image ?? #imageLiteral(resourceName: "clientDefaultPhoto")
        clientImageButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(clientImageButton.frame.size, false, clientImage.scale)
        let rect = CGRect(x: 0, y: 0, width: clientImageButton.frame.size.width, height: clientImageButton.frame.size.height)
        UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).addClip()
        clientImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let color = UIColor(patternImage: newImage!)
        clientImageButton.backgroundColor = color
        clientImageButton.layer.cornerRadius = clientImageButton.bounds.size.width / 2
        clientImageButton.imageView?.contentMode = .scaleAspectFill
        let clientImageBarButton = UIBarButtonItem(customView: clientImageButton)
        clientImageBarButton.isEnabled = false
        let clientNameButton = UIButton(type: .custom)
        guard let firstName = client?.firstName, let lastName = client?.lastName else { return }
        let clientName = "\(firstName) \(lastName)"
        clientNameButton.setTitle(clientName, for: .normal)
        let clientNameBarButton = UIBarButtonItem(customView: clientNameButton)
        clientNameButton.isEnabled = false
        clientNameBarButton.tintColor = .white
        navigationItem.setRightBarButtonItems([navigationBarNextButton, spacerButtonBarItem, clientImageBarButton, clientNameBarButton], animated: false)
    }
    
    // MARK: - Configure Embedded VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

// MARK: -  Extension for updating path dependant on practice type
extension PresentationBaseViewController: CustomNavigationController {
    
    
    // MARK: -  Path methods
    private func setupDefaultStartingDestinations() -> [(String, UIViewController)] {
        var defaultDestinations: [(String, UIViewController)] = []
        let growthCalculatorSB = UIStoryboard(name: "GrowthCalculator", bundle: nil)
        let growthCalculatorVC = growthCalculatorSB.instantiateViewController(withIdentifier: "growthCalculator")
        defaultDestinations.append(("Growth Calculator", growthCalculatorVC))
        let brandStoryboard = UIStoryboard(name: "BrandDefinition", bundle: nil)
        if let brandVC  = brandStoryboard.instantiateInitialViewController(){
            defaultDestinations.append(("Brand Definition", brandVC))
        }
        return defaultDestinations
    }
    
    private func setupFinalDestinations() -> [(String, UIViewController)] {
        var destinations: [(String, UIViewController)] = []
        let summaryStoryboard = UIStoryboard(name: "SummaryAndConfirmation", bundle: nil)
        if let summaryVC = summaryStoryboard.instantiateInitialViewController(){
            destinations.append(("Summary + Confirmation", summaryVC))
        }
        let nextStepsStoryboard = UIStoryboard(name: "NextSteps", bundle: nil)
        if let nextStepsVC = nextStepsStoryboard.instantiateInitialViewController(){
            destinations.append(("Next Steps", nextStepsVC))
        }
        return destinations
    }
    
    private func setupGeneralPracticeTypeDestination() ->  [(String, UIViewController)]{
        var destinations: [(String, UIViewController)] = []
        destinations.append(contentsOf: setupDefaultStartingDestinations())
        let marketingOptionSB = UIStoryboard(name: "MarketingOptions", bundle: nil)
        let foundationOptionsVC = marketingOptionSB.instantiateViewController(withIdentifier: "marketingOptionsVC")
        destinations.append(("Foundation Options", foundationOptionsVC))
        guard let foundationVC = foundationOptionsVC as? MarketingOptionsViewController else { fatalError() }
        foundationVC.category = MarketingPlan.OptionCategory.foundation
        guard let internalVC = marketingOptionSB.instantiateViewController(withIdentifier: "marketingOptionsVC") as? MarketingOptionsViewController else { fatalError() }
        internalVC.category = MarketingPlan.OptionCategory.internal
        destinations.append(("Internal Marketing", internalVC))
        let externalStoryboard = UIStoryboard(name: "ExternalMarketing", bundle: nil)
        if let externalVC = externalStoryboard.instantiateInitialViewController(){
            destinations.append(("External Marketing", externalVC))
        }
        destinations.append(contentsOf: setupFinalDestinations())
        return destinations
    }
    
    private func setupStartupPracticeTypeDestination() -> [(String, UIViewController)] {
        var destinations: [(String, UIViewController)] = []
        let brandDefinitionSB = UIStoryboard(name: "BrandDefinition", bundle: nil)
        if let brandDefinitionVC = brandDefinitionSB.instantiateInitialViewController() {
            destinations.append(("Brand Definition", brandDefinitionVC))
        }
        let marketingOptionsSB = UIStoryboard(name: "StartUpMarketingOptions", bundle: nil)
        guard let marketingOptionsVC = marketingOptionsSB.instantiateViewController(withIdentifier: "StartupMarketingOptionsViewController") as? StartupMarketingOptionsViewController else { fatalError() }
        destinations.append(("Startup Marketing Options", marketingOptionsVC))
        destinations.append(contentsOf: setupFinalDestinations())
        return destinations
    }
    
    private func setupSpecialtyPraciceTypeDestination() -> [(String, UIViewController)] {
        var destinations: [(String, UIViewController)] = []
        destinations.append(contentsOf: setupDefaultStartingDestinations())
        let marketingOptionSB = UIStoryboard(name: "MarketingOptions", bundle: nil)
        let foundationOptionsVC = marketingOptionSB.instantiateViewController(withIdentifier: "marketingOptionsVC")
        destinations.append(("Foundation Options", foundationOptionsVC))
        guard let foundationVC = foundationOptionsVC as? MarketingOptionsViewController else { fatalError() }
        foundationVC.category = MarketingPlan.OptionCategory.foundation
        return destinations
    }
    
    // MARK: -  Delegate Methods
    func insertNewDestination(viewControllerName: String, storyboardName: String, andStoryboardId id: String) {
        let storyboardToAdd = UIStoryboard(name: storyboardName, bundle: nil)
        let viewControllerToAdd = storyboardToAdd.instantiateViewController(withIdentifier: id)
        self.destinations.append((viewControllerName, viewControllerToAdd))
        self.destinations.append(contentsOf: setupFinalDestinations())
    }
}
