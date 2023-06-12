import QtQuick 2.7
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kirigamiaddons.treeview 1.0 as TV
import org.kde.kitemmodels 1.0

Controls.ScrollView 
{
    id: root
    property int commentsWidth: 100;
    property int commentsHeight: 500;

    TV.TreeListView {
        clip: true
        model: _m
        expandsByDefault: true
        anchors.fill: parent
        width: root.commentsWidth
        height: root.commentsHeight

        delegate: CustomAbstractTreeItem {
            id: listItem
            contentItem: Text {                            
                width: root.commentsWidth
                wrapMode: Text.Wrap
                text: model.body
            }
        }
    }
}
