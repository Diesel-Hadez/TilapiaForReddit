#include "CommentTreeModel.hpp"
#include "CommentItem.hpp"
#include <QDebug>

CommentTreeModel::CommentTreeModel(const QString& data, QObject* parent): QAbstractItemModel(parent) {
    qInfo() << "Creating root item\n";
    m_RootItem = new CommentItem({tr("CommentsRoot")});

    CommentItem * one = new CommentItem({tr("Hello World!")}, m_RootItem);
    CommentItem * two = new CommentItem({tr("Goodbye World!")}, m_RootItem);
    m_RootItem->appendChild(one);
    one->appendChild(new CommentItem({tr("Child One of Hello World!")},one));
    one->appendChild(new CommentItem({tr("Child Two of Hello World!")},one));
    m_RootItem->appendChild(two);
    two->appendChild(new CommentItem({tr("Child One of Goodbye World!")},two));
    two->appendChild(new CommentItem({tr("Child Two of Goodbye World!")},two));
    two->appendChild(new CommentItem({tr("Child Three of Goodbye World!")},two));
}

CommentTreeModel::~CommentTreeModel() {delete m_RootItem;}


QModelIndex CommentTreeModel::index(int row, int column, const QModelIndex& parent) const {
    if (!hasIndex(row, column, parent)) {
        return QModelIndex();
    }

    CommentItem* parentItem;

    if (!parent.isValid())
        parentItem = m_RootItem;
    else
        parentItem = static_cast<CommentItem*>(parent.internalPointer());

    CommentItem* childItem = parentItem->child(row);
    if (childItem)
        return createIndex(row, column, childItem);

    return QModelIndex();
}


QModelIndex CommentTreeModel::parent(const QModelIndex &index) const {
    if (!index.isValid()) {
        return QModelIndex();
    }

    CommentItem* childItem = static_cast<CommentItem*>(index.internalPointer());
    CommentItem* parentItem = childItem->parentItem();
    if (parentItem == m_RootItem) {
        return QModelIndex();
    }

    // 0 is for a parent version
    return createIndex(parentItem->row(), 0, parentItem);
}


int CommentTreeModel::rowCount(const QModelIndex& parent) const {
    CommentItem * parentItem;

    // Isn't a parent version
    if (parent.column() > 0) {return 0;}

    if (!parent.isValid()) {parentItem = m_RootItem;}
    else {
        parentItem = static_cast<CommentItem*>(parent.internalPointer());
    }
    return parentItem->childCount();
}

int CommentTreeModel::columnCount(const QModelIndex& parent) const {
    return 1;
}

QVariant CommentTreeModel::data(const QModelIndex& index, int role) const {
    qInfo() << "access data with role " << role << "\n";
    if (!index.isValid()) return QVariant();
    if (role != Qt::UserRole) return QVariant();
    CommentItem* item = static_cast<CommentItem*> (index.internalPointer());
    return item->data();
}

Qt::ItemFlags CommentTreeModel::flags(const QModelIndex& index) const {
    qInfo() << "Getting flags" << "\n";
    if (!index.isValid()) return Qt::NoItemFlags;
    return QAbstractItemModel::flags(index);
}

QVariant CommentTreeModel::headerData(int section, Qt::Orientation orientation, int role) const {
    qInfo() << "headerData of section " << section << "\n";
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole) return m_RootItem->data();
    return QVariant();
}

QHash<int, QByteArray> CommentTreeModel::roleNames() const {
    static QHash<int, QByteArray> mapping {
          {Qt::UserRole, "body"},
      };
      return mapping;
}
