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

Copyright (C) 2018  Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
*/


#include <QProcess>
#include <QStringList>

#include "videoplayer.h"


VideoPlayer::VideoPlayer(QObject* parent): QObject(parent)
{

}

void VideoPlayer::play(QString url) {
    QStringList params;
    params << "--fs";
    params << "--vo=gpu";
    params << url;
    QProcess mpv(this);
    mpv.start("/usr/bin/mpv", params, 0);
    mpv.waitForStarted(-1);
    mpv.waitForFinished(-1);
}
