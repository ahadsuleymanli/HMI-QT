#ifndef IFHANDLER_H
#define IFHANDLER_H
#include <QStringList>
#include <QObject>
class IFHandler:public QObject{
    Q_OBJECT
public:
    IFHandler(QObject *parent=nullptr):QObject(parent){}
    virtual QStringList getPatterns()=0;
    virtual bool messageHandler(QString message)=0;
    virtual QString getFeedback()=0;
};

Q_DECLARE_INTERFACE(IFHandler,"IFHandler")
#endif // IFHANDLER_H
