#ifndef COMMENT_ITEM_H
#define COMMENT_ITEM_H

#include <QVariant>

struct CommentData {
    QString body;
};
Q_DECLARE_METATYPE(CommentData)

class CommentItem {
public:
    CommentItem(const CommentData &data, CommentItem * parent = nullptr);
    ~CommentItem();

    void appendChild(CommentItem* child);

    CommentItem* child(int row);

    int childCount() const;

    QVariant data() const;
    int row() const;

    CommentItem* parentItem();
private:
    QList<CommentItem*> m_ChildItems;

    CommentData m_ItemData;

    CommentItem* m_ParentItem;
};
#endif