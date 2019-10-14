#ifndef VOICEPROTOHANDLER_H
#define VOICEPROTOHANDLER_H

#include <QObject>
#include <QSettings>
#include <QDebug>
namespace voice{
   enum commandType{
       Invalid,
       Key,
       Code,
       Wait_key,
       Wait,
       Function
   };

   commandType stringToType(QString p_type);

   struct CommandObj{
       commandType type;
       QStringList params;
   };

   struct CommandPack{
       QString name;
       bool enabled = false;
       QList<CommandObj *> * commands =nullptr;
       ~CommandPack(){
           if(commands != nullptr)
           {
                  qDeleteAll(*commands);
                  commands->clear();
                  delete commands;
           }
       }
   };


class VoiceProtoHandler : public QObject
{
    Q_OBJECT
    QSettings *m_proto = nullptr;
    QMap<int,CommandPack *> m_commandMap;
public:
    explicit VoiceProtoHandler(QSettings * p_proto,QObject *parent = nullptr);
    bool parseProto();
    bool sendVoiceCommand(int id);
    ~VoiceProtoHandler();


signals:
    void runFunction(QString);
    void sendKey(QString);
    void sendCode(QString);
    void needDelay(int);

public slots:
};

}
#endif // VOICEPROTOHANDLER_H
