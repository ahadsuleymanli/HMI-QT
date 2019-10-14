QT += quick widgets
QT += \
        quick \
        websockets \
        serialport \
        multimedia \
        testlib

CONFIG += c++14
CONFIG  += qt warn_off release

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        nvidiaconnmanager.cpp \
        main.cpp \
    restarter.cpp \
        settingsmanager.cpp \
        translator.cpp \
        mediaplayermng.cpp \
        initializemng.cpp \
    jcon/json_rpc_client.cpp \
    jcon/json_rpc_debug_logger.cpp \
    jcon/json_rpc_endpoint.cpp \
    jcon/json_rpc_error.cpp \
    jcon/json_rpc_file_logger.cpp \
    jcon/json_rpc_logger.cpp \
    jcon/json_rpc_request.cpp \
    jcon/json_rpc_server.cpp \
    jcon/json_rpc_success.cpp \
    jcon/json_rpc_tcp_client.cpp \
    jcon/json_rpc_tcp_server.cpp \
    jcon/json_rpc_tcp_socket.cpp \
    jcon/json_rpc_websocket.cpp \
    jcon/json_rpc_websocket_client.cpp \
    jcon/json_rpc_websocket_server.cpp \
    jcon/string_util.cpp \
    serialmng.cpp \
    colorcomponents.cpp \
    logger/dualfilelogger.cpp \
    logger/filelogger.cpp \
    logger/logger.cpp \
    logger/logmessage.cpp \
    cronjobs.cpp \
    clocksetter.cpp \
    updatecheck.cpp \
    voicerecognitionservice.cpp \
    websocketcontroller.cpp \
    voiceprotohandler.cpp

HEADERS += \
    nvidiaconnmanager.h \
    restarter.h \
        settingsmanager.h \
        translator.h \
        mediaplayermng.h\
        initializemng.h \
        langs.h \
    jcon/jcon.h \
    jcon/jcon_assert.h \
    jcon/json_rpc_client.h \
    jcon/json_rpc_debug_logger.h \
    jcon/json_rpc_endpoint.h \
    jcon/json_rpc_error.h \
    jcon/json_rpc_file_logger.h \
    jcon/json_rpc_logger.h \
    jcon/json_rpc_request.h \
    jcon/json_rpc_result.h \
    jcon/json_rpc_server.h \
    jcon/json_rpc_socket.h \
    jcon/json_rpc_success.h \
    jcon/json_rpc_tcp_client.h \
    jcon/json_rpc_tcp_server.h \
    jcon/json_rpc_tcp_socket.h \
    jcon/json_rpc_websocket.h \
    jcon/json_rpc_websocket_client.h \
    jcon/json_rpc_websocket_server.h \
    jcon/string_util.h \
    serialmng.h \
    colorcomponents.h \
    logger/dualfilelogger.h \
    logger/filelogger.h \
    logger/logger.h \
    logger/logglobal.h \
    logger/logmessage.h \
    cronjobs.h \
    clocksetter.h \
    updatecheck.h \
    voicerecognitionservice.h \
    websocketcontroller.h \
    voiceprotohandler.h

RESOURCES += \
    qml.qrc

TRANSLATIONS = translator/general_TR.ts \
                             translator/general_AR_.ts \
                             translator/general_CH.ts
CONFIG += resources_big

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
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
linux-g++-64:contains(QMAKE_TARGET.arch, x86_64):{
        DEFINES += "PLATFORM=LIN_X86_64"
        DEFINES += 'BAUDRATE=115200'
        DEFINES += 'PORTNAME=ttyS0'
        PLATFORM = "LIN_X86_64"
        DEFINES += "LIN_X86_64"
}
macx:contains(QMAKE_HOST.arch, x86_64):{
        DEFINES += "PLATFORM=MACX_X86_64"
        DEFINES += 'BAUDRATE=115200'
        DEFINES += 'PORTNAME=ttyS0'
        PLATFORM = "MACX_X86_64"
        DEFINES += "MACX_X86_64"
}

linux-g++-64:contains(QMAKE_TARGET.arch, aarch64)
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

lupdate_only{
SOURCES = Pages/Controls/*.qml Pages/Curtains/*.qml Pages/Lights/*.qml Pages/Media/*.qml Pages/Seat/*.qml Pages/Settings/*.qml Pages/Home.qml Components/*.qml SGlobal.qml ./*.qml
}

  lupdate_only{
  SOURCES = *.qml \
            *.js \
            content/*.qml \
            content/*.js
  }


message("HOST" $${QMAKE_HOST.arch})
message("TARGET ARCH" $${QMAKE_TARGET.arch})
message("PLATFORM" $${PLATFORM})

DISTFILES +=
