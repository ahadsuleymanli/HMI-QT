#include "mediaplayermng.h"

MediaPlayerMng::MediaPlayerMng(QObject *parent) : QObject(parent)
{
    client = new jcon::JsonRpcWebSocketClient(this);
    this->check_timer = new QTimer(this);
    this->check_timer->setInterval(1000);

    connect(client,&jcon::JsonRpcWebSocketClient::pnotification,this,&MediaPlayerMng::parseNotification);
    connect(this->check_timer,&QTimer::timeout,this,&MediaPlayerMng::sendCheckRequests);
    notificationMethods
            <<"Player.OnPlay"
            <<"Player.OnSeek"
            <<"Player.OnPause"
            <<"Player.OnStop"
            <<"VideoLibrary.OnUpdate"
            <<"Player.OnAdd";
    this->check_timer->start();
}

bool MediaPlayerMng::connectToServer(QString phost, int pport)
{
    this->host = phost;
    this->port = pport;
    return client->connectToServer(host,port);
}

bool MediaPlayerMng::connectToServer(QUrl purl)
{
   this->url = purl;
   this->m_connected = client->connectToServer(url);
   emit connectionChanged(this->m_connected);
    return this->m_connected;
}

void MediaPlayerMng::setURL(QUrl url)
{
    this->url = url;
}

bool MediaPlayerMng::isConnected()
{
    return this->m_connected;
}

int MediaPlayerMng::playerid()
{
    return this->m_playerid;
}

QString MediaPlayerMng::title()
{
    return this->m_title;
}

QString MediaPlayerMng::thumbnail()
{
    return this->m_thumbnail;
}

float MediaPlayerMng::speed()
{
    return this->m_speed;
}

double MediaPlayerMng::thours()
{
   return this->m_thours;
}

double MediaPlayerMng::tminutes()
{

   return this->m_tminutes;
}

double MediaPlayerMng::tseconds()
{

   return this->m_tseconds;
}

double MediaPlayerMng::chours()
{

   return this->m_chours;
}

double MediaPlayerMng::cminutes()
{

   return this->m_cminutes;
}

double MediaPlayerMng::cseconds()
{
   return this->m_cseconds;
}

float MediaPlayerMng::percentage()
{
   return this->m_percentage;
}

void MediaPlayerMng::fleft()
{
    if(!this->isConnected()) return;

    this->client->callAsync("Input.Left");
}

void MediaPlayerMng::fright()
{
    if(!this->isConnected()) return;

    this->client->callAsync("Input.Right");

}

void MediaPlayerMng::fup()
{
    if(!this->isConnected()) return;

    this->client->callAsync("Input.Up");

}

void MediaPlayerMng::fdown()
{
    if(!this->isConnected()) return;

    this->client->callAsync("Input.Down");

}

void MediaPlayerMng::fselect()
{

    if(!this->isConnected()) return;

    this->client->callAsync("Input.Select");
}

void MediaPlayerMng::fhome()
{
    if(!this->isConnected()) return;

    this->client->callAsync("Input.Home");

}

void MediaPlayerMng::fcontext()
{

    if(!this->isConnected()) return;

    this->client->callAsync("Input.ContextMenu");
}

void MediaPlayerMng::fback()
{
    if(!this->isConnected()) return;

    this->client->callAsync("Input.Back");

}

void MediaPlayerMng::getActivePlayers()
{
   if(!this->isConnected()) return;

   auto result = this->client->call("Player.GetActivePlayers");

   if (result->isSuccess()) {
        QVariant res = result->result();
                bool ok;
                //int id = res.toList().at(0).toMap().value("playerid").toDouble(&ok);
                QVariantList list = res.toList();
                if(list.empty())
                {
                    return;
                }
                int id = -1;
                foreach(QVariant item , list)
                {
                   QVariantMap mitem = item.toMap();
                   if(mitem.contains("type"))
                   {
                       QString type = mitem.value("type").toString();
                       if(type.compare("video") == 0)
                       {
                          id = mitem.value("playerid").toDouble(&ok);
                          if(ok)
                          {
                            if(id != this->playerid())
                            {
                                this->m_playerid = id;
                                emit this->playeridChanged(id);
                            }
                            return;

                          }
                       }
                   }
                }
        //qDebug()<<res<<endl;
    } else {
        QString err_str = result->toString();
    }

}

