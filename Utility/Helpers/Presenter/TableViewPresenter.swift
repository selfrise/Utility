//
//  TableViewPresenter.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public final class TableViewPresenter: NSObject {
    public var didMoveAnyRow: Bool = false
    public var sections: [TableViewSectionData]
    public var rowAction: ((IndexPath, TableViewItem) -> Void)?
    
    public init(with sections: [TableViewSectionData]) {
        self.sections = sections
    }
}

extension TableViewPresenter: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowAction?(indexPath, sections[indexPath.section].rows[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sections[indexPath.section].rows[indexPath.row].height
    }
}

extension TableViewPresenter: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: data.identifier, for: indexPath)
        guard let reuseCell = cell as? TableViewCellReuseProtocol,
              let cellData = data.data else {
                  return UITableViewCell()
              }
        reuseCell.delegate = data.delegate
        reuseCell.setupCell(with: cellData)
        return cell
    }
    
    public func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cell.setSelected(sections[indexPath.section].rows[indexPath.row].isSelected, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].header?.view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].header?.height ?? .leastNonzeroMagnitude
    }
    
    // MARK: Editing
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        sections[indexPath.section].rows[indexPath.row].editingStyle
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        sections[indexPath.section].rows[indexPath.row].canMove
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    public func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        didMoveAnyRow = true
        sections[sourceIndexPath.section].rows.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
