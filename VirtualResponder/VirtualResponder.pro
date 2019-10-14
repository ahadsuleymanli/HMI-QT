QT       += core gui
QT +=serialport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11 console
CONFIG -= app_bundle

TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
    serialmng.cpp \
    settingsmanager.cpp \
    seatcontroller.cpp \
    handlerinterface.cpp \
    mainwindow.cpp \
    airconditioncontroller.cpp \
    lightcontroller.cpp \
    utility.cpp \
    systemcontroller.cpp

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    serialmng.h \
    settingsmanager.h \
    seatcontroller.h \
    handlerinterface.h \
    mainwindow.h \
    ifhandler.h \
    airconditioncontroller.h \
    lightcontroller.h \
    utility.h \
    systemcontroller.h

PLATFORM = "unknown"
win32:contains(QMAKE_TARGET.arch, x86_64):{
        DEFINES += "PLATFORM=WIN_X86_64"
        DEFINES += "BAUDRATE=9600"
        DEFINES += "PORTNAME=COM5"
        PLATFORM = "WIN_X86_64"
        DEFINES += WIN_X86_64
}

win32:contains(QMAKE_TARGET.arch, x86):{
        DEFINES += "PLATFORM=WIN_X86"
        DEFINES += "BAUDRATE=9600"
        DEFINES += "PORTNAME=COM5"
        PLATFORM = "WIN_X86"
        DEFINES += WIN_X86
}

macx:contains(QMAKE_HOST.arch, x86_64):{
        DEFINES += "PLATFORM=MACX_X86_64"
        DEFINES += 'BAUDRATE=115200'
        DEFINES += 'PORTNAME=ttyS0'
        PLATFORM = "MACX_X86_64"
        DEFINES += "MACX_X86_64"
}


linux-g++-64:contains(QMAKE_TARGET.arch, x86_64):{
        DEFINES += "PLATFORM=LIN_X86_64"
        DEFINES += 'BAUDRATE=115200'
        DEFINES += 'PORTNAME=ttyS0'
        PLATFORM = "LIN_X86_64"
        DEFINES += "LIN_X86_64"
}

linux-g++-64:contains(QMAKE_TARGET.arch,aarch64)
{
        DEFINES += "PLATFORM=LIN_ARM64"
        DEFINES += 'BAUDRATE=115200'
        DEFINES += 'PORTNAME=ttyMSM1'
        PLATFORM = "LIN_ARM64"
        DEFINES += LIN_ARM64
        target.path = /home/root/autovip
        message("aarch64")
        INSTALLS += target
        target_arch = "aarch64"
}
message($${QMAKE_HOST.arch})
message($${PLATFORM})

FORMS += \
    mainwindow.ui
