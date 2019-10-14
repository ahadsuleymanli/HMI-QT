import QtQuick 2.0

Rectangle {
    id: root
    x:0
    y:0
    color: "transparent"
    property alias pname: pname.text
        state: "Off"
        states: [ "On", "Off"]
    Image{
        id: out
        z:1
        source:(root.state === "On")?"qrc:/imageset/isiklar/light-level-bar.png":""
        anchors.left:root.left
        width:310
        height:310
        sourceSize.width:310
        sourceSize.height:310

            Rectangle{
                    width: parent.width - 8
                    height: parent.height - 8
                    radius: width / 2
                    x:4
                    y:4
                    z:2
                    color: "transparent"
                    RoundMouseArea{
                        width : parent.width
                        height: parent.height
                        onPressed: {
                            console.log("clicked "+mouseX+", "+mouseY);
                            var from = lb.rotation;
                            var old = lb.rotation;
                            console.log("old "+old);
                            var xw = mouseX - width/2;
                            var yw = width/2 - mouseY ;
                            var rotation = Math.atan(Math.abs(yw)/Math.abs(xw)) * 180 / Math.PI;
                            console.log("hesaplanan "+ rotation);
                            if(xw>0 && yw>0)
                            {
                                if(old<0)
                                {
                                console.log("1. bölge");
                                   old = -old;
                                   if(old <= 90 && 0 < old)
                                   {

                                   }else if( old > 90 && old <= 180)
                                   {

                                   }else if( old > 180 && old <= 270)
                                   {
                                       if((old - rotation) > 180)
                                       {
                                            from = 360 - old;
                                           console.log("from değişti : "+from);
                                       }
                                   }else {
                                            from = 360 - old;
                                   }
                                }else{


                                }

                                rotation = rotation;
                            }
                            if(xw<0 && yw> 0)
                            {
                                rotation = 180 - rotation;
                                if(old<0)
                                {
                                    old = -old;

                                   if(old <= 90 && 0 < old)
                                   {

                                   }else if( old > 90 && old <= 180)
                                   {

                                   }else if( old > 180 && old <= 270)
                                   {
                                   }else {
                                       if( (old - rotation) > 180)
                                       {
                                           from = 360 - old;
                                       }
                                   }
                                }

                            }
                            if(xw<0 && yw<0)
                            {
                               rotation = 180 + rotation;
                                if(rotation > 240)
                                {
                                    return;
                                }

                                if(old<0)
                                {
                                    old = -old;

                                   if(old <= 90 && 0 < old)
                                   {

                                   }else if( old > 90 && old <= 180)
                                   {

                                   }else if( old > 180 && old <= 270)
                                   {
                                   }else {
                                       if( (old - rotation) > 180)
                                       {
                                           from = 360 - old;
                                       }
                                   }
                                }
                            }
                            if(xw>0 && yw<0)
                            {
                                rotation =  360 - rotation;
                                if(rotation < 299)
                                {
                                    return;
                                }

                                if(old<0)
                                {
                                    old = -old;

                                   if(old <= 90 && 0 < old)
                                   {
                                       from = -( old + 360 ) ;
                                   }else if( old > 90 && old <= 180)
                                   {

                                   }else if( old > 180 && old <= 270)
                                   {
                                   }else {
                                       if( (old - rotation) > 180)
                                       {
                                       }
                                   }
                                }
                            }

                            var targetRotation = -rotation;
                            lb.ranout.to = targetRotation;
                            lb.ranout.from = from;
                            lb.ranout.running = true
                            console.log("targetRotation : "+targetRotation);
                        }
                            Image{
                                    id: colorScale
                                    source:(root.state === "On")?"qrc:/imageset/isiklar/color-scale.png":""
                                    anchors.centerIn: parent
                                    Rectangle{
                                            width: parent.width
                                            height: parent.height
                                            radius:( width) / 2
                                            x: 0
                                            y: 0
                                            clip:true
                                            color: "transparent"
                                            RoundMouseArea{
                                            width: parent.width
                                            height: parent.width
                                        onPressed: {
                                            console.log("clicked "+mouseX+", "+mouseY);
                                            var from = level.rotation;
                                            var old = level.rotation;
                                            console.log("old "+old);
                                            var xw = mouseX - width/2;
                                            var yw = width/2 - mouseY ;
                                        var rotation = Math.atan(Math.abs(yw)/Math.abs(xw)) * 180 / Math.PI;
                                        console.log("hesaplanan "+ rotation);
                                        if(xw>0 && yw>0)
                                        {
                                        if(old<0)
                                        {
                                        console.log("1. bölge");
                                           old = -old;
                                           if(old <= 90 && 0 < old)
                                           {

                                           }else if( old > 90 && old <= 180)
                                           {

                                           }else if( old > 180 && old <= 270)
                                           {
                                           if((old - rotation) > 180)
                                           {
                                            from = 360 - old;
                                           console.log("from değişti : "+from);
                                           }
                                           }else {
                                            from = 360 - old;
                                           }
                                        }else{


                                        }

                                        rotation = rotation;
                                        }
                                        if(xw<0 && yw> 0)
                                        {
                                        rotation = 180 - rotation;
                                        if(old<0)
                                        {
                                        old = -old;

                                           if(old <= 90 && 0 < old)
                                           {

                                           }else if( old > 90 && old <= 180)
                                           {

                                           }else if( old > 180 && old <= 270)
                                           {
                                           }else {
                                           if( (old - rotation) > 180)
                                           {
                                           from = 360 - old;
                                           }
                                           }
                                        }

                                        }
                                        if(xw<0 && yw<0)
                                        {
                                           rotation = 180 + rotation;

                                        if(old<0)
                                        {
                                        old = -old;

                                           if(old <= 90 && 0 < old)
                                           {

                                           }else if( old > 90 && old <= 180)
                                           {

                                           }else if( old > 180 && old <= 270)
                                           {
                                           }else {
                                           if( (old - rotation) > 180)
                                           {
                                           from = 360 - old;
                                           }
                                           }
                                        }
                                        }
                                        if(xw>0 && yw<0)
                                        {
                                        rotation =  360 - rotation;

                                        if(old<0)
                                        {
                                        old = -old;

                                           if(old <= 90 && 0 < old)
                                           {
                                           from = -( old + 360 ) ;
                                           }else if( old > 90 && old <= 180)
                                           {

                                           }else if( old > 180 && old <= 270)
                                           {
                                           }else {
                                           if( (old - rotation) > 180)
                                           {
                                           }
                                           }
                                        }
                                        }

                                        /*
                                        if(xw<0)
                                        {
                                        if( ( Math.abs(rotation + 180 - old )) < (Math.abs(rotation - 180 - old)) )
                                        {
                                        rotation += 180;
                                         }else{
                                        rotation -=180;
                                        }
                                        }else{
                                        if(Math.abs(rotation - old) < Math.abs(rotation + 180 -old))
                                        {

                                        }else{
                                        rotation+=180;
                                        }
                                        }
                                        */

                                        //var duration = Math.abs( old - rotation ) * 10;
                                        //level.ran.duration = duration;
                                        var targetRotation = -rotation;
                                        level.ran.to = targetRotation;
                                        level.ran.from = from;
                                        level.ran.running = true

                                        //level.rotation = rotation;
                                        console.log("targetRotation : "+targetRotation);
                                        }
                                        }
                                    }

                                    Image{
                                    id: level
                                    source:"qrc:/imageset/isiklar/level-button.png"
                                    anchors.centerIn: parent
                                    property alias ran : ran
                                    RoundMouseArea{
                                        width:parent.width - 30
                                        height: parent.height - 30
                                        anchors.centerIn: parent
                                        onPressed: {
                                            if(root.state === "On")
                                            {
                                                root.state = "Off";
                                            }else{
                                                root.state = "On";
                                            }
                                        }
                                    }
                                       RotationAnimation on rotation
                                       {
                                            id:ran
                                            from: 0
                                            to:  30
                                            duration: 500
                                            running: false
                                       }
                                    }

                                    Image{
                                    source:"qrc:/imageset/isiklar/light-symbol.png"
                                    anchors.centerIn: parent
                                    anchors.verticalCenterOffset : -30
                                    }
                                }

                    }


            }

        Text{
            id: pname
            font.family :"helvetica"
            font.pixelSize: 24

            text:"bi"
            anchors.horizontalCenter:  parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 15
            color: "white"
            z:33
        }
        Text{
            id: onoff
            font.family :"helvetica"
            font.pixelSize: 30

            text:(root.state === "On")?"ON":"OFF"
            anchors.horizontalCenter:  parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 50
            color: "white"
            z:33
        }


    Image{

        id:lb
        x:0
        y:0
        z:3

        sourceSize.width:310
        sourceSize.height:310
        source:"qrc:/imageset/isiklar/light-level-bg.png"

        function rotateForCoords(mouseX,mouseY)
{
                            var from = lb.rotation;
                            var old = lb.rotation;
                            var xw = mouseX - width/2;
                            var yw = width/2 - mouseY ;
                            console.log("xw,yw : ",xw,yw);
                            var rotation = Math.atan(Math.abs(yw)/Math.abs(xw)) * 180 / Math.PI;
                            var quarter;
                            if(xw>0 && yw>0)
                            {
                                quarter = 1;
                            }else if(xw<0 && yw>0){
                               quarter = 2;
                            }else if(xw<0 && yw<0)
                            {
                                quarter = 3;
                            }else{
                                quarter = 4;
                            }
                            switch(quarter)
                            {
                            case 1:
                                rotation = rotation;
                                break;
                            case 2:
                                rotation = 180 - rotation;
                                break;
                            case 3:
                                rotation = 180 + rotation;
                                break;
                            case 4:
                                rotation = -rotation;
                                break;
                            }

                            var targetRotation = -rotation;
                            lb.rotation = targetRotation;
                            //lb.ranout.from = from;
                            lb.ranout.running = false;
                            console.log("targetRotation : "+targetRotation);
                        }
        Image{
                id:dot
                x: parent.width - 27
                y: parent.height/2
                sourceSize.width:32
                sourceSize.height:32
                source:(root.state==="On")?"qrc:/imageset/isiklar/light-level-dot.png":""

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("clicked");
                    }
                    onPressAndHold:
                    {
                        console.log("onPressAndHodl")
                    }
                    onPositionChanged:
                    {
                        if(mouse.wasHeld)
                        {
                            var point = dot.mapToItem(out,mouse.x - 10,mouse.y-10);
                            console.log("Point : "+ point.x +", "+point.y);
                            lb.rotateForCoords(point.x,point.y);
                            /*
                            var deg = (dot.y - mouse.y);
                            if(deg>0)
                            {
                                lb.rotation += 0.5;
                            }else
                            {
                                lb.rotation -= 0.5;
                            }
                            console.log("rotation changed : "+deg)
                            */
                        }
                    }
                }
        }

        property alias ranout : ranout

        RotationAnimation on rotation
        {
            id:ranout
            from: 0
            to:  360
            duration: 500
            running: false
        }

        }
    }


}
