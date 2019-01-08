//
//  ViewController.swift
//  MessageFill
//
//  Created by Lu Yunchi on 2019/1/3.
//  Copyright © 2019 Lu Yunchi. All rights reserved.
//

import UIKit
import MessageUI
class ViewController: UIViewController,UIScrollViewDelegate {
    var view_upper:UIView!
    var view_lower:UIView!
    var Height:CGFloat!
    var Width:CGFloat!
    var button2text=Dictionary<UIButton,UITextField>()
    var Recipients=[Member]()
    var number_filledmember=0
    var extrablank=0
    var sentnumber=0
    //overall view
    let scrollView = UIScrollView()
    
    //components
    let buttons:[UIButton]=[makebutton(0),makebutton(1),makebutton(2),makebutton(3),makebutton(4),makebutton(5)]
    let texts:[UITextField]=[maketext(0),maketext(1),maketext(2),maketext(3),maketext(4),maketext(5)]
    let matchview=UIImageView(frame: frame_match)
    let match=UIButton(frame: frame_match)
    let T_message=UITextView(frame: frame_message)
    let table=UITableView(frame:frame_table)
    let B_add=UIButton(type: .contactAdd)
    let B_clear=UIButton(frame: frame_clear)
    let footerlabel=UILabel(frame: frame_footerlabel)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        Height=view.bounds.height
        Width=view.bounds.width
        buildlayout()
    }
