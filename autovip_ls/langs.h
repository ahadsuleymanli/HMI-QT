#ifndef LANGS_H
#define LANGS_H

#include <QObject>
#include <QLocale>

class Langs : public QObject
{
    Q_OBJECT
public:
    Langs() {}

    enum E_Languages
    {
        ENG = QLocale::English,
        JAP = QLocale::Japanese,
        AR = QLocale::Arabic,
        TR = QLocale::Turkish,
        CH = QLocale::Chinese
    };

    Q_ENUM(E_Languages)
};

#endif // LANGS_H
