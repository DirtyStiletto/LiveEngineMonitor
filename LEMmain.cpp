/*QT GUI Framework*/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

/*QML Call C++*/
#include "functionCollector.h"

/*Befehle in Konsole schreiben*/
#include <cstdlib>
#include <iostream>
#include <string>
using namespace std;

/*Init*/
int main(int argc, char *argv[])
{
  string command = "ip link set can0 type can bitrate 500000 && ip link set can0 up";
  system(command.c_str());
  functionCollector *cppConnection = new functionCollector;
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("qmlConnection",cppConnection); //Kommunikation mit QML Conections
  engine.load(QUrl(QStringLiteral("qrc:/newmain.qml")));
  return app.exec(); /*Load GUI*/
}