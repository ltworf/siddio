#!/usr/bin/python3
# Siddio
# Copyright (C) 2017 Salvo "LtWorf" Tomaselli
#
# Siddio is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>
import asyncore
import enum
import socket
import struct
from syslog import *
from typing import List

from configobj import ConfigObj
import RPi.GPIO as GPIO
from setproctitle import setproctitle


class Commands(enum.Enum):
    SETSTATE = b's'
    GETSTATE = b'g'
    GETCOUNT = b'c'
    GETNAME = b'n'
    GETDESCR = b'd'
    GETTAGS = b't'


class Device():
    def __init__(self, name: str, description: str, tags, pin: int, state: bool, invert: bool) -> None:
        self.name = name
        self.description = description
        self.pin = pin
        self.state = state
        self.invert = invert
        if isinstance(tags, str):
            tags = [tags]
        self.tags = tags

        GPIO.setup(pin, GPIO.OUT)
        self.set_state(state)
        syslog(LOG_INFO, 'Initialising device: %s on pin %d' % (name, pin))


    def set_state(self, state: bool):
        syslog(LOG_INFO, 'Setting state %s for %s' % ('ON' if state else 'OFF', self.name))
        self.state = state
        if self.invert:
            state = not state
        GPIO.output(self.pin, state)
        syslog(LOG_DEBUG, 'Pin %d set to %s' % (self.pin, state))

    def get_state(self):
        return self.state


def get_devices(filename: str = '/etc/siddio/iocontrol.conf') -> List:
    '''
    Loads the configuration and returns a list of tuples in
    the form of (pin, initial_state, description).
    '''
    if hasattr(get_devices, 'conf'):
        return getattr(get_devices,'conf')

    config = ConfigObj(filename)

    r = []
    for k,v in config.iteritems():
        if not k.startswith('Device'):
            syslog(LOG_WARNING, 'Unrecognised section in config: %s' % k)
            continue
        r.append(Device(
            v['name'],
            v.get('description', ''),
            v.get('tags', ''),
            int(v['pin']),
            bool(int(v.get('default', 0))),
            bool(int(v.get('invert', 0))),
        ))

    setattr(get_devices, 'conf', r)
    return r


class AsyncConnection(asyncore.dispatcher_with_send):
    def __init__(self, pair) -> None:
        asyncore.dispatcher_with_send.__init__(self, pair[0])
        addr = pair[1]
        self.logid = '%s:%d' % addr

    def _send_str(self, string: str) -> None:
        data = string.encode('utf8')
        self.send(data + b'\0')

    def _read_dev(self) -> Device:
        '''
        Reads 1 byte, uses it as index in the device lists
        and returns the corresponding device
        '''
        fmt = '!B'
        id = struct.unpack(fmt, self.recv(1))[0]
        return get_devices()[id]

    def handle_read(self):
        cmdstring = self.recv(1)
        if not cmdstring: # skip empty packets
            return

        try:
            command = Commands(cmdstring)
            syslog(LOG_INFO, self.logid + ' ' + command.name)
        except ValueError:
            syslog(LOG_INFO, self.logid + ' invalid command, %s dropping connection' % repr(cmdstring))
            self.close()
            return

        fmt = '!B'

        if command == Commands.SETSTATE:
            fmt = '!BB'
            id, state = struct.unpack(fmt, self.recv(2))
            get_devices()[id].set_state(bool(state))
            self.send(b'ok')
            return
        elif command == Commands.GETSTATE:
            id = struct.unpack(fmt, self.recv(1))[0]
            data = (get_devices()[id].get_state(),)
        elif command == Commands.GETCOUNT:
            data = (len(get_devices()), )
        elif command == Commands.GETNAME:
            name = self._read_dev().name
            self._send_str(name)
            return
        elif command == Commands.GETDESCR:
            description = self._read_dev().description
            self._send_str(description)
            return
        elif command == Commands.GETTAGS:
            tags = self._read_dev().tags
            self._send_str(','.join(tags))
            return
        self.send(struct.pack(fmt, *data))


class AsyncServer(asyncore.dispatcher):

    def __init__(self, host: str, port: int) -> None:
        asyncore.dispatcher.__init__(self)
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.set_reuse_addr()
        self.bind((host, port))
        self.listen(5)

    def handle_accept(self):
        pair = self.accept()
        if pair:
            connection = AsyncConnection(pair)


def main():
    setproctitle('iocontrol')
    openlog('iocontrol')

    try:
        # Initialising the pins
        GPIO.setmode(GPIO.BCM)
        get_devices()

        server = AsyncServer('0.0.0.0', 4141)
        asyncore.loop()
    finally:
        # Restore default state for them
        GPIO.cleanup()


if __name__ == '__main__':
    main()
