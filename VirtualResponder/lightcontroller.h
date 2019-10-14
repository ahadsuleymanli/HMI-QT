#ifndef LIGHTCONTROLLER_H
#define LIGHTCONTROLLER_H

#include <QSettings>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <ifhandler.h>
#include <QObject>
#include <QColor>

class LightController : public IFHandler
{
    Q_OBJECT
    Q_INTERFACES(IFHandler)
    uint m_ceiling_red;
    uint m_ceiling_green;
    uint m_ceiling_blue;
    uint m_inside_red;
    uint m_inside_green;
    uint m_inside_blue;
    uint m_side_red;
    uint m_side_green;
    uint m_side_blue;
    uint m_fb_inside;
    uint m_fb_side;
    uint m_fb_ceiling;
    QString m_fb_request_inside;
    QString m_fb_request_side;
    QString m_fb_request_ceiling;
    QColor m_inside_color = "#000000";
    QColor m_side_color = "#000000";
    QColor m_ceiling_color = "#000000";
    QString m_feedback;
    QStringList m_patternList;
public:
    explicit LightController(QSettings * p_proto,QObject *parent = nullptr);
    bool messageHandler(QString p_message) override;
    QStringList getPatterns() override;
    QString getFeedback() override;

signals:
    void newLog(QString plog);
public slots:
};

#endif // LIGHTCONTROLLER_H
