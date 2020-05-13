//
//  ViewController.swift
//  AnyPaySampleApp-Swift
//
//  Created by Ankit Gupta on 11/06/18.
//  Copyright © 2018 Dan McCann. All rights reserved.
//

import UIKit

class PPSViewController: UIViewController {
    
    @IBOutlet public weak var textView: UITextView?
    
    private var transaction: AnyPayTransaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //API call to clear saved terminal
        /*
        if AnyPay.isTerminalActivated() {
            AnyPay.clearTerminalState()
        }
        */
        
        let anypay:AnyPay = AnyPay.initialise()
        let endpoint = anypay.terminal.endpoint as! ANPPriorityPaymentsEndpoint
        endpoint.consumerKey = "PriorityPayments_ConsumerKey"
        endpoint.consumerSecret = "PriorityPayments_ConsumerSecret"
        endpoint.merchantID = "PriorityPayments_MerchantID"
        endpoint.gatewayUrl = "https://sandbox.api.mxmerchant.com/checkout/v3/"
        
        anypay.terminal.endpoint.authenticateTerminal { (authenticated, error) in
            if (authenticated) {
                self.appendText(text: "Terminal Authenticated")
                print("AUTHENTICATED")
                
                self.subscribe();
            }
        }
        
//        [[NSBundle mainBundle] pathForResource:@"terminal" ofType:@"json"]//
        print("AnyPay Version %@ --- %@", AnyPay.currentVersion(), anypay.terminal.endpoint.gatewayUrl as Any)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func subscribe() {
        ANPCardReaderController.shared().subscribe (onCardReaderConnected: { (reader:AnyPayCardReader?) in
            print("\n\n Connected Reader Name %@", reader?.name() as Any)
            self.appendText(text: "OnCardReaderConnected --- " + (reader?.emvKsn)!)
        })
        
        ANPCardReaderController.shared().subscribe {
            print("OnCardReaderDisConnected");
            self.appendText(text: "Card Reader Disconnected")
        }
        
        ANPCardReaderController.shared().subscribe(onCardReaderError: { (error:ANPMeaningfulError?) in
            print("\n\n OnCardReaderError %@", error as Any)
            self.appendText(text: "OnCardReaderError --- " + (error?.message!)!)
        })
        
        
        ANPCardReaderController.shared().subscribe(onCardReaderConnectionFailed: { (error:ANPMeaningfulError?) in
            print("\n\n OnCardReaderConnectionFailed %@", error as Any)
            self.appendText(text: "OnCardReaderConnectionFailed --- " + (error?.message!)!)
        })
    }
    
    @IBAction func connectToBTReader() {
        self.appendText(text: "Connecting to BT reader")
        
        ANPCardReaderController.shared().connectBluetoothReader { (devices:[ANPBluetoothDevice]?) in
            ANPCardReaderController.shared().connect(toBluetoothReader: devices![0])
        }
    }
    
    @IBAction func connectToAudioReader() {
        self.appendText(text: "Connecting to Audio reader")
        
        ANPCardReaderController.shared().connectAudioReader()
    }
    
    @IBAction func emvSale(_ sender: Any?) {
        let tr = AnyPayTransaction(type: ANPTransactionType.SALE);
        tr?.totalAmount = ANPAmount.init(string: "222.89")
        tr?.currency = "USD";
        
        //For Swipe only
        //tr?.cardReader.selectedCardInterface = ANPCardReaderInterface.swipe;
        
        self.transaction = tr!;
        
        /*
         tr?.setOnSignatureRequired({
         print("ON SIGNATURE REQUIRED")
         
         })
         */
        
        tr?.execute({ (status, error) in
            if (status == ANPTransactionStatus.APPROVED) {
                
                let r : AnyPayTransaction = ANPDatabase.getTransactionWithId(tr?.internalID) as! AnyPayTransaction
                
                print("SALE APPROVED %@", r.externalID);
                
                self.appendText(text: "SALE APPROVED " + r.externalID + " with total - " + r.totalAmount.stringValue)
            }
            else {
                print("Error %@", error?.message ?? "")
                self.appendText(text: "SALE ERROR " + (error?.message)!)
            }
        }, cardReaderEvent: { (message) in
            print("Message %@", message?.message ?? "")
            self.appendText(text: (message?.message)!)
        })
    }
    
