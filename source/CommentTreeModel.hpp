#ifndef COMMENT_TREE_MODEL_H
#define COMMENT_TREE_MODEL_H

#include <QAbstractItemModel>

#include <qnetworkaccessmanager.h>

class CommentItem;
class CommentTreeModel : public QAbstractItemModel
{
  Q_OBJECT
public:
  CommentTreeModel(const QString& data, QObject* parent = nullptr);
  ~CommentTreeModel();

  QVariant data(const QModelIndex& index, int role) const override;

  Qt::ItemFlags flags(const QModelIndex& index) const override;

  QVariant headerData(int section,
                      Qt::Orientation orientation,
                      int role = Qt::DisplayRole) const override;
  QModelIndex index(int row,
                    int column,
                    const QModelIndex& parent = QModelIndex()) const override;
  QHash<int, QByteArray> roleNames() const override;

  QModelIndex parent(const QModelIndex& parent = QModelIndex()) const override;

  int rowCount(const QModelIndex& parent = QModelIndex()) const override;
  int columnCount(const QModelIndex& parent = QModelIndex()) const override;

private:
  CommentItem* m_RootItem;
  QNetworkRequest request;
  std::unique_ptr<QNetworkAccessManager> tempNAM;
};

#endif
