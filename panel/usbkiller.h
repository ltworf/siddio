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

#ifndef USBKILLER_H
#define USBKILLER_H

#include <QObject>

class UsbKiller : public QObject
{
    Q_OBJECT
public:
    static UsbKiller *getInstance();

private:
    explicit UsbKiller(QObject *parent = nullptr);
    int users = 0;
    void act();

signals:

public slots:
    void play();
    void stop();
};

#endif // USBKILLER_H
