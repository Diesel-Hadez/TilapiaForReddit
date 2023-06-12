#include <KLocalizedContext>
#include <KLocalizedString>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QUrl>
#include <QtQml>
#include <iostream>
#include <string>

#include "CommentFetcher.hpp"
#include "CommentTreeModel.hpp"
#include "lib.hpp"

auto main(int argc, char** argv) -> int
{
  auto const lib = library {};
  auto const message = "Hello from " + lib.name + "!";
  std::cout << message << '\n';
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QApplication app(argc, argv);
  KLocalizedString::setApplicationDomain("tilapia_for_reddit");
  QCoreApplication::setOrganizationName(QStringLiteral("B1TEMY"));
  QCoreApplication::setOrganizationDomain(QStringLiteral("b1te.my"));
  QCoreApplication::setApplicationName(QStringLiteral("Tilapia For Reddit"));

  // Set to Material style.
  QQuickStyle::setStyle("Material");

  QQmlApplicationEngine engine;

  CommentTreeModel ctm("");
  engine.rootContext()->setContextProperty("_m", QVariant::fromValue(&ctm));

  qmlRegisterSingletonInstance("b1temy.reddit.fetcher",
                               1,
                               0,
                               "CommentFetcher",
                               CommentFetcher::instance(&engine, nullptr));

  engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  if (engine.rootObjects().isEmpty()) {
    return EXIT_FAILURE;
  }
  return app.exec();
}