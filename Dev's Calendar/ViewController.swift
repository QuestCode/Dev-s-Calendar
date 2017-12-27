//
//  ViewController.swift
//  Dev's Calendar
//
//  Created by Devontae Reid on 12/26/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let backgroundColor = UIColor(rgb: 0xA47AF4)
    let insideTextColor = UIColor(rgb: 0xDCDBE8)
    let outsideTextColor = UIColor(rgb: 0xA492D0)
    let selectedTextColor = UIColor(rgb: 0xA492D0)
    
    
    var calendarView: JTAppleCalendarView!
    let cellId = "id"
    let formatter = DateFormatter()
    
    let monthLabel:  UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: lbl.font.fontName, size: 34)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    let yearLabel:  UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: lbl.font.fontName, size: 20)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    var dayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Setup
    private func setupView() {
        self.view.backgroundColor = backgroundColor
        
        self.calendarView = JTAppleCalendarView()
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.backgroundColor = .clear
        self.calendarView.register(CustomCalendarCell.self, forCellWithReuseIdentifier: cellId)
        self.view.addSubview(calendarView)
        self.view.addSubview(monthLabel)
        self.view.addSubview(yearLabel)
        
        self.calendarView.visibleDates() { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "yyyy"
            self.yearLabel.text = self.formatter.string(from: date)
        }
        
        setupDaysView()
        
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: calendarView)
        self.view.addContraintsWithFormat(format: "V:|-55-[v0]-15-[v1]-10-[v2][v3(240)]", views: yearLabel,monthLabel,dayView,calendarView)
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: dayView)
        self.view.addContraintsWithFormat(format: "H:|-20-[v0]", views: monthLabel)
        self.view.addContraintsWithFormat(format: "H:|-20-[v0]", views: yearLabel)
        
    }
    
    private func setupDaysView() {
        self.view.addSubview(dayView)
        
        let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        var daysLabels = [UILabel]()
        
        for day in days {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = day
            lbl.textAlignment = .center
            lbl.textColor = insideTextColor
            daysLabels.append(lbl)
        }
        
        for lbl in daysLabels {
            self.dayView.addSubview(lbl)
            self.dayView.addContraintsWithFormat(format: "V:|[v0]|", views: lbl)
        }
        
        self.dayView.backgroundColor = .clear
        self.dayView.addContraintsWithFormat(format: "H:|[v0(60)][v1(60)][v2(60)][v3(60)][v4(60)][v5(60)][v6]|", views: daysLabels[0],daysLabels[1],daysLabels[2],daysLabels[3],daysLabels[4],daysLabels[5],daysLabels[6])
        
    }
    
    func handleTextColor(view:JTAppleCell?,cellState: CellState) {
        guard let validCell = view as? CustomCalendarCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedTextColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = insideTextColor
            } else {
                validCell.dateLabel.textColor = outsideTextColor
            }
        }
    }
    
    func handleCellSelectedColor(view: JTAppleCell?) {
        guard let validCell = view as? CustomCalendarCell else { return }
        
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }

}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCalendarCell
        cell.dateLabel.text = cellState.text
        handleCellSelectedColor(view: cell)
        handleTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "MM dd yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 01 2018")
        let endDate = formatter.date(from: "01 01 2019")
        
        return ConfigurationParameters(startDate: startDate!, endDate: endDate!)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = formatter.string(from: date)
        
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelectedColor(view: cell)
        handleTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelectedColor(view: cell)
        handleTextColor(view: cell, cellState: cellState)
    }
    
    
}
