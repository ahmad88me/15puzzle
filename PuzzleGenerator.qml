import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

Rectangle{
    width: 600
    height: 600

    property var states_history: []
    property var thinking_moves: [] //note that it is in reverse order

    property int last_tile: 0

    TextField{
       id: depthfield
       width: parent.width/2
       inputMethodHints: Qt.ImhDigitsOnly
       placeholderText: "Enter max depth"
       anchors.right: parent.right
       anchors.top: parent.top
    }

    function replaceAll(find, replace, str) {
      return str.split(find).join(replace)
        //return str.replace(new RegExp(find, 'g'), replace);
    }

    Button{
        id: generate_button
        width: depthfield.width
        text: "Generate"
        anchors.right: depthfield.right
        anchors.top: depthfield.bottom
        onClicked: {
            var tiles,t
            t = replaceAll("[","",generated_moves.text)
            t = replaceAll("]","",t)
            generated_moves.text = ""
            tiles = t.split(",")
            console.debug("will clear")
            listmodel1.clear()
            console.debug("cleared")
            for (var i=0;i<tiles.length;i++){
                listmodel1.append({"box": tiles[i].trim()})
            }

//            states_history=[]
//            thinking_moves=[]
//            storeCurrState()
//            generated_moves.text=""
//            random_move_nodup(parseInt(depthfield.text), get_current_state())
//            console.debug("number of moves: "+thinking_moves.length)
//            for(var i=0;i<thinking_moves.length;i++){
//                console.debug(thinking_moves[i])
//            }
//            timer.repeat=true
//            timer.start()
        }
    }
    Button{
        id: leftb
        width: generate_button.width/2
        anchors.top: upb.bottom
        anchors.left: generate_button.left
        text: "left"
        onClicked: {
            move("left")
            generated_moves.text = text+", "+generated_moves.text
        }
    }
    Button{
        id: rightb
        width: generate_button.width/2
        anchors.top: upb.bottom
        anchors.right: generate_button.right
        text:"right"
        onClicked: {
            move("right")
            generated_moves.text = text+", "+generated_moves.text
        }
    }
    Button{
        id: upb
        width: generate_button.width/2
        anchors.top: generate_button.bottom
        anchors.left: generate_button.left
        text: "up"
        onClicked: {
            move("up")
            generated_moves.text = text+", "+generated_moves.text
        }
    }
    Button{
        id: downb
        width: generate_button.width/2
        anchors.top: generate_button.bottom
        anchors.right: generate_button.right
        text:"down"
        onClicked: {
            move("down")
            generated_moves.text = text+", "+generated_moves.text
        }
    }



    TextArea{
        id: generated_moves
        width: generate_button.width
        anchors.right: generate_button.right
        anchors.top: leftb.bottom
    }

    Button{
        id: applyb
        width: generate_button.width
        anchors.top: generated_moves.bottom
        anchors.right: generate_button.right
        text:"apply solution"
        onClicked: {
//            var moves
//            moves = generated_moves.text.split(",")
//            for (var i=0;i<moves.length;i++){
//                move(moves[i].trim())
//            }
         applytimer.repeat=true
        applytimer.start()
        }
    }


    Timer{
        id: applytimer
        repeat: false
        running:  false
        interval: 1000
        onTriggered: {

            var moves
            moves = generated_moves.text.split(",")
            if (last_tile>= moves.length){
                running=false
                repeat=false
                return
            }
            move(moves[last_tile].trim())
            last_tile = last_tile+1
        }
    }


    Timer{
        id: timer
        repeat: true//depthfield.text.trim()!="0" && depthfield.text.trim()!=""
        running: false
        interval: 2000
        onTriggered: {
            var m
            depthfield.text = (parseInt(depthfield.text)-1 )+""
            m = thinking_moves.pop()
            console.debug(m)
            move(m)
            if (depthfield.text == "1"){
                repeat=false
                running=false
            }

        }
    }

    Component.onCompleted: {
        var i;
        for(i=1;i<16;i++){
            listmodel1.append({"box": ""+i })
        }
        listmodel1.append({"box": "x" })
    }


    Component{
        id: dele
        Rectangle{
            id: r
            width: grid.width/4
            height: grid.width/4
            border.color: "blue"
            border.width: 1
            color: box=="x"? "grey"  : "white"
            Text{
                text: box
                anchors.horizontalCenter: r.horizontalCenter
                anchors.verticalCenter: r.verticalCenter
            }
        }
    }



    ListModel{
        id: listmodel1
    }


    GridView{
        id: grid
        width: parent.width/2
        height: width
        cellHeight: width/4
        cellWidth: width/4
        delegate: dele
        model: listmodel1
    }



    function random_move(){
        var moves = ["left","right","up","down"]
        var r,res
        r = Math.floor((Math.random() * 4) )
        //console.debug("random: "+r)
        res = move(moves[r])
        while(!res){
            r = Math.floor((Math.random() * 4) )
            res = move(  moves[r] )
        }
        generated_moves.text+=moves[r]+", "
    }


    function get_current_state(){
        var i,state=[]
        for (i=0;i<16;i++){
            state.push(listmodel1.get(i).box)
        }
        return state
    }


    function random_move_nodup(depth,state){
        if (depth<0){
            console.debug("The end of the depth")
            return true
        }
        var moves = ["left","right","up","down"]
        var r,resapp,i
        for(i=0;i<50;i++){
            r = Math.floor((Math.random() * 4) )
            //console.debug("random: "+r)
            resapp = stateApplyIf(moves[r],state)
            if(resapp.can){
//                thinking_moves.append(moves[r])
                console.debug("we can apply the move: "+moves[r])
                states_history.push(state)
                if(random_move_nodup(depth-1,resapp.state)){
                    thinking_moves.push(moves[r])
                    return true
                }
                else{
                    console.debug("we are backingup")
//                    thinking_moves.pop()
                    states_history.pop()
                }
            }
        }
        console.debug("stuck at depth: "+depth)
        return false
    }



    function move(dir){
        var i,holder,sec_hold
        var t
        for (i=0;i<16;i++){
            if (listmodel1.get(i).box == "x"){
                break
            }
        }
        switch(dir){
        case "left":
            if (i%4==0){
                return false
            }
            holder = listmodel1.get(i).box
            sec_hold = listmodel1.get(i-1).box
            listmodel1.set(i,{"box": sec_hold})
            listmodel1.set(i-1,{"box": holder})
            break
        case "right":
            if (i%4==3){
                return false
            }
            holder = listmodel1.get(i).box
            sec_hold = listmodel1.get(i+1).box
            listmodel1.set(i,{"box": sec_hold})
            listmodel1.set(i+1,{"box": holder})
            break
        case "up":
            if (Math.floor(i/4)==0){
                return false
            }
            holder = listmodel1.get(i).box
            sec_hold = listmodel1.get(i-4).box
            listmodel1.set(i,{"box": sec_hold})
            listmodel1.set(i-4,{"box": holder})
            break
        case "down":
            if (Math.floor(i/4)==3){
                return false
            }
            holder = listmodel1.get(i).box
            sec_hold = listmodel1.get(i+4).box
            listmodel1.set(i,{"box": sec_hold})
            listmodel1.set(i+4,{"box": holder})
            break
        }
        return true
    }



    function storeCurrState(){
        var state=[]
        var i=0
        for (i=0;i<16;i++){
            state.push(listmodel1.get(i).box)
        }
        states_history.push(state)
    }

    function stateExists(state){
        var i, k
        var curr
        for (k=0;k<states_history.length;k++){
            curr = states_history[k]
            for (i=0;i<16;i++){
                if (state[i] != curr[i] ){
                    break
                }
            }
            if (i==16){//which means the state does exists
                return true
            }
        }
        return false
    }

    function stateApplyIf(dir,state){
        var i,holder,sec_hold
        for (i=0;i<16;i++){
            if(state[i]=="x"){
                break
            }
        }

        switch(dir){
        case "left":
            holder = state[i]
            sec_hold = state[i-1]
            state[i] = sec_hold
            state[i-1] = holder
            break
        case "right":
            holder = state[i]
            sec_hold = state[i+1]
            state[i] = sec_hold
            state[i+1] = holder
            break
        case "up":
            holder = state[i]
            sec_hold = state[i-4]
            state[i]=  sec_hold
            state[i-4] = holder
            break
        case "down":
            holder = state[i]
            sec_hold = state[i+4]
            state[i] = sec_hold
            state[i+4] = holder
            break
        }
        if(stateExists(state)){
            return {"can" : false, "state": null}
        }
        else{
            return {"can" : true, "state" : state}
        }
    }

}
