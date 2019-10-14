#include "lightcontroller.h"

LightController::LightController(QSettings *p_proto,QObject *parent) : IFHandler(parent)
{
    m_ceiling_red = p_proto->value("lights/ceiling_red").toUInt();
    m_ceiling_green = p_proto->value("lights/ceiling_green").toUInt();
    m_ceiling_blue = p_proto->value("lights/ceiling_blue").toUInt();

    m_side_red = p_proto->value("lights/side_red").toUInt();
    m_side_green = p_proto->value("lights/side_green").toUInt();
    m_side_blue = p_proto->value("lights/side_blue").toUInt();

    m_inside_red = p_proto->value("lights/inside_red").toUInt();
    m_inside_green = p_proto->value("lights/inside_green").toUInt();
    m_inside_blue = p_proto->value("lights/inside_blue").toUInt();

    m_fb_request_side = p_proto->value("lights/side_request").toString();
    m_fb_request_inside = p_proto->value("lights/inside_request").toString();
    m_fb_request_ceiling = p_proto->value("lights/ceiling_request").toString();

    m_fb_ceiling = p_proto->value("feedbacks/ceiling_light").toUInt();
    m_fb_inside = p_proto->value("feedbacks/inside_light").toUInt();
    m_fb_side = p_proto->value("feedbacks/side_light").toUInt();

    m_patternList<<QString("^(%1|%2|%3|%4|%5|%6|%7|%8|%9)/(\\d+)$")
                  .arg(m_ceiling_red)
                  .arg(m_ceiling_green)
                  .arg(m_ceiling_blue)
                  .arg(m_inside_red)
                  .arg(m_inside_green)
                  .arg(m_inside_blue)
                  .arg(m_side_red)
                  .arg(m_side_green)
                  .arg(m_side_blue);
    m_patternList<<QString("^%1$").arg(m_fb_request_side);
    m_patternList<<QString("^%1$").arg(m_fb_request_inside);
    m_patternList<<QString("^%1$").arg(m_fb_request_ceiling);

}

bool LightController::messageHandler(QString p_message)
{
    QRegularExpression re(m_patternList[0]);
    QRegularExpressionMatch rem = re.match(p_message);
    if(rem.hasMatch())
    {
        bool ok;
       uint ctype = rem.captured(1).toUInt(&ok);
       if(ok == false)
       {
           return false;
       }
       uint command = rem.captured(2).toUInt(&ok);
       if(ok == false )
       {
           return false;
       }
       if(ctype == m_ceiling_red)
       {
           m_ceiling_color.setRed(int(command));
           return false;
       }
       if(ctype == m_ceiling_green)
       {
           m_ceiling_color.setGreen(int(command));
           return false;
       }
       if(ctype == m_ceiling_blue)
       {
           m_ceiling_color.setBlue(int(command));
           return false;
       }
       if(ctype == m_side_red)
       {
           m_side_color.setRed(int(command));
           return false;
       }
       if(ctype == m_side_green)
       {
           m_side_color.setGreen(int(command));
           return false;
       }
       if(ctype == m_side_blue)
       {
           m_side_color.setBlue(int(command));
           return false;
       }
       if(ctype == m_inside_red)
       {
           m_inside_color.setRed(int(command));
           return false;
       }
       if(ctype == m_inside_green)
       {
           m_inside_color.setGreen(int(command));
           return false;
       }
       if(ctype == m_inside_blue)
       {
           m_inside_color.setBlue(int(command));
           return false;
       }

    }

    if(p_message.compare(QString(m_fb_request_side)) == 0)
    {
        m_feedback = QString("%1/%2/%3/%4")
                .arg(m_fb_side)
                .arg(m_side_color.red())
                .arg(m_side_color.green())
                .arg(m_side_color.blue());
        return true;
    }
    if(p_message.compare(QString(m_fb_request_inside)) == 0)
    {
        m_feedback = QString("%1/%2/%3/%4")
                .arg(m_fb_inside)
                .arg(m_inside_color.red())
                .arg(m_inside_color.green())
                .arg(m_inside_color.blue());
        return true;
    }
    if(p_message.compare(QString(m_fb_request_ceiling)) == 0)
    {
        m_feedback = QString("%1/%2/%3/%4")
                .arg(m_fb_ceiling)
                .arg(m_ceiling_color.red())
                .arg(m_ceiling_color.green())
                .arg(m_ceiling_color.blue());
        return true;
    }

return false;

}

QStringList LightController::getPatterns()
{
    return m_patternList;
}

QString LightController::getFeedback()
{
    return m_feedback;
}