//layout------------------------------------------------------------------------------------------
    func buildlayout(){
        //scroll view
        scrollView.frame=self.view.frame
        scrollView.delegate=self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize.width=Width
        scrollView.contentSize.height=1.5*Height
        scrollView.bounces=false
        scrollView.canCancelContentTouches=true
        self.view.addSubview(scrollView)
        //background
        let backgroundview=UIImageView(frame: frame_background)
        backgroundview.image=#imageLiteral(resourceName: "background.png")
        scrollView.addSubview(backgroundview)
        let back=UIImageView(frame: self.view.frame)
        back.image=#imageLiteral(resourceName: "back.png")
        self.view.addSubview(back)
        self.view.sendSubviewToBack(back)
        //bubble and text
        let bubbleview=UIImageView(frame: frame_bubble)
        bubbleview.image=#imageLiteral(resourceName: "bubble.png")
        scrollView.addSubview(bubbleview)
        T_message.backgroundColor = UIColor.clear
        T_message.font = UIFont.systemFont(ofSize: 16)
        T_message.textColor=UIColor.white
        T_message.text="Input your template message here."
        T_message.delegate=self
        T_message.becomeFirstResponder()
        T_message.selectedRange=NSMakeRange(0, 33)
        T_message.inputAccessoryView=AddToolBar()
        scrollView.addSubview(T_message)
        //buttons and tfs
        for i in 0..<6{
            scrollView.addSubview(buttons[i])
            scrollView.addSubview(texts[i])
            button2text[buttons[i]]=texts[i]
            buttons[i].addTarget(self, action: #selector(button_action), for: .touchUpInside)
            texts[i].delegate=self
            texts[i].addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            texts[i].inputAccessoryView=AddToolBar()
        }
        //match
        match.setTitle("", for: .normal)
        match.addTarget(self, action: #selector(match_action), for: .touchUpInside)
        scrollView.addSubview(matchview)
        scrollView.addSubview(match)
        //table
        table.bounces=false
        table.separatorStyle = .none
        table.delegate=self
        table.dataSource=self
        table.backgroundColor=UIColor.clear
        table.contentInset=UIEdgeInsets(top: 10, left: 0, bottom: 0.65*Height, right: 0)
        scrollView.addSubview(table)
        scrollView.sendSubviewToBack(table)
        //footer
        B_add.frame=(frame_add)
        B_add.addTarget(self, action: #selector(B_addaction), for: .touchUpInside)
        scrollView.addSubview(B_add)
        B_clear.setImage(#imageLiteral(resourceName: "clear.png"), for: .normal)
        B_clear.addTarget(self, action: #selector(B_clearaction), for: .touchUpInside)
        scrollView.addSubview(B_clear)
        scrollView.addSubview(footerlabel)
        footerlabel.text="total sent: \(sentnumber)"
        footerlabel.textColor=UIColor.lightGray
        footerlabel.font=UIFont.systemFont(ofSize: 14)
        footerlabel.textAlignment = .center
        let powerlabel=UILabel(frame: CGRect(x: Width/2-50, y: scrollView.contentSize.height-35, width: 100, height: 35))
        powerlabel.textAlignment = .center
        powerlabel.text="Powered by LU"
        powerlabel.textColor=UIColor.white
        powerlabel.alpha=0.5
        powerlabel.font=UIFont.systemFont(ofSize: 12)
        scrollView.addSubview(powerlabel)
        needcheck()
    }
//buttonactions-------------------------------------------------------------------------------
   @objc func B_addaction(){
        extrablank+=1
        table_reloadData()
    }
    @objc func B_clearaction(){
        Recipients.removeAll()
        extrablank=0
        number_filledmember=0
        table_reloadData()
        table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        sentnumber=0
        footerlabel.text="total sent: \(sentnumber)"
    }
    @objc func button_action(sender: UIButton){
        if(button2text[sender]!.isUserInteractionEnabled == false){
            sender.alpha=1
            button2text[sender]!.isUserInteractionEnabled=true
            key_isActivated[sender.tag]=true
            button2text[sender]!.layer.borderColor=sender.backgroundColor!.cgColor
            needcheck()
        }else{
            sender.alpha=0.5
            button2text[sender]!.isUserInteractionEnabled=false
            key_isActivated[sender.tag]=false
            button2text[sender]!.text=""
            button2text[sender]!.layer.borderColor=UIColor.lightGray.cgColor
            needcheck()
        }
    }
    @objc func match_action(){
        self.view.endEditing(false)
        guard arevaildkeys() else{return}
        checked()
        Keynumber=0
        Message_original=T_message.text
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:Message_original)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.white, range: (Message_original as NSString).range(of: Message_original))
        attrstring.addAttribute(NSAttributedString.Key.font, value:UIFont.systemFont(ofSize: 16), range: (Message_original as NSString).range(of: Message_original))
        for i in 0..<6{
            Keywords[i]=texts[i].text!
            if(key_isActivated[i]){
                Keynumber+=1
                var keyrange=(Message_original as NSString).range(of: Keywords[i])
                var temp_M_o=Message_original!
                var temp_offset=0
                //to tint all the matched keyword
                while(keyrange.length != 0){
                    attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:colors[i], range: NSMakeRange(temp_offset+keyrange.location, keyrange.length))
                    attrstring.addAttribute(NSAttributedString.Key.font, value:UIFont.systemFont(ofSize: 16, weight: .heavy), range: NSMakeRange(temp_offset+keyrange.location, keyrange.length))
                    temp_offset+=keyrange.location+keyrange.length
                    temp_M_o=String(temp_M_o.suffix(temp_M_o.count-keyrange.location-keyrange.length))
                    guard temp_M_o != "" else {break}
                    keyrange=(temp_M_o as NSString).range(of: Keywords[i])
                }
            }
        }
        T_message.attributedText=attrstring
        //table
        table_reloadData()
    }
}


//tableview---------------------------------------------------------------------------------------
extension ViewController:UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        var member:Member!
        for recip in Recipients{
            if recip.controller==controller{
                member=recip
            }
        }
        switch result{
        case .sent:
            member.status="sent"
            sentnumber+=1
            footerlabel.text="total sent: \(sentnumber)"
        case .cancelled:
            member.status="cancelled"
        case .failed:
            member.status="failed"
        default:
            member.status="to be sent"
            break
        }
        table_reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return number_filledmember+1+extrablank
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isold:Bool=indexPath.row<number_filledmember
        var oldmember=Member()
        if isold {oldmember=Recipients[indexPath.row]}
        let cell=UITableViewCell()
        cell.backgroundColor=UIColor.clear
        let member=Member()
        //header
        let view_header=UIView(frame: frame_header)
        view_header.layer.contents = UIImage(named:"header.png")?.cgImage
        let T_phone=UITextField(frame: frame_T_phone)
        member.addphone(temp: T_phone)
        if isold {T_phone.text=oldmember.phonebox.text}else{T_phone.text=""}
        T_phone.placeholder="phone number"
        T_phone.textColor=UIColor.white
        T_phone.delegate=self
        T_phone.keyboardType = .numberPad
        T_phone.inputAccessoryView=AddToolBar()
        let phone=UIImageView(frame:frame_phone)
        phone.image=#imageLiteral(resourceName: "phone.png")
        view_header.addSubview(phone)
        view_header.addSubview(T_phone)
        cell.addSubview(view_header)
        //footer
        let view_footer=UIView(frame: CGRect(x: 0, y: cellHeight - 30, width: cellWidth, height: 29))
        view_footer.layer.contents = UIImage(named:"footer.png")?.cgImage
        let B_send=UIButton(frame: frame_B_send)
        B_send.addTarget(self, action: #selector(B_sendaction), for: .touchUpInside)
        member.addsendbutton(temp: B_send)
        B_send.setTitle("send", for: .normal)
        let label=UILabel(frame: CGRect(x: 120, y: 0, width: 200, height: 28))
        label.textColor=UIColor.white
        if isold {
            label.text="Status: \(oldmember.status)"
            member.status=oldmember.status
        }else{label.text="Status: to be sent"}
        if label.text=="Status: sent" {
            view_footer.layer.contents = UIImage(named:"footer_allgreen.png")?.cgImage
        }else if label.text=="Status: failed" || label.text=="Status: cancelled"{
            view_footer.layer.contents = UIImage(named:"footer_allred.png")?.cgImage
        }
        view_footer.addSubview(label)
        view_footer.addSubview(B_send)
        cell.addSubview(view_footer)
        cell.bringSubviewToFront(view_footer)
        //body
        let view_body=UIView(frame: CGRect(x: 0, y: 30, width: cellWidth, height: cellHeight-60))
        view_body.backgroundColor=UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        var point=0
        for i in 0..<6{
            if key_isActivated[i] {
                let tf=UITextField(frame: rect[point])
                tf.inputAccessoryView=AddToolBar()
                tf.placeholder=Keywords[i]
                tf.textColor=colors[i]
                tf.autocapitalizationType = .none
                tf.delegate=self
                if isold && oldmember.textbox[tf.placeholder!] != nil{
                    tf.text=oldmember.textbox[tf.placeholder!]?.text
                }else{
                    tf.text=""
                }
                point+=1
                view_body.addSubview(tf)
                member.addreplacement(temp: tf)
            }
        }
        if isold {Recipients[indexPath.row]=member}else{Recipients.append(member)}
        cell.addSubview(view_body)
        cell.selectionStyle = .none
        return cell
    }
    @objc func B_sendaction(sender: UIButton){
        var member:Member!
        for recip in Recipients{
            if recip.sendbutton==sender{member=recip}
        }
        member.refresh()
        let controller = MFMessageComposeViewController()
        controller.body = member.getmessage()
        controller.recipients=[member.number] as [String]
        controller.messageComposeDelegate = self
        member.addcontroller(temp: controller)
        self.present(controller, animated: true, completion: nil)
    }
}


