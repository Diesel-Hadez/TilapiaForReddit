#include "CommentItem.hpp"

CommentItem::CommentItem(const CommentData &data, CommentItem * parent): m_ItemData(data), m_ParentItem(parent) {}
CommentItem::~CommentItem(){
    qDeleteAll(m_ChildItems);
}

void CommentItem::appendChild(CommentItem* child){
    m_ChildItems.append(child);
}

CommentItem* CommentItem::child(int row){
    if (row < 0 || row >= m_ChildItems.size()) {
        return nullptr;
    }
    return m_ChildItems.at(row);
}

int CommentItem::childCount() const {return m_ChildItems.size();}

QVariant CommentItem::data() const {return m_ItemData.body;}
int CommentItem::row() const {
    if (m_ParentItem) {
        return m_ParentItem->m_ChildItems.indexOf(const_cast<CommentItem*>(this));
    }
    return 0;
}

CommentItem* CommentItem::parentItem() {return m_ParentItem;}