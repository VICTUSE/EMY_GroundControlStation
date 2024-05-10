#pragma once

#include <QtLocation/private/qgeotiledmap_p.h>
#include <QtCore/QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(QGeoTiledMapQGCLog)

class QGeoTiledMappingManagerEngineQGC;

class QGeoTiledMapQGC : public QGeoTiledMap
{
    Q_OBJECT

public:
    explicit QGeoTiledMapQGC(QGeoTiledMappingManagerEngineQGC *engine, QObject *parent = nullptr);
    ~QGeoTiledMapQGC();

    QGeoMap::Capabilities capabilities() const final;
};
