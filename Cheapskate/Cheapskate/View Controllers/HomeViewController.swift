import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Data model: These strings will be the data for the table view cells
    var data: [String] = ["dog"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var add: UIButton!
    
    @IBAction func onRefresh(_ sender: Any) {
        data.removeAll()
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.backgroundColor = UIColor.init(red: 232/255, green: 206/255, blue: 191/255, alpha: 1)
        self.tableView.backgroundColor = UIColor.init(red: 232/255, green: 206/255, blue: 191/255, alpha: 1)
        Utilities.styleSmallButton(self.refreshButton)
        Utilities.styleSmallButton(self.add)

        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    func getSum( groupId : Int, previousSum : Int) -> Bool {
        
        return true
    }
    func findAndUpdateData( id : String) {
        let db = Firestore.firestore()

        db.collection("users").whereField("uid", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error finding group: \(err)")
                } else {
                    // Store data
                    for document in querySnapshot!.documents {
                        let dictionary : NSDictionary = document.data() as NSDictionary
                        let firstname = dictionary["firstname"] as! String
                        print(firstname)
                        var currentReceipt = [String: Int]()
                        currentReceipt = dictionary["receipt"] as! Dictionary
                        print(currentReceipt)
                        for (item, cost) in currentReceipt {
                            let s1 = firstname + ": $" + String(cost)
                            let s2 =  " - " + item
                            let s3 = s1+s2
                            self.data.append(s3)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
    }
                
    func loadData() {
        let db = Firestore.firestore()
        
        db.collection("groups").whereField("groupid", isEqualTo: user.groupId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting groupmates \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let dictionary : NSDictionary = document.data() as NSDictionary
                        
                        let member1Id = dictionary["member1"] as! String
                        self.findAndUpdateData(id: member1Id)
                        
                        let member2Id = dictionary["member2"] as! String
                        self.findAndUpdateData(id: member2Id)
                        
                        let member3Id = dictionary["member3"] as! String
                        self.findAndUpdateData(id: member3Id)
                        
                        let member4Id = dictionary["member4"] as! String
                        self.findAndUpdateData(id: member4Id)
                        
                    }
                    
                }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.data[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // remove the item from the data model
                data.remove(at: indexPath.row)

                // delete the table view row
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

}
