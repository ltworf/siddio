#include <QByteArray>
#include <QDebug>
#include <QFile>

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

#include "pibacklight.h"

//This thing is actually very generic, just with hardcoded paths
#define BRIGHTNESS "/sys/devices/platform/rpi_backlight/backlight/rpi_backlight/brightness"
#define MAXBRIGHTNESS "/sys/devices/platform/rpi_backlight/backlight/rpi_backlight/max_brightness"

//Test defines, my keyboard
//#define BRIGHTNESS "/sys/devices/platform/thinkpad_acpi/leds/tpacpi::kbd_backlight/brightness"
//#define MAXBRIGHTNESS "/sys/devices/platform/thinkpad_acpi/leds/tpacpi::kbd_backlight/max_brightness"

PiBacklight::PiBacklight(QObject *parent) : QObject(parent)
{
    QFile mb(MAXBRIGHTNESS);
    QFile b(BRIGHTNESS);

    QByteArray m_content, b_content;

    if (!(mb.exists() && b.exists())) {
        qDebug() << "Brightness devices do not exist";
        _max = 0;
        _brightness = 0;
        goto escape;
    }

    if (!(b.open(QIODevice::ReadOnly) && mb.open(QIODevice::ReadOnly))) {
        qDebug() << "Unable to open brightness device";
        _max = 0;
        _brightness = 0;
        goto escape;
    }

    //Read the files
    m_content = mb.readAll();
    b_content = b.readAll();

    //Remove trailing \n
    m_content.resize(m_content.size() - 1);
    b_content.resize(b_content.size() - 1);

    //Set internal representation
    _max = m_content.toUInt();
    _brightness = b_content.toUInt();

escape:
    mb.close();
    b.close();
    emit maxChanged(_max);
    emit brightnessChanged(_brightness);
}

void set_brightness(unsigned int newval) {
    QFile dev(BRIGHTNESS);
    if (dev.open(QIODevice::WriteOnly)) {
        dev.write(QByteArray::number(newval));
        dev.close();
    } else
        qDebug() << "Unable to open device " BRIGHTNESS " in write mode";
}

void PiBacklight::powersave() {
    set_brightness(0);
}

void PiBacklight::resume() {
    set_brightness(_brightness);
}

unsigned int PiBacklight::brightness() {
    return _brightness;
}

unsigned int PiBacklight::max() {
    return _max;
}

void PiBacklight::setBrightness(unsigned int brightness) {
    set_brightness(brightness);
    _brightness = brightness;
    emit brightnessChanged(_brightness);
}
