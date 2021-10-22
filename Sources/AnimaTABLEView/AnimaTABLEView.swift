//  AnimaTableView.swift
//  AnimaTableView
//
//  Created by Abdul Waheed on 22/10/2021.
//  Copyright © 2021 Abdul Waheed. All rights reserved.


import UIKit

@objc public protocol AnimaTableViewDelegate: AnyObject {
    func numberOfRows(in section: Int) -> Int
    @objc optional func numberOfSections() -> Int
    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    @objc optional func willDisplay(cell: UITableViewCell, at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

open class AnimaTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
   
    public weak var tableDelegate: AnimaTableViewDelegate?
    public var animationType: TableAnimationType = .none
    
    public var onlyShowsWhileReloading = false
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        precondition(tableDelegate != nil, "Table Delegate cannot be nil. Kindly conform to AnimaTableViewDelegate Protocol")
        return tableDelegate?.numberOfRows(in: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        precondition(tableDelegate != nil, "Table Delegate cannot be nil. Kindly conform to AnimaTableViewDelegate Protocol")
        return tableDelegate?.cellForRow(at: indexPath, in: tableView) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableDelegate?.didSelectRow(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableDelegate?.willDisplay?(cell: cell, at: indexPath)
        
        if onlyShowsWhileReloading {
            return
        }
        // Cell Appearance Animation
        animate(cells: [cell])
    }
    
    open override func reloadData() {
        super.reloadData()
        
        if onlyShowsWhileReloading {
            animate(cells: visibleCells)
        }
    }
    
    private func animate(cells: [UITableViewCell]) {
        
        for cell in cells {
            
            switch animationType {
            case .none:
                ()
            case .fade:
                cell.alpha = 0
                
                UIView.animate(withDuration: 0.3, delay: 0.01, options: [.allowAnimatedContent, .allowUserInteraction, .curveLinear]) {
                    cell.alpha = 1
                }

            case .leftToRight:
                cell.transform = CGAffineTransform(translationX: bounds.width * -1, y: 0)
                UIView.animate(withDuration: 0.3, delay: 0.01, options: [.allowAnimatedContent, .allowUserInteraction, .curveLinear]) {
                    cell.transform = .identity
                }
            case .rightToLeft:
                cell.transform = CGAffineTransform(translationX: bounds.width , y: 0)
                UIView.animate(withDuration: 0.3, delay: 0.01, options: [.allowAnimatedContent, .allowUserInteraction, .curveLinear]) {
                    cell.transform = .identity
                }
            case .scale:
                cell.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.3, delay: 0.01, options: [.allowAnimatedContent, .allowUserInteraction, .curveLinear]) {
                    cell.transform = .identity
                }
            }
        }
    }
}
