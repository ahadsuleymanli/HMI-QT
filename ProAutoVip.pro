TEMPLATE = subdirs

SUBDIRS += \
    AutoUpdater2 \
    UpdateStarter \
    autovip_ls \
    VirtualResponder \
    ServiceManager

target.path = /home/root/autovip
INSTALLS += target
