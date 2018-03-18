//
//  PresentsTableViewController.swift
//  PresentIdea
//
//  Created by Markus Fox on 28.08.17.
//  Copyright © 2017 Markus Fox. All rights reserved.
//

import UIKit
import CoreData
import Vision

class PresentsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var presents = [Present]()
    
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        let iconImageView = UIImageView(image: UIImage(named: "Shape"))
        self.navigationItem.titleView = iconImageView
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData() {
        let presentRequest: NSFetchRequest<Present> = Present.fetchRequest()
        
        do {
            presents = try managedObjectContext.fetch(presentRequest)
            self.tableView.reloadData()
        } catch {
            print("Could not save data \(error.localizedDescription)")
        }
    }
    
    //Code for SlideOut Menu
    let slideMenuLauncher = SlideMenuLauncher()
    
    @IBAction func handleSlideOutMenu(_ sender: Any) {
        slideMenuLauncher.showSlideMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PresentsTableViewCell
        
        let presentItem = presents[indexPath.row]
        
        if let presentImage = UIImage(data: presentItem.image! as Data) {
            cell.backgroundImageView.image = presentImage
        }
        cell.nameLabel.text = presentItem.person
        cell.itemLabel.text = presentItem.presentName
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPresentDetail", let destination = segue.destination as? DetailViewController, let cellIndex = tableView.indexPathForSelectedRow?.row {
            destination.present = presents[cellIndex]
        }
    }

    @IBAction func addPresent(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.createPresentItem(with: image)
            })
        }
        
    }
    
    func createPresentItem (with image: UIImage) {
        
        var observationString: String = ""
        //var observationProbability: Float = 0
        let ciImage = CIImage(image: image)
        
        // MARK: COREML PART HERE
        let model = try? VNCoreMLModel(for: Resnet50().model)
        
        let request = VNCoreMLRequest(model: model!) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            guard let topResult = results.first else { return }
            observationString = topResult.identifier
            //observationProbability = topResult.confidence * 100
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage!)
        try? handler.perform([request])
        
        // END COREML
        
        //Standard Input Alert
        let inputAlert = UIAlertController(title: "New Present", message: "Enter a person and a present", preferredStyle: .alert)
        inputAlert.addTextField { (textfield: UITextField) in
            textfield.placeholder = "Person"
        }
        inputAlert.addTextField { (textfield: UITextField) in
            textfield.placeholder = observationString
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            let presentItem = Present(context: self.managedObjectContext)
            presentItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!) as Data
            
            let personTextField = inputAlert.textFields?.first
            let presentTextField = inputAlert.textFields?.last
            
            if personTextField?.text != "" && presentTextField?.text != "" {
                presentItem.person = personTextField?.text
                presentItem.presentName = presentTextField?.text
                presentItem.obtained = false
                
                do {
                    try self.managedObjectContext.save()
                    self.loadData()
                } catch {
                    print("Could not save data \(error.localizedDescription)")
                }
            }
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
    }

}
