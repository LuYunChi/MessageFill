//
//  layout.swift
//  MessageFill
//
//  Created by Lu Yunchi on 2019/1/3.
//  Copyright © 2019 Lu Yunchi. All rights reserved.
//

import Foundation
import UIKit

let Width=UIScreen.main.bounds.width
let Height=UIScreen.main.bounds.height

//give color
let colors:[UIColor]=[UIColor(red: 236/255, green: 87/255, blue: 96/255, alpha: 1),UIColor(red: 142/255, green: 202/255, blue: 62/255, alpha: 1),UIColor(red: 134/255, green: 232/255, blue: 255/255, alpha: 1),UIColor(red: 255/255, green: 152/255, blue: 189/255, alpha: 1),UIColor(red: 244/255, green: 174/255, blue: 126/255, alpha: 1),UIColor(red: 198/255, green: 155/255, blue: 249/255, alpha: 1)]


//positions of six key buttons and match button
let buttonwidth:CGFloat=25
let x=2/3*Width+buttonwidth-28      //for button
let dy=1/16*Height                  //for button
let y_offset=0.5/18*Height           //for button
let tx=5/6*Width                    //for keytext
let center_keybuttons=[CGPoint(x: x, y: 1*dy+y_offset),CGPoint(x: x, y: 2*dy+y_offset),CGPoint(x: x, y: 3*dy+y_offset),CGPoint(x: x, y: 4*dy+y_offset),CGPoint(x: x, y: 5*dy+y_offset),CGPoint(x: x, y: 6*dy+y_offset)]
let center_match=CGPoint(x: 1.3*x, y: 7.4*dy+y_offset)

//make button
func makebutton(_ n:Int)->UIButton{
    let button=UIButton(frame: CGRect(x: center_keybuttons[n].x-0.5*buttonwidth, y: center_keybuttons[n].y-0.5*buttonwidth, width: buttonwidth, height: buttonwidth))
    button.setTitle("", for: .normal)
    button.alpha=0.5
    button.layer.cornerRadius=buttonwidth/2
    button.backgroundColor=colors[n]
    button.tag=n
    return button
}

//make textfield
let textheight:CGFloat=25
func maketext(_ n:Int)->UITextField{
    let textfield=UITextField(frame: CGRect(x: x+buttonwidth/2+4, y: center_keybuttons[n].y-textheight/2, width: Width-4-(x+buttonwidth/2+10), height: textheight))
    textfield.text=""
    textfield.textAlignment = .center
    textfield.isUserInteractionEnabled=false                                                    //activated
    textfield.alpha=1                                                                           //alpha
    textfield.layer.borderColor=UIColor.lightGray.cgColor                                       //bordercolor
    textfield.layer.borderWidth=1.5                                                             //borderwidth
    textfield.layer.cornerRadius=textheight/2                                                   //cornerradius
    textfield.textColor=colors[n]                                                               //textcolor
    textfield.font=UIFont.systemFont(ofSize: 16, weight: .regular)                              //textfont
    textfield.autocorrectionType = .no                                                          //autocorrection
    textfield.autocapitalizationType = .none                                                    //autocapitalization
    var placeholder:String!                                                                     //placeholder
    switch n{
    case 0: placeholder="1st"
    case 1: placeholder="2nd"
    case 2: placeholder="3rd"
    case 3: placeholder="4th"
    case 4: placeholder="5th"
    case 5: placeholder="6th"
    default:placeholder="error"
    }
    textfield.placeholder="\(placeholder!) key"
    return textfield
}


//frames
let frame_bubble=CGRect(x: 10, y: 30, width: 2/3*Width, height: 0.5*Height-35)
let margin:CGFloat=10
let frame_message=CGRect(x: frame_bubble.minX+margin, y: frame_bubble.minY+margin, width: frame_bubble.width-margin-38/209*frame_bubble.width, height: frame_bubble.height-margin*2)
let frame_match=CGRect(x: center_match.x-buttonwidth, y: center_match.y-buttonwidth, width: buttonwidth, height: buttonwidth)
let frame_background=CGRect(x: 0, y: 0, width: Width, height: 1.5*Height)

//table
let frame_table=CGRect(x: 15, y: 0.527*Height, width: Width-30, height: 0.85*Height)
let cellWidth=frame_table.width
var cellHeight:CGFloat=90
let cellheight:[CGFloat]=[90,90,90,120,120,150,150]
let rect=[CGRect(x: 0, y: 0, width: 0.5*cellWidth, height: 30),CGRect(x: 0.5*cellWidth, y: 0, width: 0.5*cellWidth, height: 30),CGRect(x: 0, y: 30, width: 0.5*cellWidth, height: 30),CGRect(x: 0.5*cellWidth, y: 30, width: 0.5*cellWidth, height: 30),CGRect(x: 0, y: 60, width: 0.5*cellWidth, height: 30),CGRect(x: 0.5*cellWidth, y: 60, width: 0.5*cellWidth, height: 30)]
let frame_header=CGRect(x: 0, y: 3, width: cellWidth, height: 27)
let frame_T_phone=CGRect(x: 40, y: 1, width: cellWidth-40, height: 28)
let frame_phone=CGRect(x: 10, y: 3, width: 22, height: 22)
let frame_B_send=CGRect(x: 0, y: 0, width: 0.27*cellWidth, height: 28)

//footer button
let footer_y:CGFloat = frame_table.minY + frame_table.height+8
let footerbuttonheight:CGFloat=buttonwidth
let footerbuttonwidth:CGFloat=buttonwidth
let frame_add=CGRect(x: 10, y: footer_y, width: footerbuttonheight, height: footerbuttonheight)
let frame_clear=CGRect(x: Width-10-footerbuttonwidth, y: footer_y, width: footerbuttonwidth, height: footerbuttonheight)
let labelwidth:CGFloat=160
let frame_footerlabel=CGRect(x: Width/2-labelwidth/2, y: footer_y, width: labelwidth, height: footerbuttonheight)
