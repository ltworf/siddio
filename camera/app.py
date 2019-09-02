#!/usr/bin/python3

# Siddio
# Copyright (C) 2019 Salvo "LtWorf" Tomaselli
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

from time import sleep

from picamera import PiCamera
from flask import Flask, Response, request


app = Flask(__name__)


@app.route('/foto.png')
def foto():
    r = Response(mimetype='image/png')
    # Only allow LAN
    if not request.remote_addr.startswith('10.0.'):
        return r

    with PiCamera() as camera:
        # Give the camera some time to do its thing
        sleep(2.5)
        camera.capture(r.stream, 'png')
    return r

if __name__ == '__main__':
   app.run(host= '10.0.0.4')