void MediaPlayerMng::getItem(int pid)
{

   if(!this->isConnected()) return;

   QVariantMap map1,map2;
   map1.insert("playerid",pid);
   QVariantList mlist;
   //mlist.append("title");
    mlist
                    <<"thumbnail"
                    <<"title"
                    <<"artist"
                    <<"starttime"
                    <<"endtime"
                    <<"albumartist"
                    <<"genre"
                    <<"year"
                    <<"rating"
                    <<"album"
                    <<"track"
                    <<"duration"
                    <<"comment"
                    <<"lyrics"
                    <<"musicbrainztrackid"
                    <<"musicbrainzartistid"
                    <<"musicbrainzalbumid"
                    <<"musicbrainzalbumartistid"
                    <<"playcount"
                    <<"fanart"
                    <<"director"
                    <<"trailer"
                    <<"tagline"
                    <<"plot"
                    <<"plotoutline"
                    <<"originaltitle"
                    <<"lastplayed";
   //map1.insert("properties",mlist);
    this->fgetPlayerProperties();
   auto result = this->client->call("Player.GetItem",this->playerid(),mlist);

   if (result->isSuccess()) {
        //qDebug()<<result->result()<<endl;
        QVariantMap pm1 = result->result().toMap().value("item").toMap();
        foreach(QString key, pm1.keys())
        {
            //qDebug()<<key<<":"<<pm1.value(key)<<endl;
            if(key.compare("title") == 0)
            {
                QString title = pm1.value("title").toString();
                if(title.compare(this->m_title) != 0)
                {
                    this->m_title = title;
                    emit titleChanged(title);
                }
            }else
                if(key.compare("thumbnail") == 0){

                QString thumbnail = QUrl::fromPercentEncoding(pm1.value("thumbnail").toByteArray());
                thumbnail.remove("image://");
                thumbnail.remove(-1,1);
                if(thumbnail.compare(this->m_thumbnail) != 0)
                {
                    this->m_thumbnail = thumbnail;
                    emit thumbnailChanged(thumbnail);
                }
                }
        }

   }else{
       qDebug()<<result->toString()<<endl;

   }
}

void MediaPlayerMng::getItem()
{
    this->getItem(this->playerid());
}

void MediaPlayerMng::getData()
{
    this->getItem();
    this->fgetPlayerProperties();
}

void MediaPlayerMng::playPause()
{
   if(!this->isConnected()) return;

   auto result = this->client->call("Player.PlayPause",this->playerid());

   if (result->isSuccess()) {

   }

}

void MediaPlayerMng::stop()
{

   if(!this->isConnected()) return;
   auto result = this->client->call("Player.Stop",this->playerid());

   if (result->isSuccess()) {

   }

}

void MediaPlayerMng::fseek(double p)
{

   if(!this->isConnected()) return;
   auto result = this->client->call("Player.Seek",this->playerid(),p);

   if (result->isSuccess()) {
        qDebug()<<result->result()<<endl;
   }else {
        qDebug()<<result->toString()<<endl;
   }

}

void MediaPlayerMng::fgetPlayerProperties()
{
   if(!this->isConnected()) return;
   QVariantMap map1;
   QVariantList mlist;
   mlist <<"percentage"<<"time"<<"totaltime";
   auto result = this->client->call(
               "Player.GetProperties",
               this->playerid(),
               mlist
               );
   if (result->isSuccess()) {
        qDebug()<<result->result()<<endl;
        QVariantMap pm1 = result->result().toMap();
        bool ok;
        if(pm1.contains("percentage"))
        {
            float pr = pm1.value("percentage").toFloat(&ok);
            if(ok && ( pr != this->percentage()) )
            {
                this->m_percentage = pr;
                emit percentageChanged(pr);
            }
        }
        if(pm1.contains("time"))
        {
            QVariantMap mp1 = pm1.value("time").toMap();
            double hr = mp1.value("hours").toDouble(&ok);
            if(ok && ( hr != this->chours()) )
            {
                this->m_chours = hr;
                emit choursChanged(hr);
            }
            double mr = mp1.value("minutes").toDouble(&ok);
            if(ok && ( mr != this->cminutes()) )
            {
                this->m_cminutes = mr;
                emit cminutesChanged(mr);
            }
            double sr = mp1.value("seconds").toDouble(&ok);
            if(ok && ( sr != this->cseconds()) )
            {
                this->m_cseconds = sr;
                emit csecondsChanged(sr);
            }


        }
        if(pm1.contains("totaltime"))
        {

            QVariantMap mp1 = pm1.value("totaltime").toMap();
            double hr = mp1.value("hours").toDouble(&ok);
            if(ok && ( hr != this->thours()) )
            {
                this->m_thours = hr;
                emit choursChanged(hr);
            }
            double mr = mp1.value("minutes").toDouble(&ok);
            if(ok && ( mr != this->tminutes()) )
            {
                this->m_tminutes = mr;
                emit tminutesChanged(mr);
            }
            double sr = mp1.value("seconds").toDouble(&ok);
            if(ok && ( sr != this->tseconds()) )
            {
                this->m_tseconds = sr;
                emit tsecondsChanged(sr);
            }

        }
   }else {
        qDebug()<<result->toString()<<endl;
   }
}

void MediaPlayerMng::sendCheckRequests()
{
    this->getData();
}

void MediaPlayerMng::parseNotification(QJsonObject response)
{
        QJsonDocument doc;
        doc.setObject(response);
        qDebug()<<doc.toJson()<<endl;
        QString method;
        if(!response.contains("method")) return;
        method = response.value("method").toString();
        int ind = this->notificationMethods.indexOf(method);
        switch(ind)
        {
            case 0: //Player.OnPlay
            qDebug()<<notificationMethods[ind];
            break;
            case 1: //Player.OnSeek
            qDebug()<<notificationMethods[ind];
            break;
            case 2: //Player.OnPause
            qDebug()<<notificationMethods[ind];
            break;
            case 3: //Player.OnStop
            qDebug()<<notificationMethods[ind];
            break;
            case 4: //VideoLibrary.OnUpdate
            qDebug()<<notificationMethods[ind];
            break;
            case 5: //Player.OnAdd
            qDebug()<<notificationMethods[ind];
            break;
            default:
            return;
        }

}
