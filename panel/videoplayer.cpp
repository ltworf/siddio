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


#include <QStringList>

#include "videoplayer.h"


VideoPlayer::VideoPlayer(QObject* parent): QObject(parent)
{
    _playing = false;
    emit playingChanged(_playing);
}

void VideoPlayer::play(QString url) {
    if (mpv)
        return;

    QStringList params;
    params << "--fs";
    params << "--vo=gpu";
    params << "--volume" << QString::number(this->_volume);
    params << url;
    mpv = new QProcess(this);

    connect(
        mpv,
        QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        this,
        &VideoPlayer::finished
    );

    _playing = true;
    emit playingChanged(_playing);

    mpv->start("/usr/bin/mpv", params, nullptr);
}

void VideoPlayer::finished(int exit_code, QProcess::ExitStatus status) {
    _playing = false;
    emit playingChanged(_playing);
    delete mpv;
    mpv = nullptr;
}

bool VideoPlayer::playing() {
    return _playing;
}

void VideoPlayer::setVolume(int volume) {
    this->_volume = volume;
    emit volumeChanged(volume);
}

int VideoPlayer::volume(){
    return this->_volume;
}
