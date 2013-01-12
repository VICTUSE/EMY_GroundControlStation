#ifndef HUD2RENDEROFFSCREEN_H
#define HUD2RENDEROFFSCREEN_H

#include <QWidget>
#include "HUD2Data.h"
#include "HUD2Painter.h"

class HUD2Painter;
QT_BEGIN_NAMESPACE
class QPaintEvent;
QT_END_NAMESPACE

class HUD2RenderOffscreen : public QWidget
{
    Q_OBJECT

public:
    HUD2RenderOffscreen(HUD2Painter *hudpainter, QWidget *parent);

signals:
    void geometryChanged(const QSize *size);

public slots:

protected:
    void paintEvent(QPaintEvent *event);
    void resizeEvent(QResizeEvent *event);

private:
    HUD2Painter *hudpainter;
};

#endif /* HUD2RENDEROFFSCREEN_H */
