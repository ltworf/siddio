#include "homecontrolclient.h"

#include <QByteArray>
#include <QTcpSocket>

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
