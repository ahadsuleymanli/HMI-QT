#ifndef LEFTTOGGLEMENUMODEL_H
#define LEFTTOGGLEMENUMODEL_H

#include <QObject>

class LeftToggleMenuModel : public QObject
{
Q_OBJECT
public:
//Q_PROPERTY(QStringList dataList READ dataList NOTIFY dataListChanged)
    explicit LeftToggleMenuModel(QObject *parent = 0){}
//Q_INVOKABLE void setLogLines();
//Q_INVOKABLE void updateModel(const QString& value);
//QStringList dataList();

signals:
void getLatest();
void dataListChanged();

public slots:
//void onGetLatest();

private:
QStringList m_myData;
};

#endif // MYVIEWMODEL_H
