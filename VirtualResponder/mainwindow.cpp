#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QRadioButton>


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(this->ui->pb_clear,SIGNAL(clicked()),this,SLOT(clear()));
    connect(this->ui->pb_close,SIGNAL(clicked()),this,SLOT(close()));
    //connect(this->ui->cb_systemOnOff,&QCheckBox::stateChanged,this,&MainWindow::systemChanged);
    connect(this->ui->cb_systemOnOff, &QRadioButton::toggled,this,&MainWindow::systemChanged);
}

bool MainWindow::init()
{

    settings_mng = new SettingsManager(this);
    serial_mng = new SerialMng(this);
    if(settings_mng->init()==false)
    {
        return false;
    }

    serial_mng->setBaudRate(settings_mng->value("serial/baud_rate").toInt());
    serial_mng->setDataBits(settings_mng->value("serial/databits").toInt());
    serial_mng->setParity(settings_mng->value("serial/parity").toInt());
    serial_mng->setStopBits(settings_mng->value("serial/stopbits").toInt());
    serial_mng->setFlowControl(settings_mng->value("serial/flowcontrol").toInt());
    serial_mng->setPortName(settings_mng->value("serial/port_name").toString());

    serial_mng->openSerialPort();
    QSettings * proto = serial_mng->getProtocolFile();

    seat_cnt = new SeatController(proto,this);
    system_cnt = new SystemController(proto,this);
    ac_cnt = new AirconditionController(proto,this);

    light_cnt = new  LightController(proto,this);

    seat_cnt->setSM(settings_mng);

    serial_mng->registerHandler("SeatController",seat_cnt);
    serial_mng->registerHandler("SystemController",system_cnt);
    serial_mng->registerHandler("AirConditioner",ac_cnt);
    serial_mng->registerHandler("LightController",light_cnt);
    connect(serial_mng,&SerialMng::newLog,this,&MainWindow::addLog);
    return true;
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::addLog(QString par)
{
    par =  par.trimmed();
    QString log = QString("%1 :: %2").arg(QDateTime::currentDateTime().toString("hh:mm:ss:zzz")).arg(par);
    this->ui->lsLog->insertItem(0,log);
}

void MainWindow::clear()
{
    this->ui->lsLog->clear();

}

void MainWindow::reset()
{

}

void MainWindow::close()
{
    QCoreApplication::quit();
}

void MainWindow::systemChanged(bool p_st)
{
    system_cnt->changeonoff(p_st);
    QString fb = system_cnt->getFeedback();
    serial_mng->write(fb.toUtf8());
    /*
    if(p_st)
    {
       serial_mng->openSystem();
    }else
    {
       serial_mng->closeSystem();
    }
    */

}