    @IBAction func refund(_ sender: Any?) {
        if self.transaction == nil {
            self.appendText(text: "Process a sale transaction first")
            return;
        }

        let tr = AnyPayTransaction(type: ANPTransactionType.VOID);
        tr?.refTransactionID = self.transaction?.externalID;
        
        
        //For reference refund
        //        tr?.refTransactionID = self.transaction?.customProperties["paymentToken"] as! String

        tr?.execute({ (status, error) in
            if (status == ANPTransactionStatus.APPROVED) {

                let r : AnyPayTransaction = ANPDatabase.getTransactionWithId(tr?.internalID) as! AnyPayTransaction

                print("REFUND APPROVED %@", r.externalID);

                self.appendText(text: "REFUND APPROVED")
            }
            else {
                print("Error %@", error?.message ?? "")
                self.appendText(text: "REFUND ERROR " + (error?.message)!)
            }
        })
        
    }
    
    @IBAction func unrefrefund(_ sender: Any?) {
        if self.transaction == nil {
            self.appendText(text: "Process a sale transaction first")
            return;
        }
        
        let tr = AnyPayTransaction(type: ANPTransactionType.REFUND);
        tr?.totalAmount = ANPAmount.init(string: "11.00")

        
        tr?.cardNumber = "4111111111111111"
        tr?.cardExpiryMonth = "12";
        tr?.cardExpiryYear = "20";
        tr?.cardType = "VISA";
        tr?.cardHolderName = "Jane Dough";
        tr?.cvv2 = "123";
        tr?.currency = "USD";
        tr?.postalCode = "54321"
        tr?.address = "Address"
        
        tr?.execute({ (status, error) in
            if (status == ANPTransactionStatus.APPROVED) {
                
                let r : AnyPayTransaction = ANPDatabase.getTransactionWithId(tr?.internalID) as! AnyPayTransaction
                
                print("REFUND APPROVED %@", r.externalID);
                
                self.appendText(text: "REFUND APPROVED")
            }
            else {
                print("Error %@", error?.message ?? "")
                self.appendText(text: "REFUND ERROR " + (error?.message)!)
            }
        })
        
    }
    
    @IBAction func keyedSale(_ sender: Any?) {
        let tr = AnyPayTransaction(type: ANPTransactionType.SALE);
        tr?.totalAmount = ANPAmount.init(string: "100.00")
        tr?.cardNumber = "4111111111111111"
        tr?.cardExpiryMonth = "12";
        tr?.cardExpiryYear = "20";
        tr?.cardType = "VISA";
        tr?.cardHolderName = "Jane Dough";
        tr?.cvv2 = "123";
        tr?.currency = "USD";
        tr?.postalCode = "54321"
        tr?.address = "Address"
        
        self.transaction = tr!;
        
        tr?.execute({ (status, error) in
            if (status == ANPTransactionStatus.APPROVED) {
                
                let r : AnyPayTransaction = ANPDatabase.getTransactionWithId(tr?.internalID) as! AnyPayTransaction
                
                self.appendText(text: "SALE APPROVED " + r.externalID)
                self.appendText(text: "SALE APPROVED " + r.externalID + " with total - " + r.totalAmount.stringValue)
                
            }
            else {
                self.appendText(text: "SALE ERROR " + (error?.message)!)
                print("Error %@", error?.message ?? "")
            }
            
        })
    }
    
    private func appendText(text: String) {
        let messageWithNewLine = text.appending("\n")
        
        let p: CGPoint = (textView?.contentOffset)!
        textView?.insertText(messageWithNewLine)
        
        textView?.setContentOffset(p, animated: false)
        textView?.scrollRangeToVisible(NSMakeRange((textView?.text.count)!, 0))
    }
    
    
    @IBAction func disconnect() {
        ANPCardReaderController.shared().disconnectReader()
    }
}

