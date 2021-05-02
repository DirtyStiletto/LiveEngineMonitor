//#ifndef BACK_H
//#define BACK_H

#include <QObject>
#include <QString>

class functionCollector : public QObject
{
    Q_OBJECT
public:
    explicit functionCollector(QObject *parent = nullptr);

signals:
    void valChangedPotiGraph(float valPotG);
    void valChangedSW(bool cmd_switch);
    void valChangedPotiTrue(float valPotT);
    void valChangedUI(int rxUi);
    void valChangedUD(int rxUd);
    void languageChanged(QString language);
    

public slots:
    void changeValue();
    void changeLanguage(bool language);
};
//#endif // BACK_H