//
//  DisplayViewController.swift
//  nekofiles
//
//  Created by samara on 2/24/24.
//  Copyright (c) 2024 Samara M (khcrysalis)
//

import UIKit

class DisplayViewController: UITableViewController {

	let tableData = [
		[String.localized("APP_SIGNING_INPUT_VIEW_CONTROLLER_SECTION_TITLE_APPEARENCE")],
		["Collection View"],
		[]
	]
	
	var sectionTitles = [
		"",
		String.localized("DISPLAY_VIEW_CONTROLLER_SECTION_TITLE_TINT_COLOR"),
		String.localized("DISPLAY_VIEW_CONTROLLER_SECTION_TITLE_APP_APPEARENCE")
	]

	let collectionData = ["Default", "Berry", "Mint", "Dr Pepper", "Cool Blue", "Fuchsia", "Purplish"]
	let collectionDataColors = ["848ef9", "ff7a83", "a6e3a1", "711f25", "4161F1", "FF00FF", "D7B4F3"]
	
	init() { super.init(style: .insetGrouped) }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = String.localized("SETTINGS_VIEW_CONTROLLER_CELL_DISPLAY")
		self.navigationItem.largeTitleDisplayMode = .never
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionCell")
	}
	
	func updateAppearance(with style: UIUserInterfaceStyle) {
		view.window?.overrideUserInterfaceStyle = style
		Preferences.preferredInterfaceStyle = style.rawValue
	}
}

extension DisplayViewController {
	override func numberOfSections(in tableView: UITableView) -> Int { return sectionTitles.count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sectionTitles[section] }
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return sectionTitles[section].isEmpty ? 5 : 40 }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 2 {
			return 3
		} else {
			return tableData[section].count
		}
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = sectionTitles[section]
		let headerView = InsetGroupedSectionHeader(title: title)
		return headerView
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let reuseIdentifier = "Cell"
		var cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
		cell.selectionStyle = .none
		
		if indexPath.section == 2 {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = String.localized("DISPLAY_VIEW_CONTROLLER_CELL_DEFAULT_SUBTITLE")
				cell.detailTextLabel?.text = String.localized("DISPLAY_VIEW_CONTROLLER_CELL_DEFAULT_SUBTITLE_DESCRIPTION")
			case 1:
				cell.textLabel?.text = String.localized("DISPLAY_VIEW_CONTROLLER_CELL_LOCALIZED_SUBTITLE")
				cell.detailTextLabel?.text = String.localized("DISPLAY_VIEW_CONTROLLER_CELL_LOCALIZED_SUBTITLE_DESCRIPTION")
			case 2:
				cell.textLabel?.text = String.localized("DISPLAY_VIEW_CONTROLLER_CELL_BIG_DESCRIPTION")
				cell.detailTextLabel?.text = String.localized("DISPLAY_VIEW_CONTROLLER_CELL_BIG_DESCRIPTION_DESCRIPTION")
			default:
				break
			}
			cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
			cell.detailTextLabel?.textColor = .secondaryLabel
			cell.textLabel?.numberOfLines = 0
			cell.detailTextLabel?.numberOfLines = 0

			if Preferences.appDescriptionAppearence == indexPath.row {
				cell.accessoryType = .checkmark
			} else {
				cell.accessoryType = .none
			}
			return cell
		}
		
		let cellText = tableData[indexPath.section][indexPath.row]
		switch cellText {
		case String.localized("APP_SIGNING_INPUT_VIEW_CONTROLLER_SECTION_TITLE_APPEARENCE"):
			cell.textLabel?.text = String.localized("APP_SIGNING_INPUT_VIEW_CONTROLLER_SECTION_TITLE_APPEARENCE")
			let segmentedControl = UISegmentedControl(items: UIUserInterfaceStyle.allCases.map { $0.description })
			segmentedControl.selectedSegmentIndex = UIUserInterfaceStyle.allCases.firstIndex { $0.rawValue == Preferences.preferredInterfaceStyle } ?? 0
			segmentedControl.addTarget(self, action: #selector(appearanceSegmentedControlChanged(_:)), for: .valueChanged)
			cell.accessoryView = segmentedControl

		case "Collection View":
			let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
			cell.setData(collectionData: collectionData, colors: collectionDataColors)
			cell.backgroundColor = .clear
			return cell
		default:
			break
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 2 {
			let previousSelection = Preferences.appDescriptionAppearence
			Preferences.appDescriptionAppearence = indexPath.row

			let previousIndexPath = IndexPath(row: previousSelection, section: indexPath.section)
			tableView.reloadRows(at: [previousIndexPath, indexPath], with: .fade)
		}
	}

	
	@objc private func appearanceSegmentedControlChanged(_ sender: UISegmentedControl) {
		let selectedStyle = UIUserInterfaceStyle.allCases[sender.selectedSegmentIndex]
		updateAppearance(with: selectedStyle)
	}
}

