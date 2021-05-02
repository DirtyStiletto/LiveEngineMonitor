TEMPLATE = app

TARGET = LEMbeta1

HEADERS = LEMmain.h functionCollector.h

SOURCES = LEMmain.cpp functionCollector.cpp

DESTDIR = $$(QMAKE_DESTIDIR)

QT+= core quick

RESOURCES += qml.qrc
