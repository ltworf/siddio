#ifndef HOMECONTROLCLIENT_H
#define HOMECONTROLCLIENT_H

#include <QObject>
#include <QString>

class HomeControlClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(QString host READ host WRITE setHost NOTIFY hostChanged)

public:
    explicit HomeControlClient(QObject *parent = 0);

signals:
    void portChanged(uint16_t);
    void hostChanged(QString);

public slots:
    void activate(QString profile);
    void setPort(uint16_t);
    uint16_t port();
    void setHost(QString);
    QString host();

private:
    uint16_t m_port;
    QString m_host;
};

#endif // HOMECONTROLCLIENT_H
