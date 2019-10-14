#include <QApplication>
#include <mainwindow.h>
#include <settingsmanager.h>
#include <serialmng.h>
#include <seatcontroller.h>

int main(int argc, char *argv[])
{

    QApplication a(argc, argv);
    MainWindow w;
    if(w.init()==false)
    {
        return 0;
    }
    w.show();


    return a.exec();
}
