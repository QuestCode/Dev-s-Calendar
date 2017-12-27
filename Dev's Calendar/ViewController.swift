//
//  ViewController.swift
//  Dev's Calendar
//
//  Created by Devontae Reid on 12/26/17.
//  Copyright © 2017 Devontae Reid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var calendarView: JTAppleCalendarView!
    let cellId = "id"
    let formatter = DateFormatter()
    let monthLabel:  UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.backgroundColor = .gray
        lbl.textColor = .black
        return lbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Setup
    private func setupView() {
        self.calendarView = JTAppleCalendarView()
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.backgroundColor = .gray
        self.calendarView.register(CustomCalendarCell.self, forCellWithReuseIdentifier: cellId)
        self.view.addSubview(calendarView)
        self.view.addSubview(monthLabel)
        
        self.calendarView.visibleDates() { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
        }
        
        self.view.addContraintsWithFormat(format: "H:|[v0]|", views: calendarView)
        self.view.addContraintsWithFormat(format: "V:|-35-[v0][v1(240)]", views: monthLabel,calendarView)
        self.view.addContraintsWithFormat(format: "H:|[v0]", views: monthLabel)
        
        
    }

}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCalendarCell
        cell.dateLabel.text = cellState.text
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "MM dd yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 01 2018")
        let endDate = formatter.date(from: "02 01 2018")
        
        return ConfigurationParameters(startDate: startDate!, endDate: endDate!)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    
}
