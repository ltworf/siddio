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

#ifndef PIBACKLIGHT_H
#define PIBACKLIGHT_H

#include <QObject>

class PiBacklight : public QObject
{
    Q_OBJECT
    Q_PROPERTY(unsigned int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
    Q_PROPERTY(unsigned int max READ max NOTIFY maxChanged)
    Q_PROPERTY(bool powersave READ powersave WRITE setPowersave NOTIFY powersaveChanged)

public:
    explicit PiBacklight(QObject *parent = nullptr);

signals:
    void maxChanged(unsigned int max);
    void brightnessChanged(unsigned int brightness);
    void powersaveChanged(bool);

public slots:
    bool powersave();
    void setPowersave(bool);
    void blankscreen();
    void unblankscreen();
    void setBrightness(unsigned int brightness);
    unsigned int brightness();
    unsigned int max();

private:
    unsigned int _max;
    unsigned int _brightness;
    bool _powersave;
};

#endif // PIBACKLIGHT_H
