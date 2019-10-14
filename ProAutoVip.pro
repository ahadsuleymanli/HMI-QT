TEMPLATE = subdirs

SUBDIRS += \
    AutoUpdater2 \
    autovip_ls \
    VirtualResponder \
    ServiceManager \
    tools/before \
    tools/after

target.path = /home/root/autovip
INSTALLS += target
