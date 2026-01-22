#include "appcontroller.h"
#include <QDateTime>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>

AppController::AppController(QObject *parent)
    : QObject(parent)
    , m_progressValue(0)
    , m_statusText("Ready")
{
    m_mediaPlayer = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_mediaPlayer->setAudioOutput(m_audioOutput);
    m_audioOutput->setVolume(0.5);
    
    emit logMessage("Application started");
}

AppController::~AppController()
{
}

void AppController::setProgressValue(int value)
{
    if (m_progressValue != value) {
        m_progressValue = value;
        emit progressValueChanged();
    }
}

void AppController::setStatusText(const QString &text)
{
    if (m_statusText != text) {
        m_statusText = text;
        emit statusTextChanged();
    }
}

void AppController::handleButtonClick(const QString &inputText)
{
    if (inputText.isEmpty()) {
        emit logMessage("Button clicked - no text entered");
        setStatusText("Please enter some text first!");
        send_server("alert", "Please enter some text first!");
    } else {
        emit logMessage("Button clicked with text: " + inputText);
        setStatusText("Processed: " + inputText);
        
        int newValue = qMin(m_progressValue + 20, 100);
        setProgressValue(newValue);
    }
}

void AppController::playSound()
{
    emit logMessage("Sound playback requested");
    setStatusText("Audio feature ready (add sound file to enable)");
    
    // To play actual sound, uncomment and add a sound file:
    // m_mediaPlayer->setSource(QUrl::fromLocalFile("sound.wav"));
    // m_mediaPlayer->play();
}

void AppController::setVolume(int volume)
{
    m_audioOutput->setVolume(volume / 100.0);
    emit logMessage(QString("Volume adjusted to %1%").arg(volume));
}

void AppController::toggleFeature(bool enabled)
{
    QString status = enabled ? "enabled" : "disabled";
    emit logMessage("Advanced features " + status);
    setStatusText("Advanced features " + status);
}

void AppController::selectOption(const QString &option)
{
    emit logMessage("Selected: " + option);
    setStatusText("Current selection: " + option);
}

void AppController::server_send(const QString &content_type, const QString &content)
{
    QJsonObject jsonObject;
    jsonObject["type"] = content_type;
    jsonObject["content"] = content;
    
    QJsonDocument jsonDoc(jsonObject);
    QString jsonString = jsonDoc.toJson(QJsonDocument::Compact);
    
    emit logMessage("Sending: " + jsonString);
}

void AppController::send_server()
{
    server_send("EOF", "mainwindow.cpp");
}