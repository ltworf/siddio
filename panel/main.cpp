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
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "homecontrolclient.h"
#include "audioplayer.h"
#include "pibacklight.h"
#include "videoplayer.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<HomeControlClient>("siddio.control", 1, 0, "HomeControlClient");
    qmlRegisterType<AudioPlayer>("siddio.control", 1, 0, "MpvPlayer");
    qmlRegisterType<PiBacklight>("siddio.control", 1, 0, "PiBacklight");
    qmlRegisterType<VideoPlayer>("siddio.control", 1, 0, "VideoPlayer");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
