//
//  ViewController.swift
//  Image Recognizer
//
//  Created by Muhamed Alkhatib on 12/09/2020.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing=false
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image=info[.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
      
        let pickedImage=CIImage(image: info[.originalImage] as! UIImage)
       detectImage(pickedImage!)
       
    }
    


   
    @IBOutlet weak var lable: UILabel!
    
    func detectImage (_ pickedImage: CIImage) {
    
        //1. Load the model (Create model)
        
        let model = try? VNCoreMLModel(for: MobileNetV2().model)
        
        
        //2. Create request
        
        let request = VNCoreMLRequest(model: model!) { (request, error) in
            
            let results = request.results as? [VNClassificationObservation]
            
            print(results?.first?.identifier)
            
            self.lable.text=results?.first?.identifier
            
            
        }
        
        //3. Perform the request
        
        let handler = VNImageRequestHandler(ciImage: pickedImage)
        
        do {
        try handler.perform([request])
        }catch {
            print ("error")
        }
            
    }
}

