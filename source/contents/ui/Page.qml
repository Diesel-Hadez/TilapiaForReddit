import QtQuick 2.6
import QtMultimedia 5.6
import QtQuick.Controls 2.2 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami
import b1temy.reddit.fetcher 1.0


Kirigami.ScrollablePage {
    id: page

    property string postTitle
    property string postSubreddit
    property string postHint
    property string postURL
    property string postVideoURL
    property string postPermalink
    property string postSelfText

    postTitle: "Default Title"
    postSubreddit: "Default subreddit"
    postSelfText: "Default Post content"
    postHint: ""
    postURL: ""
    postPermalink: ""
    title: postSubreddit
    Component.onCompleted: {
        let a = postPermalink;
        a = a.substr(0,a.slice(0,-1).lastIndexOf('/')) + "/top.json";
        a = 'https://www.reddit.com' + a;
        CommentFetcher.GetComments(a);
    }

    ColumnLayout {
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

                Column{
                    id: postColLayout

                    Image {
                        id: postImage

                        visible: postHint == "image"
                        Layout.topMargin: Kirigami.Units.smallSpacing
                        Layout.bottomMargin: Kirigami.Units.smallSpacing
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        width: parent.width * 0.7
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectFit
                        source: postURL
                    }
                    Item {
                        width: card.width
                        height: card.width
                        visible: postHint == "hosted:video"
                        Component.onCompleted: {console.log(`ABC: ${postVideoURL}`)}
                            MediaPlayer {
                                autoPlay: true
                                    id: mediaplayer
                                  source:postVideoURL
                                  Component.onCompleted: {pause()}
                                }

                                VideoOutput {
                                    anchors.fill: parent
                                    source: mediaplayer
                                }

                                MouseArea {
                                    id: playArea
                                    anchors.fill: parent
                                    onPressed: mediaplayer.play();
                                }
                        }

                    Controls.Label {
                        id: postText

                        textFormat: Text.MarkdownText
                        width: card.width
                        Layout.preferredWidth: card.width
                        Layout.topMargin: Kirigami.Units.smallSpacing
                        Layout.bottomMargin: Kirigami.Units.smallSpacing
                        wrapMode: Text.WordWrap
                        text: postSelfText
                    }

                }

            }

        }

        Kirigami.AbstractCard {
            id: commentsCard

            // Note: Comments {} is a ScrollView by itself so it is weirdly a "ScrollView within ScrollablePage".
            // This is because I had trouble getting the TreeView working within this ScrollablePage, 
            // where it just blanked for some reason.
            // Will need to look into this, but for now, use a hard-coded value.
            Layout.preferredHeight: 500

            contentItem: Comments {}
        }
    }
}
