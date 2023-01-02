import QtQuick 2.6
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kirigamiaddons.treeview 1.0 as TreeView

Kirigami.ScrollablePage {
    id: page

    property string postTitle
    property string postSubreddit
    property string postHint
    property string postURL
    property string postSelfText

    postTitle: "Default Title"
    postSubreddit: "Default subreddit"
    postSelfText: "Default Post content"
    postHint: ""
    postURL: ""
    title: postSubreddit

    Kirigami.AbstractCard {
        id: card

        Layout.fillHeight: true

        header: Kirigami.Heading {
            text: postTitle
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            level: 2
        }

        contentItem: Item {
            Layout.fillHeight: true
            implicitWidth: postColLayout.implicitWidth
            implicitHeight: postColLayout.implicitHeight

            ColumnLayout {
                id: postColLayout

                Image {
                    id: postImage

                    visible: postHint == "image"
                    Layout.topMargin: Kirigami.Units.smallSpacing
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
		    Layout.preferredWidth: card.width
		    fillMode: Image.PreserveAspectFit
                    source: postURL
                }

                Controls.Label {
                    id: postText

                    textFormat: Text.MarkdownText
                    Layout.preferredWidth: card.width
                    Layout.topMargin: Kirigami.Units.smallSpacing
                    Layout.bottomMargin: Kirigami.Units.smallSpacing
                    wrapMode: Text.WordWrap
                    text: postSelfText
                }

            }

        }

    }

}
