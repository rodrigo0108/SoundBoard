//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Rodrigo Ramos on 2/05/18.
//  Copyright © 2018 Ramos. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    func setupRecorder(){
        do{
            //creando una sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creando una direcciòn para el archivo de audio
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*********************")
            print(audioURL!)
            print("*********************")
            
            //crear opciones para el grabador de audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabacion de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
    }
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //Detener la grabación
            audioRecorder?.stop()
            //Cambiar el nombre del boton grabar
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }else{
            // empezar a grabar
            audioRecorder?.record()
            // cambiar el titulo del boton a detener
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        }catch{}
    }
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!) as Data?
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
