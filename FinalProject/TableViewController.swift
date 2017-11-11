//
//  TableViewController.swift
//  FinalProject
//
//  Created by Yang Gao on 10/16/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        searchTextField.resignFirstResponder()
            
        }
    }
    var searchText: String? {
        didSet {
            searchTextField.text = searchText

        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }

    var landmarks = [Landmark]()

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    var indicator = UIActivityIndicatorView()

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Landmark> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.container?.viewContext)!, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    func loadData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 15.0

        LandmarkDataService.sharedInstance.loadData {
            self.loadData()
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }

        self.loadData()

        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let landmarks = fetchedResultsController.fetchedObjects else { return 0 }
        return landmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            fatalError("Unexpected Index Path")
        }

        // Fetch landmark
        let landmark = fetchedResultsController.object(at: indexPath)

        // Configure Cell
        cell.title.text = landmark.name
        cell.subtitle.text = landmark.desc
        return cell
    }
}

