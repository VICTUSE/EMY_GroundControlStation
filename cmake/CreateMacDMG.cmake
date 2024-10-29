# include(BundleUtilities)

message(STATUS "Copy GStreamer framework into bundle")
file(COPY /Library/Frameworks/GStreamer.framework DESTINATION staging/QGroundControl.app/Contents/Frameworks)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/bin)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/etc)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/share)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/Headers)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/include)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/Commands)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/pkgconfig)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/glib-2.0)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/graphene-1.0)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/gst-validate-launcher)
file(GLOB REMOVE_LIB_FILES staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/*.a)
file(REMOVE ${REMOVE_LIB_FILES})
file(GLOB REMOVE_LIB_FILES staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/*.la)
file(REMOVE ${REMOVE_LIB_FILES})
file(GLOB REMOVE_LIB_FILES staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/gstreamer-1.0/*.a)
file(REMOVE ${REMOVE_LIB_FILES})
file(GLOB REMOVE_LIB_FILES staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/gstreamer-1.0/*.la)
file(REMOVE ${REMOVE_LIB_FILES})
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/gstreamer-1.0/include)
file(REMOVE_RECURSE staging/QGroundControl.app/Contents/Frameworks/GStreamer.framework/Versions/1.0/lib/gstreamer-1.0/pkgconfig)

# Fix up library paths to point into bundle
execute_process(COMMAND install_name_tool -change /Library/Frameworks/GStreamer.framework/Versions/1.0/lib/GStreamer @executable_path/../Frameworks/GStreamer.framework/Versions/1.0/lib/GStreamer staging/QGroundControl.app/Contents/MacOS/QGroundControl)

message(STATUS "Creating Mac DMG")
file(REMOVE_RECURSE package)
file(MAKE_DIRECTORY package)
file(COPY staging/QGroundControl.app DESTINATION package)
file(REMOVE /tmp/tmp.dmg)
execute_process(COMMAND hdiutil create /tmp/tmp.dmg -ov -volname QGroundControl -fs APFS -srcfolder package)
execute_process(COMMAND hdiutil convert /tmp/tmp.dmg -format UDBZ -o package/QGroundControl.dmg)
file(REMOVE /tmp/tmp.dmg)
