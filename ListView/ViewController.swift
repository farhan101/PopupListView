//
//  ViewController.swift
//  ListView
//
//  Created by Farhan Arshad on 1/26/18.
//  Copyright © 2018 Farhan Arshad. All rights reserved.
//

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
        // get the documents folder url
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            
            // use path
            do {
                let url = URL(fileURLWithPath: path)
                let mytext = try String(contentsOf: url)
                //print(mytext)   // "some text\n"
                
                if let data = mytext.data(using: .utf8){
                    
                    //print(data)
                    do{
                        let info = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
//                        let flat = info.flatMap({ (obj) -> String in
//                            let arr = obj as! NSDictionary
//                            //print(arr)
//                            //print(arr.value(forKey: "value") as! String)
//                            return (arr.value(forKey: "value") as! String)
//                        })
//                        let flat = info.flatMap({ (obj) -> Any in
//                            let arr = obj as! NSDictionary
//                            //print(arr)
//                            //print(arr.value(forKey: "value") as! String)
//                            return arr
//                        })
//                        let flat = info.map({ (obj) -> String in
//                            let d = obj as! NSDictionary
//                            return d.value(forKey: "value") as! String
//                        })
//                        print(flat)
                        let data = info.map({ (obj) -> SelectionDialogStruct in
                            let d = obj as! NSDictionary
                            var data = SelectionDialogStruct()
                            data.id = (d.value(forKey: "id") as! String)
                            data.title = (d.value(forKey: "value") as! String)
                            data.description = (d.value(forKey: "details") as! String)
                            return data
                        })
                        let dialog = SelectionDialog()
                        dialog.data = data
                        dialog.delegate = self
                        dialog.dialogTitle = "Select Dialog"
                        dialog.modalTransitionStyle = .crossDissolve
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

