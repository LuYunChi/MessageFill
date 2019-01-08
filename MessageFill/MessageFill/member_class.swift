//
//  member_class.swift
//  MessageFill
//
//  Created by Lu Yunchi on 2019/1/3.
//  Copyright © 2019 Lu Yunchi. All rights reserved.
//
import Foundation
import UIKit
import MessageUI
var Message_original:String!                                //input message
var Keywords:[String]=["","","","","",""]                   //words to be replaced
var Keynumber:Int!                                          //number of activated keys
var key_isActivated=[false,false,false,false,false,false]   //whether a key is used

class Member{
    var replacement=Dictionary<String,String>()             //<keyword,newword>
    var Message:String!                                     //processed message
    var status="to be sent"                                 //whether is message is sent
    var number:String=""                                    //phonenumber
    
    var textbox=Dictionary<String,UITextField>()            //<keyword,textfield>in view_body
    var phonebox:UITextField!                               //phonenumber in view_header
    var sendbutton:UIButton!                                //send button
    var controller:MFMessageComposeViewController!
    init(){}
    //to match textfield
    func addcontroller(temp:MFMessageComposeViewController){
        controller=temp
    }
    func addsendbutton(temp:UIButton){
        sendbutton=temp
    }
    func addphone(temp:UITextField){
        phonebox=temp
    }
    func addreplacement(temp:UITextField){
        guard temp.placeholder != nil else{return}
        textbox[temp.placeholder!]=temp
    }
    //to match values
    func refresh(){
        fillnumber()
        fillreplacements()
    }
    func fillnumber(){
        number=phonebox.text!
    }
    func fillreplacements(){                                //fill replacements in textfields into [replacement]
        for box in textbox{
            replacement[box.key]=box.value.text
        }
    }
    //to get final message
    func getmessage()->String{
        Message=Message_original
        guard Message != nil else{return ""}
        for i in 0..<6{
            if key_isActivated[i]{
                Message=Message.replacingOccurrences(of: Keywords[i], with: replacement[Keywords[i]] ?? "")
            }
        }
        return Message
    }
}
