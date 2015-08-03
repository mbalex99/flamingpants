//
//  ViewController.swift
//  FlamingPants
//
//  Created by Maximilian Alexander on 7/24/15.
//  Copyright (c) 2015 Epoque. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase
import SlackTextViewController
import FirebaseRxSwiftExtensions

class ViewController: SLKTextViewController {
    
    var messageModels : [MessageModel] = [MessageModel]()
    var messagesRef : Firebase
    var disposeBag = DisposeBag()
    var isInitialLoad = true;
    var name = "Max"
    
    var pressedRightButtonSubject : PublishSubject<String> = PublishSubject()
    
    init(){
        messagesRef = Firebase(url: "https://flamingpants-demo.firebaseio.com/").childByAppendingPath("messages");
        super.init(tableViewStyle: UITableViewStyle.Plain)
    }

    required init!(coder decoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.REUSE_ID)
        tableView.rowHeight = UITableViewAutomaticDimension //needed for autolayout
        tableView.estimatedRowHeight = 50.0 //needed for autolayout
        inverted = true
        
        messagesRef.rx_firebaseObserveEvent(FEventType.ChildAdded)
            >- filter { snapshot in
                return !(snapshot.value is NSNull)
            }
            >- map {snapshot in
                return MessageModel(snapshot: snapshot)
            }
            >- subscribeNext({ (messageModel: MessageModel) -> Void in
                self.messageModels.insert(messageModel, atIndex: 0);
                if(self.isInitialLoad == false){
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.tableView.endUpdates()
                    //you can do everything else here!
                }
            })
            >- disposeBag.addDisposable
        
        messagesRef.rx_firebaseObserveSingleEvent(FEventType.Value)
            >- subscribeNext({ (snapshot: FDataSnapshot) -> Void in
                self.tableView.reloadData()
                self.isInitialLoad = false;
            })
        
        
        pressedRightButtonSubject
            >- flatMap({ (bodyText: String) -> Observable<Firebase> in
                var name = self.name
                return self.messagesRef.childByAutoId().rx_firebaseSetValue(["name" : name, "body": bodyText])
            })
            >- subscribeNext({ (newMessageReference:Firebase) -> Void in
                println("A new message was successfully committed to firebase")
            })
            >- disposeBag.addDisposable
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        sendNext(pressedRightButtonSubject, self.textView.text)
        super.didPressRightButton(sender) // this important. calling the super.didPressRightButton will clear the method. We cannot use rx_tap due to inheritance
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /*let alertController = UIAlertController(title: "Need your name!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Your Name"
        }
        
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let nameTextField = alertController.textFields?[0] as! UITextField
            self.name = nameTextField.text
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)*/
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MessageTableViewCell.REUSE_ID, forIndexPath: indexPath) as! MessageTableViewCell

        var messageModelAtIndexPath = messageModels[indexPath.row]
        
        cell.nameLabel.text = messageModelAtIndexPath.name
        cell.bodyLabel.text = messageModelAtIndexPath.body
        
        cell.transform = self.tableView.transform //very important don't forget this
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

