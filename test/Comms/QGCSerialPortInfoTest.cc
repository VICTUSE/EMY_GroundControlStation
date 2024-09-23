/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "QGCSerialPortInfoTest.h"
#include "QGCSerialPortInfo.h"

#include <QtTest/QTest>

void QGCSerialPortInfoTest::_testLoadJsonData()
{
#ifndef NO_SERIAL_LINK
    QVERIFY(!QGCSerialPortInfo::_jsonLoaded);
    QGCSerialPortInfo::_loadJsonData();
    QVERIFY(QGCSerialPortInfo::_jsonLoaded);
#endif
}
