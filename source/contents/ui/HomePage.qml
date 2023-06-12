import QtQuick 2.15
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.15
import org.kde.kirigami 2.4 as Kirigami

Kirigami.ScrollablePage {
        id: page

        property bool censor_nsfw: true

        title: qsTr("Dirted")
        //Close the drawer with the back button
        onBackRequested: {
            if (sheet.sheetOpen) {
                event.accepted = true;
                sheet.close();
            }
        }
        Component.onCompleted: {
            let db = LocalStorage.openDatabaseSync("DirtedDB", "0.1", "Local storage database for miscellaneous data.", 1e+06);
            db.transaction((tx) => {
                    tx.executeSql("CREATE TABLE IF NOT EXISTS UserPref(name TEXT NOT NULL PRIMARY KEY, enabled INTEGER NOT NULL)");
                    let results = tx.executeSql("SELECT enabled FROM UserPref WHERE name='censor_nsfw'");
                    if (results.rows.length > 0){
                        censor_nsfw = results.rows.item(0).enabled;
                    }

                });

        }

        Kirigami.CardsListView {
            id: view

            model: myModel

            delegate: Kirigami.AbstractCard {

                // EDIT: This issue seems to be resolved?
                //NOTE: never put a Layout as contentItem as it will cause binding loops
                //SEE: https://bugreports.qt.io/browse/QTBUG-66826
                contentItem: Item {
                    implicitWidth: delegateLayout.implicitWidth
                    implicitHeight: delegateLayout.implicitHeight

                    GridLayout {
                        id: delegateLayout

                        rowSpacing: Kirigami.Units.largeSpacing
                        columnSpacing: Kirigami.Units.largeSpacing
                        columns: width > Kirigami.Units.gridUnit * 20 ? 4 : 2

                        anchors {
                            //IMPORTANT: never put the bottom margin

                            left: parent.left
                            top: parent.top
                            right: parent.right
                        }

                        Image {
                            source: {
                                if (!censor_nsfw && (over_18 || postThumbnail == "nsfw"))
                                    return "../assets/images/plus-18-movie.png";
                                else if (postThumbnail == "self" || postThumbnail == "default")
                                    return "../assets/images/left-align.png";
                                else
                                    return postThumbnail;
                            }
                            Layout.preferredHeight: postCol.implicitHeight
                            Layout.preferredWidth: Kirigami.Units.iconSizes.enormous
                            fillMode: Image.PreserveAspectFit
                        }

                        ColumnLayout {
                            id: postCol

                            Kirigami.Heading {
                                level: 2
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                text: postTitle
                            }

                            Kirigami.Separator {
                                Layout.fillWidth: true
                            }

                            Controls.Label {
                                id: textLabel

                                textFormat: Text.MarkdownText
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                text: postSelfText.substring(0, Math.min(200, postSelfText.length)) + (postSelfText.length > 200 ? "..." : "")
                            }

                            ColumnLayout {
                                RowLayout {
                                    Controls.Label {
                                        text: "/u/" + postAuthor
                                        font.pointSize: 10
                                    }

                                    Controls.Label {
                                        text: postSubreddit
                                        font.pointSize: 10
                                    }

                                }

                                RowLayout {
                                    Controls.Label {
                                        text: postScore + " pts"
                                        font.pointSize: 10
                                    }

                                    Controls.Label {
                                        text: postNumComments + " cmt" + (postNumComments > 1 || postNumComments == 0 ? "s" : "")
                                        font.pointSize: 10
                                    }

                                }

                            }

                        }

                        TapHandler {
                            onTapped: {
                                console.log("Tapped: " + postTitle);
                                applicationWindow().pageStack.push(Qt.resolvedUrl("./Page.qml"), {
                                    "postTitle": postTitle,
                                    "postSubreddit": postSubreddit,
                                    "postSelfText": postSelfText,
                                    "postHint": postHint,
                                    "postURL": postURL,
                                    "postVideoURL": postVideoURL,
                                    "postPermalink": postPermalink
                                });
                            }
                        }

                    }

                }

            }

        }
        actions.main: Kirigami.Action {
            iconName: "documentinfo"
            text: qsTr("Info")
            checkable: true
            onCheckedChanged: sheet.visible = checked
            shortcut: "Alt+I"
        }

    }
