```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "appcontroller.h"
#include <QProcess>
#include <QStandardPaths>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTcpSocket>
#include <QFileInfo>

#ifdef Q_OS_WIN
    #define APERTURE_PATH "./Aperture.exe"
#elif defined(Q_OS_MAC)
    #define APERTURE_PATH "./Aperture.app"
#else
    #define APERTURE_PATH "./Aperture"
#endif

// Add this function before main
void server_send(const QString& content_type, const QString& content) {
    QTcpSocket socket;
    socket.connectToHost("localhost", 12345);
    
    if (socket.waitForConnected(3000)) {
        QJsonObject json_obj;
        json_obj["type"] = content_type;
        json_obj["content"] = content;
        
        QJsonDocument doc(json_obj);
        QByteArray data = doc.toJson();
        
        socket.write(data);
        socket.waitForBytesWritten();
        socket.disconnectFromHost();
    }
}

void send_server() {
    server_send("alert", "main.cpp");
}

void aperture_runner() {
    QProcess* apertureProcess = new QProcess();
    QString aperturePath = APERTURE_PATH;
    
    #ifdef Q_OS_WIN
        if (QFileInfo::exists("./Aperture.exe")) {
            apertureProcess->start("./Aperture.exe");
            server_send("alert", "Starting Aperture.exe");
        }
    #elif defined(Q_OS_MAC)
        if (QFileInfo::exists("./Aperture.app")) {
            apertureProcess->start("open", QStringList() << "-a" << "./Aperture.app");
            server_send("alert", "Starting Aperture.app");
        }
    #else
        if (QFileInfo::exists("./Aperture")) {
            apertureProcess->start("./Aperture");
            server_send("alert", "Starting Aperture");
        }
    #endif
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    
    // Create backend controller
    AppController controller;
    engine.rootContext()->setContextProperty("appController", &controller);
    
    // Run aperture based on OS
    aperture_runner();
    
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}

// Call server_send at the end
send_server();
```