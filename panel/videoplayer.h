/*
This file is part of siddio.

siddio is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

siddio is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with siddio. If not, see <http://www.gnu.org/licenses/>.

Copyright (C) 2018-2019  Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
*/


#ifndef VIDEOPLAYER_H
#define VIDEOPLAYER_H

#include <QObject>
#include <QString>
#include <QProcess>

class VideoPlayer: public QObject
{
    Q_OBJECT
    Q_PROPERTY(
            bool playing
            READ playing
            NOTIFY playingChanged
    )

    Q_PROPERTY(
            int volume
            READ volume
            WRITE setVolume
            NOTIFY volumeChanged
    )

public:
    explicit VideoPlayer(QObject *parent = nullptr);
signals:
    void playingChanged(bool);
    void volumeChanged(int);
public slots:
    void play(QString url);
    bool playing();
    int volume();
    void setVolume(int volume);
private slots:
    void finished(int, QProcess::ExitStatus);
private:
    int _volume = 100;
    bool _playing = false;
    QProcess *mpv = nullptr;
};

#endif // VIDEOPLAYER_H
