//
//  ViewController.swift
//  ListView
//
//  Created by Farhan Arshad on 1/26/18.
//  Copyright © 2018 Farhan Arshad. All rights reserved.
//
//Country List Taken From: https://paulund.co.uk/list-countries-json

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, SelectionDialogProtocol {
    
    @IBOutlet weak var txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txt.delegate = self
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        readFile()
        return false
    }
    func readFile(){
        if let path = Bundle.main.path(forResource: "Countries", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let mytext = try String(contentsOf: url)
                if let data = mytext.data(using: .utf8){
                    do{
                        let info = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                        let data = info.map({ (obj) -> SelectionDialogStruct in
                            let d = obj as! NSDictionary
                            var data = SelectionDialogStruct()
                            data.id = (d.value(forKey: "code") as! String)
                            data.title = (d.value(forKey: "name") as! String)
                            data.description = (d.value(forKey: "code") as! String)
                            return data
                        })
                        let dialog = SelectionDialog()
                        dialog.data = data
                        dialog.delegate = self
                        dialog.dialogTitle = "Select Dialog"
                        dialog.modalTransitionStyle = .crossDissolve
                        dialog.modalPresentationStyle = .overCurrentContext
                        self.present(dialog, animated: true, completion: nil)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                
            } catch {
                print("error loading contents of:", path, error)
            }
        }
        
        
    }
    func selectionDialogProtocol(selection: SelectionDialogStruct) {
        txt.text = selection.title
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

