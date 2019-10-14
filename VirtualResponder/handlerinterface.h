#ifndef HANDLERINTERFACE_H
#define HANDLERINTERFACE_H

#include <QObject>
#include <QSettings>

class HandlerInterface : public QObject
{
    Q_OBJECT
public:
    explicit HandlerInterface(QSettings *p_proto,QObject *parent = nullptr);
    virtual QStringList getPatterns()=0;
    virtual bool messageHandler(QString message)=0;
    virtual QString getFeedback()=0;
    virtual QString newlog()=0;

public slots:
};
Q_DECLARE_INTERFACE(HandlerInterface, "HandlerInterface")
#endif // HANDLERINTERFACE_H
