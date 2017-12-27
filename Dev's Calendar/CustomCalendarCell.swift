//
//  CustomCalendarCell.swift
//  Dev's Calendar
//
//  Created by Devontae Reid on 12/26/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class CustomCalendarCell: JTAppleCell {

    var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(dateLabel)
        
        addContraintsWithFormat(format: "H:|[v0]|", views: dateLabel)
        addContraintsWithFormat(format: "V:|[v0]|", views: dateLabel)
    }
    
}
