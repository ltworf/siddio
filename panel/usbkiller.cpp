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

Copyright (C) 2019  Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
*/


#include <QDebug>
#include <QStringList>
#include <QProcess>

#include "usbkiller.h"

UsbKiller::UsbKiller(QObject *parent) : QObject(parent)
{
    this->act();
}

void UsbKiller::act() {
    qDebug() << "PLAYERS"    << this->users;
    QStringList params;

    params << "/usr/sbin/uhubctl";
    params << "-p" << "2";
    params << "-a";
    params << "-l" << "1-1";

    if (this->users)
        params << "on";
    else
        params << "off";

    QProcess proc;

    proc.start("/usr/bin/sudo", params, nullptr);
    proc.waitForFinished();
}

void UsbKiller::stop() {
    if (this->users == 0)
        return;
    this->users--;
    this->act();
}

void UsbKiller::play() {
    this->users++;
    this->act();
}

UsbKiller* UsbKiller::getInstance() {
    static UsbKiller* instance = nullptr;

    if (instance == nullptr)
        instance = new UsbKiller();

    return instance;
}
