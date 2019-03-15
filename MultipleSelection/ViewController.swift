//
//  ViewController.swift
//  MultipleSelection
//
//  Created by Prashant on 15/03/19.
//  Copyright © 2019 Prashant. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private let dataSource = { () -> [Array<AHTag>] in
        let URL = Bundle.main.url(forResource: "TagGroups", withExtension: "json")!
        do {
            let data = try Data(contentsOf: URL)
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let groups = object as? [[[String : Any]]] else {
                fatalError("Not in an expected form of [[[String : Any]]]")
            }
            //print(groups.map({ return $0.map({ AHTag(dictionary: $0) }) }))
            return groups.map({ return $0.map({ AHTag(dictionary: $0) }) })
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }()
    
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.dataSource = self
        self.tblView.delegate = self
        
        let nib = UINib(nibName: "AHTagTableViewCell", bundle: nil)
        self.tblView.register(nib, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource[section][0].category
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(_ object: AnyObject, atIndexPath indexPath: IndexPath) {
        if object.isKind(of: AHTagTableViewCell.classForCoder()) == false {
            abort()
        }
        let cell = object as! AHTagTableViewCell
        let tags = self.dataSource[indexPath.section]
        cell.label.setTags(tags)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.textLabel?.textColor = UIColor.darkGray
    }

}

