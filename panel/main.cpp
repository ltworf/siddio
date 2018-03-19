#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "homecontrolclient.h"
#include "audioplayer.h"
#include "pibacklight.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<HomeControlClient>("siddio.control", 1, 0, "HomeControlClient");
    qmlRegisterType<AudioPlayer>("siddio.control", 1, 0, "MpvPlayer");
    qmlRegisterType<PiBacklight>("siddio.control", 1, 0, "PiBacklight");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
