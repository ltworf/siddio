#include "homecontrolclient.h"

#include <QByteArray>
#include <QTcpSocket>
#include <QList>
#include <QListIterator>

HomeControlClient::HomeControlClient(QObject *parent) : QObject(parent)
{
}

void HomeControlClient::setPort(uint16_t p) {
    this->m_port = p;
    emit portChanged(p);
}

void HomeControlClient::setHost(QString h) {
    this->m_host = h;
    emit hostChanged(h);
}

QString HomeControlClient::host() {
    return this->m_host;
}

uint16_t HomeControlClient::port() {
    return this->m_port;
}

void HomeControlClient::activate(QString profile) {
    QByteArray buffer;
    QTcpSocket sock;

    buffer.append('a');
    buffer.append(profile.toUtf8());
    qDebug() << "connecting " << this->m_host << " " << this->m_port;

    sock.connectToHost(this->m_host, this->m_port);
    sock.waitForConnected();
    sock.write(buffer);
    sock.waitForBytesWritten();
    sock.close();
}

QStringList HomeControlClient::profiles() {
    QByteArray buffer;
    QTcpSocket sock;

    buffer.append('l');
    qDebug() << "connecting " << this->m_host << " " << this->m_port;

    sock.connectToHost(this->m_host, this->m_port);
    sock.waitForConnected();
    sock.write(buffer);
    sock.waitForBytesWritten();

    buffer.clear();
    while (sock.waitForReadyRead()) {
        QByteArray b = sock.readAll();
        qDebug() << "data" << b;
        if (b.length() == 0)
            break;
        buffer.append(b);
    }
    sock.close();

    QList<QByteArray> profile_list = buffer.split(' ');
    QListIterator<QByteArray> i(profile_list);
    QStringList r;

    while (i.hasNext()) {
        r.append(QString::fromUtf8(i.next()));
    }

    return r;
}
