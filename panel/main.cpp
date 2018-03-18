#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "homecontrolclient.h"
#include "audioplayer.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    HomeControlClient cl;
    AudioPlayer ring;
    QQmlApplicationEngine engine;
    qmlRegisterType<HomeControlClient>("siddio.control", 1, 0, "HomeControlClient");
    qmlRegisterType<AudioPlayer>("siddio.control", 1, 0, "RingPlayer");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
