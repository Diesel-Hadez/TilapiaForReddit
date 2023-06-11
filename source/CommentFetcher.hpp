#ifndef COMMENT_FETCHER_H
#define COMMENT_FETCHER_H
#include <QObject>
#include <QQmlEngine>

#include "CommentTreeModel.hpp"

class CommentFetcher : public QObject
{
private:
  Q_OBJECT
  QML_ELEMENT
  QML_SINGLETON

public:
  Q_INVOKABLE void GetComments(QString url);

  static CommentFetcher& Instance()
  {
    static CommentFetcher inst;
    return inst;
  }

  static CommentFetcher* instance(QQmlEngine* qmlEngine, QJSEngine* jsEngine)
  {
    Q_UNUSED(jsEngine)
    CommentFetcher* instance = &Instance();
    instance->m_QmlEngine = qmlEngine;
    qmlEngine->setObjectOwnership(instance, QQmlEngine::CppOwnership);
    return instance;
  }

protected:
  explicit CommentFetcher(QObject* parent = nullptr)
      : QObject(parent)
  {
  }

private:
  QQmlEngine* m_QmlEngine;
};

#endif
