#ifndef APPCONTROLLER_H
#define APPCONTROLLER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTcpSocket>

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int progressValue READ progressValue WRITE setProgressValue NOTIFY progressValueChanged)
    Q_PROPERTY(QString statusText READ statusText WRITE setStatusText NOTIFY statusTextChanged)

public:
    explicit AppController(QObject *parent = nullptr);
    ~AppController();

    int progressValue() const { return m_progressValue; }
    void setProgressValue(int value);

    QString statusText() const { return m_statusText; }
    void setStatusText(const QString &text);

    void server_send(const QString &content_type, const QString &content);

public slots:
    void handleButtonClick(const QString &inputText);
    void playSound();
    void setVolume(int volume);
    void toggleFeature(bool enabled);
    void selectOption(const QString &option);

signals:
    void progressValueChanged();
    void statusTextChanged();
    void logMessage(const QString &message);

private:
    int m_progressValue;
    QString m_statusText;
    QMediaPlayer *m_mediaPlayer;
    QAudioOutput *m_audioOutput;
    QTcpSocket *m_socket;
};

void send_server(const QString &arg1, const QString &arg2)
{
    // Function implementation would go here
}

#endif // APPCONTROLLER_H