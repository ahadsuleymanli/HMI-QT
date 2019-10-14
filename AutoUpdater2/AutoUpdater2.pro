QT -= gui
QT = network

CONFIG += c++11 console
CONFIG -= app_bundle

DEFINES += QT_DEPRECATED_WARNINGS


SOURCES += \
    QFtp/qftp.cpp \
    QFtp/qurlinfo.cpp \
        main.cpp \
    updater.cpp

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    QFtp/qftp.h \
    QFtp/qurlinfo.h \
    qftpcontroller.h \
    updater.h

linux-g++-64:contains(QMAKE_TARGET.arch,aarch64)
{
        target.path = /home/root/autovip
        INSTALLS += target
}
