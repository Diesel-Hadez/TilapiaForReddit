import QtQuick 2.15
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2
import QtQuick.LocalStorage 2.15
import org.kde.kirigami 2.20 as Kirigami

// Base element, provides basic features needed for all kirigami applications
Kirigami.ApplicationWindow {
    // ID provides unique identifier to reference this element
    id: root

    property string sort_period: "year"
    property string current_page: "/r/all"

    function getDb() {
        let db = LocalStorage.openDatabaseSync("DirtedDB", "0.1", "Local storage database for miscellaneous data.", 1e+06);
        return db;
    }

    function addSubToHistory(sub) {
        let db = getDb();
        try {
            db.transaction(function(tx) {
                tx.executeSql("CREATE TABLE IF NOT EXISTS SubList(name TEXT NOT NULL PRIMARY KEY)");
                tx.executeSql("INSERT INTO SubList VALUES(?)", [sub]);
            });
        } catch (e) {
        }
    }

    function refreshSubList() {
        let db = getDb();
        globalDrawer.actions.length = 1;
        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS SubList(name TEXT NOT NULL PRIMARY KEY)");
            let results = tx.executeSql("SELECT name FROM SubList");
            for (let i = 0; i < results.rows.length; i++) {
                let name = results.rows.item(i).name;
                globalDrawer.actions.push(Qt.createQmlObject(`
	import org.kde.kirigami 2.4 as Kirigami
            Kirigami.Action {
                icon.name: "search"
                text: "${name}"
		onTriggered: goToPage("${name}")
            }
	`, globalDrawer, 'SubList.qml'));
            }
        });
    }

    function goToPage(page) {
        myModel.clear();
        page = page[0] == '/' ? page : ('/' + page);
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                addSubToHistory(page);
                let resp = JSON.parse(doc.responseText);
                console.log(resp.data.children[0].data.title);
                resp.data.children.forEach((data, index, arr) => {
                    myModel.append({
                        "postTitle": data.data.title,
                        "postThumbnail": data.data.thumbnail,
                        "postScore": data.data.score,
                        "postSelfText": data.data.selftext,
                        "postNumComments": data.data.num_comments,
                        "postAuthor": data.data.author,
                        "postURL": data.data.url_overridden_by_dest,
                        "postPermalink": data.data.permalink,
                        "postHint": data.data.post_hint,
                        "postSubreddit": data.data.subreddit_name_prefixed,
						"over_18": data.data.over_18,
                    });
                    console.log(data.data.title);
                });
            }
        };
        doc.open("GET", "http://www.reddit.com" + page + "/top.json?limit=10&t=" + sort_period);
        doc.send();
    }

    // Window title
    // i18nc is useful for adding context for translators, also lets strings be changed for different languages
    title: i18nc("@title:window", "Dirted")
    Component.onCompleted: {
        current_page = '/r/all';
        goToPage(current_page);
    }

    ListModel {
        id: myModel
    }
      Kirigami.Dialog {
        id: selectDialog
        title: qsTr("Top of ")
        preferredWidth: Kirigami.Units.gridUnit * 16

        ColumnLayout {
            spacing: 0
            Repeater {
                model: ListModel {
                    // we can't use qsTr/i18n with ListElement
                    Component.onCompleted: {
                        append({"name": qsTr("hour"), "value": "hour"});
                        append({"name": qsTr("day"), "value": "day"});
                        append({"name": qsTr("week"), "value": "week"});
                        append({"name": qsTr("month"), "value": "month"});
                        append({"name": qsTr("year"), "value": "year"});
                        append({"name": qsTr("all"), "value": "all"});
                    }
                }
                delegate: Controls.RadioDelegate {
                    Layout.fillWidth: true
                    topPadding: Kirigami.Units.smallSpacing * 2
                    bottomPadding: Kirigami.Units.smallSpacing * 2

                    text: name
                    checked: value == 1
                    onCheckedChanged: {
                        if (checked) {
                            sort_period = value;
                            goToPage(current_page);
                            showPassiveNotification("Selected Sort by Top of " + name + "!");
                        }
                    }
                }
            }
        }
    }

    globalDrawer: Kirigami.GlobalDrawer {
        id: globalDrawer

        onAboutToShow: {
            refreshSubList();
        }
        isMenu: false
        actions: [
            Kirigami.Action {
                text: i18n("Sort")
                onTriggered: {
                    sort_period = "day";
                    selectDialog.open();
                    goToPage(current_page);
                }
            }
        ]

        header: Kirigami.FormLayout {
            Layout.fillWidth: true
            width: globalDrawer.width

            Controls.TextField {
                placeholderText: "/r/python"
                Kirigami.FormData.label: "Go to: "
                onEditingFinished: {
                    goToPage(text);
                    globalDrawer.close();
                }
            }

            Kirigami.Separator {
                Layout.fillWidth: true
            }

        }

    }

    // Initial page to be loaded on app load
    pageStack.initialPage: Qt.resolvedUrl('HomePage.qml')

}
