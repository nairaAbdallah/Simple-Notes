//
//  ViewController.swift
//  Simple Notes
//
//  Created by Naira Bassam on 03/08/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var simpleNotes: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let app = UINavigationBarAppearance()
        app.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9543606639, green: 0.9001446962, blue: 0.6991648078, alpha: 1), .font: UIFont(name: "Noteworthy-Bold", size: 40.0)!]
        app.backgroundColor = #colorLiteral(red: 0.6717447079, green: 0.3722832495, blue: 0.1999010568, alpha: 1)
        self.navigationController?.navigationBar.scrollEdgeAppearance = app
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleNotes.text = ""
        var notesIndex = 0.0
        let simpleNotesText = "Simple Notes"
        for letter in simpleNotesText {
            Timer.scheduledTimer(withTimeInterval: 0.25 * notesIndex, repeats: false) { (timer) in
                self.simpleNotes.text?.append(letter)
            }
            notesIndex += 1
        }
        Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { (timer) in
            self.performSegue(withIdentifier: "addNoteIdentifier", sender: self)
        }
    }


}

