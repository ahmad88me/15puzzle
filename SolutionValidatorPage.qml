import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

Rectangle {
    width: 100
    height: 62

    function parse_and_append(text_area,list_model){
        console.debug("parse clicked")
        var t = text_area.text.trim()
        console.debug("t: "+t)
        t = t.substr(1,t.length-2)
        var start
        for(var i=0;i<t.length;i++){
            console.debug("in the for loop")
            if(t[i]=="["){
                start = i+1
            }
            else if(t[i]=="]"){
                var eles = t.substring(start,i).trim().split(",")
                console.debug("eles")
                for(var k=0;k<eles.length;k++){
                    if (eles[k].trim()!=""){
                        list_model.append({"box": eles[k] })
                        console.debug("item: "+eles[k])
                    }
                }
            }
        }
    }



    ListModel{
        id: listmodel1
    }

    ListModel{
        id: listmodel2
    }

    TextArea{
        id: sq1_textarea
        width: parent.width/2 -5
        height: 50
        anchors.left: parent.left
    }

    TextArea{
        id: sq2_textarea
        width: sq1_textarea.width
        height: sq1_textarea.height
        anchors.right: parent.right
    }

    Button{
        id: sq1_button
        anchors.top: sq1_textarea.bottom
        anchors.left: sq1_textarea.left
        width: sq1_textarea.width
        text: "Parse & Draw"
        onClicked: {
            listmodel1.clear()
            listmodel2.clear()
            var t = sq1_textarea.text.trim()
            t = t.substr(1,t.length-2)
            var start
            for(var i=0;i<t.length;i++){
                if(t[i]=="["){
                    start = i+1
                }
                else if(t[i]=="]"){
                    var eles = t.substring(start,i).trim().split(",")
                    for(var k=0;k<eles.length;k++){
                        if (eles[k].trim()!=""){
                            listmodel1.append({"box": eles[k] })
                            listmodel2.append({"box": eles[k] })
                        }
                    }
                }
            }
        }
    }

    Button{
        id: sq2_button
        anchors.top: sq2_textarea.bottom
        anchors.left: sq2_textarea.left
        width: sq2_textarea.width
        text: "Apply"
        onClicked: {
            var moves = sq2_textarea.text.trim().split(",");
            for(var i=0;i<moves.length;i++){
                move(moves[i])
            }
        }
    }
/*
[[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,x]]
*/

    function move(direction){
        var idx;
        var tmp;
        for(var i=0;i<16;i++){
            if (listmodel2.get(i).box =="x"){
                idx=i
                break
            }
        }
        if(direction=="left"){
            tmp=listmodel2.get(idx).box;
            listmodel2.setProperty(idx,"box",listmodel2.get(idx-1).box)
            listmodel2.setProperty(idx-1,"box",tmp)
        }
        else if(direction=="right"){
            tmp=listmodel2.get(idx).box;
            listmodel2.setProperty(idx,"box",listmodel2.get(idx+1).box)
            listmodel2.setProperty(idx+1,"box",tmp)
        }
        else if(direction=="down"){
            tmp=listmodel2.get(idx).box;
            listmodel2.setProperty(idx,"box",listmodel2.get(idx+4).box)
            listmodel2.setProperty(idx+4,"box",tmp)
        }
        else if(direction=="up"){
            tmp=listmodel2.get(idx).box;
            listmodel2.setProperty(idx,"box",listmodel2.get(idx-4).box)
            listmodel2.setProperty(idx-4,"box",tmp)
        }
    }


    Component{
        id: dele
        Rectangle{
            id: r
            width: sq1.width/4
            height: sq1.width/4
            border.color: "blue"
            border.width: 1
            color: box=="x"? "grey"  : "white"
            Text{
                text: box
                anchors.horizontalCenter: r.horizontalCenter
                anchors.verticalCenter: r.verticalCenter
                //width: parent.width
                //height: parent.height
            }
        }
    }



    GridView{
        id: sq1
        width: sq1_textarea.width
        height: width
        cellHeight: width/4
        cellWidth: width/4
        anchors.top: sq1_button.bottom
        anchors.left: sq1_textarea.left
        delegate: dele
        model: listmodel1
    }

    GridView{
        id: sq2
        width: sq1.width
        height: width
        cellHeight: width/4
        cellWidth: width/4
        anchors.top: sq2_button.bottom
        anchors.left: sq2_textarea.left
        delegate: dele
        model: listmodel2
    }






}

