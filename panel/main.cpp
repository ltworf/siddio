#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "homecontrolclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    HomeControlClient cl;
    QQmlApplicationEngine engine;
    qmlRegisterType<HomeControlClient>("siddio.control", 1, 0, "HomeControlClient");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
