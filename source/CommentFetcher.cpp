#include <QDebug>
#include <QQmlEngine>

#include "CommentFetcher.hpp"

#include <qqmlcontext.h>

#include "CommentTreeModel.hpp"

void CommentFetcher::GetComments()
{
  qDebug() << "Fetching Comments...\n";
  static CommentTreeModel ctm("");
  m_QmlEngine->rootContext()->setContextProperty("_m",
                                                 QVariant::fromValue(&ctm));
}
