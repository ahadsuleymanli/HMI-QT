import QtQuick 2.4

LibraryForm {
    playlist.model: mPlayerBackend.trackList()
}
