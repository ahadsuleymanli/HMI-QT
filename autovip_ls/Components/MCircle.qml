import QtQuick 2.0

Path {
    id:root
    startX: 0;
    startY: 0
    PathArc {
        id: pa
        x: 0;
        y: 100
        radiusX: 100;
        radiusY: 100
        useLargeArc: true
    }
}
