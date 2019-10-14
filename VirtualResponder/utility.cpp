#include <utility.h>

int extractCommand(QString command_str)
{
    QStringList ls = command_str.split("/");
    if(ls.size() < 2)
    {
        return -1;
    }
    return ls.at(1).toInt();
}
