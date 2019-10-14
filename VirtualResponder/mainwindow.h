#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <settingsmanager.h>
#include <seatcontroller.h>
#include <serialmng.h>
#include <airconditioncontroller.h>
#include <lightcontroller.h>
#include <systemcontroller.h>
#include <QDateTime>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    SettingsManager * settings_mng = nullptr;
    SerialMng* serial_mng = nullptr;
    SeatController* seat_cnt = nullptr;
    AirconditionController* ac_cnt = nullptr;
    LightController* light_cnt = nullptr;
    SystemController* system_cnt = nullptr;

public:
    explicit MainWindow(QWidget *parent = nullptr);
    bool init();
    ~MainWindow();
    void addLog(QString par);
public slots:
    void clear();
    void reset();
    void close();
    void systemChanged(bool p_st);

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
