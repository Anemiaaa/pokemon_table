//
//  TableAdapter.swift
//  pokemon_table
//
//  Created by mac on 15.02.2022.
//

import Foundation
import UIKit
import RxSwift

public enum TableEvents {
    
    case didSelect(indexPath: IndexPath)
    case handleCellEvents(at: IndexPath, events: Any)
}

public class TableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    // MARK: -
    // MARK: Variables
    
    public var sections = [Section]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    public let statesHandler = PublishSubject<TableEvents>()
    
    private var prefetchCells: [IndexPath: UITableViewCell] = [:]
    private weak var tableView: UITableView?
    
    // MARK: -
    // MARK: Initialization
    
    public init(tableView: UITableView?, cells: [UITableViewCell.Type]) {
        self.tableView = tableView
        
        super.init()
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.prefetchDataSource = self
        
        cells.forEach {
            self.tableView?.register(for: $0)
        }
    }
    
    // MARK: -
    // MARK: UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections[section].models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.prefetchCells[indexPath] {
            self.prefetchCells.removeValue(forKey: indexPath)
            return cell
        }
        return self.cell(tableView: tableView, indexPath: indexPath)
    }
    
    // MARK: -
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.statesHandler.onNext(.didSelect(indexPath: indexPath))
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.prefetchCells.removeValue(forKey: indexPath)
    }
    
    // MARK: -
    // MARK: UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { index in
            let cell = self.cell(tableView: tableView, indexPath: index)
            self.prefetchCells[index] = cell
        }
    }
    
    // MARK: -
    // MARK: Private
    
    private func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(with: section.cell, for: indexPath)
        
        if let cell = cell as? AnyCellType {
            cell.fill(with: section.models[indexPath.row], eventHandler: { [weak self] events in
                self?.statesHandler.onNext(.handleCellEvents(at: indexPath, events: events))
            })
        }
        
        return cell
    }
}
