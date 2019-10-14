#ifndef SYSTEMCONTROLLER_H
#define SYSTEMCONTROLLER_H

#include <QObject>
#include <settingsmanager.h>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <ifhandler.h>
#include <utility.h>

class SystemController: public IFHandler
{
    Q_OBJECT
    Q_INTERFACES(IFHandler)
    QString m_fb_request_system;
    QString m_onoff_request;
    uint m_system_fb;
    bool m_state = false;
    QString m_feedback;
    QStringList m_paternList;
private:
    void prepareFeedback();
public:
    SystemController(QSettings * p_proto,QObject * parent=nullptr);
    bool messageHandler(QString p_message) override;
    QStringList getPatterns() override;
    QString getFeedback() override;
public slots:
    void changeonoff(bool p_state);
signals:
    void newLog(QString plog);
};

#endif // SYSTEMCONTROLLER_H
