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
  return app.exec();
}
