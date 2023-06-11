#include <QDebug>
#include <QQmlEngine>

#include "CommentFetcher.hpp"

#include <qqmlcontext.h>

#include "CommentTreeModel.hpp"

void CommentFetcher::GetComments(QString url)
{
  qDebug() << "Fetching Comments...\n";
  if (ctm)
    delete ctm;
  ctm = new CommentTreeModel("");

  ctm->LoadFromCommentsURL(url);
  m_QmlEngine->rootContext()->setContextProperty("_m",
                                                 QVariant::fromValue(ctm));
}
