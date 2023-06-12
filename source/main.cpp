
#define Q_OS_ANDROID

#ifdef Q_OS_ANDROID
#  include <QGuiApplication>
#  include <QtAndroid>

// WindowManager.LayoutParams
#  define FLAG_TRANSLUCENT_STATUS 0x04000000
#  define FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS 0x80000000
// View
#  define SYSTEM_UI_FLAG_LIGHT_STATUS_BAR 0x00002000

#else
#  include <QApplication>
#endif

#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QUrl>
#include <QtQml>
#include <iostream>
#include <string>

#include "CommentFetcher.hpp"
#include "CommentTreeModel.hpp"
#include "lib.hpp"

Q_DECL_EXPORT int main(int argc, char* argv[])
{
  auto const lib = library {};
  auto const message = "Hello from " + lib.name + "!";
  std::cout << message << '\n';
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef Q_OS_ANDROID
  QGuiApplication app(argc, argv);
#else
  QApplication app(argc, argv);
#endif

  QCoreApplication::setOrganizationName(QStringLiteral("B1TEMY"));
  QCoreApplication::setOrganizationDomain(QStringLiteral("b1te.my"));
  QCoreApplication::setApplicationName(QStringLiteral("Tilapia For Reddit"));

  // Set to Material style.
  QQuickStyle::setStyle(QString::fromStdString("Material"));

  QQmlApplicationEngine engine;

  CommentTreeModel ctm(QString::fromStdString(""));
  engine.rootContext()->setContextProperty(QString::fromStdString("_m"),
                                           QVariant::fromValue(&ctm));

  qmlRegisterSingletonInstance("b1temy.reddit.fetcher",
                               1,
                               0,
                               "CommentFetcher",
                               CommentFetcher::instance(&engine, nullptr));

  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  if (engine.rootObjects().isEmpty()) {
    return EXIT_FAILURE;
  }

  // HACK to color the system bar on Android, use qtandroidextras and call the
  // appropriate Java methods
#ifdef Q_OS_ANDROID
  QtAndroid::runOnAndroidThread(
      [=]()
      {
        QAndroidJniObject window =
            QtAndroid::androidActivity().callObjectMethod(
                "getWindow", "()Landroid/view/Window;");
        window.callMethod<void>(
            "addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.callMethod<void>("clearFlags", "(I)V", FLAG_TRANSLUCENT_STATUS);
        window.callMethod<void>(
            "setStatusBarColor", "(I)V", QColor("#2196f3").rgba());
        window.callMethod<void>(
            "setNavigationBarColor", "(I)V", QColor("#2196f3").rgba());
      });
#endif
  return app.exec();
}
