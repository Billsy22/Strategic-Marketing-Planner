//
//  MarketingOptionTableViewCell.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

protocol MarketingOptionTableViewCellDelegate: class {
    func marketingOptionTableViewCellShouldToggleSelectionState(_ cell: MarketingOptionTableViewCell) -> Bool
    func marketingOptionTableViewCell(_ cell: MarketingOptionTableViewCell, receivedRequestForInformationPage pageIndex: Int)
}

class MarketingOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    var showActive = false {
        didSet {
            updateSelectionButtonAppearance()
        }
    }
    
    weak var delegate: MarketingOptionTableViewCellDelegate?
    
    var marketingOption: MarketingOption? {
        didSet {
            performSetup()
        }
    }
    
    static let preferredReuseID = MarketingOptionTableViewCell.description()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        performSetup()
    }
    
    private func performSetup(){
        if marketingOption?.descriptionPageIndex == nil {
            infoButton.isHidden = true
            infoButton.isEnabled = false
        }else{
            infoButton.isEnabled = false
            infoButton.isEnabled = true
        }
        guard let marketingOption = marketingOption else {
            NSLog("MarketingOptionTableViewCell did not perform setup because no marketing option was provided.")
            return
        }
        nameLabel.text = marketingOption.name
        descriptionLabel.text = marketingOption.summary
        updateSelectionButtonAppearance()
    }
    
    func updateSelectionButtonAppearance(){
        if showActive {
            selectionButton.setImage(UIImage(named: "selected"), for: .normal)
        }else{
            selectionButton.setImage(UIImage(named: "unselected"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        guard let marketingOption = marketingOption else { return }
        marketingOption.isActive = !marketingOption.isActive
        if delegate?.marketingOptionTableViewCellShouldToggleSelectionState(self) ?? false {
            updateSelectionButtonAppearance()
        }
    }
    
    @IBAction func productInfoButtonTapped(_ sender: UIButton) {
        guard let descriptionPageIndex = marketingOption?.descriptionPageIndex?.intValue else { return }
        delegate?.marketingOptionTableViewCell(self, receivedRequestForInformationPage: descriptionPageIndex)
    }
}
