var MainMdl;
var comps = {};
var pageMap = {};
var seatNames = [];

function createComponent(name)
{
    comps[name] = Qt.createComponent(name+".qml");
}

function addPage(name,item)
{
    pageMap[name] = item;
}
function getPage(name)
{
    return pageMap[name];
}
function seatText(seatno)
{
    switch(seatno)
    {
 case 1:
   return QT_TR_NOOP("First Seat");
 case 2:
   return QT_TR_NOOP("Second Seat");
 case 3:
   return QT_TR_NOOP("Third Seat");
 case 4:
   return QT_TR_NOOP("Fourth Seat");
    }
    return QT_TR_NOOP("One Seat");
}
