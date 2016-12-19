//
//  GLTableCollectionViewController.swift
//  GLTableCollectionView
//
//  Created by Giulio Lombardo on 24/11/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import UIKit

class GLTableCollectionViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	// This string constant will be the cellIdentifier for the UITableViewCells
	// holding the UICollectionView, it's important to append "_section#" to it
	// so we can understand which cell is the one we are looking for in the
	// debugger. Look in UITableView's data source cellForRowAt method for more
	// explainations about the UITableViewCell reuse handling.
	let tableCellID: String = "tableViewCellID_section_#"
	let collectionCellID: String = "collectionViewCellID"

	let numberOfSections: Int = 20
	let numberOfCollectionsForRow: Int = 1
	let numberOfCollectionItems: Int = 20

	var colorsDict: [Int: [UIColor]] = [:]

	/// Set true to enable UICollectionViews scroll pagination
	var paginationEnabled: Bool = true

	override func viewDidLoad() {
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between
		// presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the
		// navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()

		for tableViewSection in 0..<numberOfSections {
			var colorsArray: [UIColor] = []

			for _ in 0..<numberOfCollectionItems {
				var randomRed: CGFloat = CGFloat(arc4random_uniform(256))
				let randomGreen: CGFloat = CGFloat(arc4random_uniform(256))
				let randomBlue: CGFloat = CGFloat(arc4random_uniform(256))

				if (randomRed == 255.0 && randomGreen == 255.0 && randomBlue == 255.0) {
					randomRed = CGFloat(arc4random_uniform(128))
				}

				colorsArray.append(UIColor(red: randomRed/255.0, green: randomGreen/255.0, blue: randomBlue/255.0, alpha: 1.0))
			}

			colorsDict[tableViewSection] = colorsArray
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: <UITableView Data Source>

	override func numberOfSections(in tableView: UITableView) -> Int {
		return numberOfSections
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfCollectionsForRow
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Instead of having a single cellIdentifier for each type of
		// UITableViewCells, like in a regular implementation, we have multiple
		// cellIDs, each related to a indexPath section. By Doing so the
		// UITableViewCells will still be recycled but only with
		// dequeueReusableCell of that section.
		//
		// For example the cellIdentifier for section 4 cells will be:
		// "tableViewCellID_section_#3"
		// dequeueReusableCell will only reuse previous UITableViewCells with
		// the same cellIdentifier instead of using any UITableViewCell as a
		// regular UITableView would do, this is necessary because every cell
		// will have a different UICollectionView with UICollectionViewCells in
		// it and UITableView reuse won't work as expected giving back wrong
		// cells.
		var cell: GLCollectionTableViewCell? = tableView.dequeueReusableCell(withIdentifier: tableCellID + indexPath.section.description) as? GLCollectionTableViewCell

		if cell == nil {
			cell = GLCollectionTableViewCell(style: .default, reuseIdentifier: tableCellID + indexPath.section.description)

			// Configure the cell...
			cell!.selectionStyle = .none
			cell!.collectionViewScrollPagination = paginationEnabled
		}

		return cell!
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Section: " + section.description
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 88
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 28
	}

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.0001
	}

	// MARK: <UITableView Delegate>

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? GLCollectionTableViewCell else {
			return
		}

		cell.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self, indexPath: indexPath)
	}

	// MARK: <UICollectionView Data Source>

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfCollectionItems
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: GLIndexedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! GLIndexedCollectionViewCell

		// Configure the cell...
		cell.backgroundColor = colorsDict[(collectionView as! GLIndexedCollectionView).indexPath.section]?[indexPath.row]

		return cell
	}

	// MARK: <UICollectionViewDelegate Flow Layout>

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 65, height: 65)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, 10, 0, 10)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	// MARK: <UICollectionView Delegate>

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}

    /*
    // MARK: <Navigation>

    // In a storyboard-based application, you will often want to do a little
	// preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
