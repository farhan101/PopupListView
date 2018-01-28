
import UIKit


//Help: https://stackoverflow.com/questions/11236367/display-clearcolor-uiviewcontroller-over-uiviewcontroller

struct SelectionDialogStruct{

    var id : String?
    var title: String?
    var description: String?
    
}
struct SelectionDialogFields{
    
    static let id = "id"
    static let title = "title"
    static let description = "description"
    
}

class SelectionDialog: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mBase: UIView!
    @IBOutlet weak var mCrossBack: UIView!
    @IBOutlet weak var mTable: UITableView!
    @IBOutlet weak var mtxtSearch: UITextField!
    @IBOutlet weak var mlblDialogTitle: UILabel!
    
    //fileprivate var mData : NSArray?
    fileprivate var mData : [SelectionDialogStruct]?
    
    var delegate: SelectionDialogProtocol!
    
    var data : [SelectionDialogStruct]{
    
        set{
            mData = newValue
        }
        get{
            return mData!
        }
    }
    var dialogTitle: String?{
        willSet{}

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        mBase.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionCross(_ :)))
        mCrossBack.addGestureRecognizer(tap)
        mTable.dataSource = self
        mTable.delegate = self
        mtxtSearch.delegate = self
        mtxtSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        if (dialogTitle != nil) {
            mlblDialogTitle.text = dialogTitle
        }
        
    }

    @objc func textFieldDidChange(textField: UITextField){
        
        mTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if mtxtSearch.text! == ""{
            
            return 60.0
        }
        
        var height: CGFloat = 0.0
        
        let data: SelectionDialogStruct = mData![indexPath.row]
        let title = data.title
        
        if title?.lowercased().range(of: mtxtSearch.text!.lowercased()) != nil{
            
            height = 60.0
            
        }
        
        
        return height
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.rectForRow(at: indexPath).height == 0.0 {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        
        let data: SelectionDialogStruct = mData![indexPath.row]
        cell.textLabel?.text = data.title
        cell.textLabel?.textColor = UIColor.darkGray
        cell.detailTextLabel?.text = data.description
        cell.detailTextLabel?.textColor = UIColor.lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let data: SelectionDialogStruct = self.mData![indexPath.row]
            self.dismiss(animated: true) {
                self.delegate.selectionDialogProtocol(selection: data)
            }
        }
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

protocol SelectionDialogProtocol {
    func selectionDialogProtocol(selection: SelectionDialogStruct)
}
