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
import socket
import struct

from configobj import ConfigObj
import RPi.GPIO as GPIO


SETSTATE = b's'
GETSTATE = b'g'



class Device():
    def __init__(self, name: str, description: str, pin: int, state: bool, invert: bool):
        self.name = name
        self.description = description
        self.pin = pin
        self.state = state
        self.invert = invert

        GPIO.setup(pin, GPIO.OUT)
        self.set_state(state)


    def set_state(self, state: bool):
        if self.invert:
            state = not state
        GPIO.output(self.pin, state)



def get_devices(filename='/etc/siddio-iocontrol.conf'):
    '''
    Loads the configuration and returns a list of tuples in
    the form of (pin, initial_state, description).
    '''
    if hasattr(get_devices, 'conf'):
        return getattr(get_devices,'conf')

    config = ConfigObj(filename)

    r = []
    for k,v in config.iteritems():
        r.append(Device(
            k,
            v.get('description', ''),
            int(v['pin']),
            bool(int(v.get('default', 0))),
            bool(int(v.get('invert', 0))),
        ))

    setattr(get_devices, 'conf', r)
    return r


class AsyncConnection(asyncore.dispatcher_with_send):
    def handle_read(self):
        command = self.recv(1)
        if command == SETSTATE:
            fmt = '!BB'
            id, state = struct.unpack(fmt, self.recv(2))
            print(id, state)
            get_devices()[id].set_state(bool(state))
            self.send(b'ok')



class AsyncServer(asyncore.dispatcher):

    def __init__(self, host, port):
        asyncore.dispatcher.__init__(self)
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.set_reuse_addr()
        self.bind((host, port))
        self.listen(5)

    def handle_accept(self):
        pair = self.accept()
        if pair:
            sock, addr = pair
            connection = AsyncConnection(sock)


def main():

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
