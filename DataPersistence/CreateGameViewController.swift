//
//  CreateGameViewController.swift
//  DataPersistence
//
//  Created by Colin Otchere on 11.06.16.
//  Copyright © 2016 iOS Dev Kurs Universität Heidelberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreateGameViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var teamA: UILabel!
    @IBOutlet weak var teamB: UILabel!
    @IBOutlet weak var teamAPicker: UIPickerView!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var teamBPicker: UIPickerView!
    @IBOutlet weak var group: UILabel!
    
    var context: NSManagedObjectContext!
    var gameday: Gameday!
    
    let team = ["Frankreich","Schweiz","Rumänien","Albanien","England","Russland","Slowakei",
                      "Wales","Deutschland","Nordirland","Polen","Ukraine","Kroatien","Tsch. Republik",
                      "Spanien","Türkei","Belgien","Italien","Irland","Schweden","Österreich",
                      "Ungarn","Island","Portugal"]
    
    let teamgroup = ["Gruppe A","Gruppe B","Gruppe C","Gruppe D","Gruppe E","Gruppe F"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamAPicker.dataSource = self
        teamAPicker.delegate = self
        
        teamBPicker.dataSource = self
        teamBPicker.delegate = self
        
        groupPicker.dataSource = self
        groupPicker.delegate = self
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == teamAPicker{
            return team.count
        }
        else if pickerView == teamBPicker{
            return team.count
        }
        else if pickerView == groupPicker{
            return teamgroup.count
        }
        else{
            return 0
        }
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == teamAPicker {
            return team[row]
        }
        else if pickerView == teamBPicker {
            return team[row]
        }
        else if pickerView == groupPicker {
            return teamgroup[row]
        }
        else{
            return ""
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == teamAPicker {
            teamA.text =  team[row]
        }
        else if pickerView == teamBPicker {
            teamB.text =  team[row]
        }
        else if pickerView == groupPicker {
            group.text =  teamgroup[row]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            
        case "saveGame":
            
            // Create list and set properties
            let list = NSEntityDescription.insertNewObjectForEntityForName("Game", inManagedObjectContext: context) as! Game
            list.gameday = gameday
            list.teamA = teamA.text ?? "Unnamed List"
            list.teamB = teamB.text ?? "Unnamed List"
            // Save context
            do {
                try context.save()
            } catch {
                print("Failed saving context: \(error)")
            }
            
        default:
            break
        }
    }
}