//endediting & match & others---------------------------------------------------------
extension ViewController:UITextFieldDelegate, UITextViewDelegate{
    //endediting
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    //check
    func table_reloadData(){
        number_filledmember=0
        var i=0
        while i<Recipients.count{
            var retain=false
            for (_,tf) in Recipients[i].textbox{
                if tf.text != ""{
                    retain=true
                    break
                }
            }
            if Recipients[i].phonebox.text=="" && !retain{
                Recipients.remove(at: i)
                i-=1
            }else {number_filledmember+=1}
            i+=1
        }
        cellHeight=cellheight[Keynumber]
        table.reloadData()
    }
    func textViewDidChange(_ textView: UITextView) {
        needcheck()
    }
    @objc func textFieldDidChange(_ textView:UITextField) {
        needcheck()
    }
    func needcheck(){
        matchview.image=#imageLiteral(resourceName: "match1.png")
        table.isUserInteractionEnabled=false
        B_add.isUserInteractionEnabled=false
        B_clear.isUserInteractionEnabled=false
        B_add.alpha=0.5
        B_clear.alpha=0.5
        table.alpha=0.5
    }
    func checked(){
        matchview.image=#imageLiteral(resourceName: "match2.png")
        table.isUserInteractionEnabled=true
        B_add.isUserInteractionEnabled=true
        B_clear.isUserInteractionEnabled=true
        table.alpha=1
        B_add.alpha=1
        B_clear.alpha=1
    }
    func arevaildkeys()->Bool{
        var error:String!
        var hasnokey=true
        var hassamekey=false
        var hasblankkey=false
        for i in 0..<6{
            if texts[i].isUserInteractionEnabled && texts[i].text==""{hasblankkey=true}
        }
        for text in texts{
            if text.text != ""{hasnokey=false}
        }
        for i in 0..<6{
            let key=texts[i].text
            if key != ""{
                for n in 0..<6{
                    if i != n{
                        if key==texts[n].text{hassamekey=true}
                    }
                }
            }
        }
        if !hasnokey && !hassamekey && !hasblankkey {return true}
        else if hasnokey{error="Please fill at least 1 key."}
        else if hasblankkey{error="Don't leave activated key unfilled."}
        else if hassamekey{error="Make sure that there are no same keys."}
        let alert=UIAlertController(title: "Match Error", message: error, preferredStyle: .alert)
        let btn=UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(btn)
        self.present(alert,animated: true,completion: nil)
        return false
    }
    //rotate
    override var shouldAutorotate : Bool {
        return false
    }
    //numberpad settings
    func AddToolBar() -> UIToolbar {
        let toolBar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        toolBar.backgroundColor = UIColor.gray
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneNum))
        toolBar.items = [spaceBtn, barBtn]
        toolBar.sizeToFit()
        return toolBar
    }
    @objc func doneNum() {
        self.view.endEditing(false)
    }
}


