import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Services.Mpris
import "root:/data"
import "root:/services"
import "root:/components"

Item {
  id: noti
  property bool showIndicator: Notifications.list.length > 0 || Media.players.length > 0
  Layout.alignment: Qt.AlignCenter

  Text {
    text: "🔔" // You can change this icon
    color: Settings.colors.foreground
    font.pixelSize: 16
    anchors.horizontalCenter: parent.horizontalCenter
    visible: noti.showIndicator
    MouseArea {
      anchors.fill: parent
      onClicked: notificationLoader.item.visible = !notificationLoader.item.visible
    }
  }

  LazyLoader {
    id: notificationLoader
    loading: true
    PopupWindow {
      id: popup
      anchor.window: noti.QsWindow.window
      anchor.rect.x: parentWindow.width * 1.2
      visible: false
      color: "transparent"
      implicitWidth: 400
      implicitHeight: noti.QsWindow.window.height

      Rectangle {
        anchors.fill: parent
        radius: 10
        color: Settings.colors.background

        ColumnLayout {
          spacing: 10
          anchors { fill: parent; topMargin: 15; bottomMargin: 15; leftMargin: 15; rightMargin: 15 }

          Rectangle {
            width: parent.width
            height: 30
            color: Settings.colors.background
            radius: 5
            Text { text: "Notifications"; color: Settings.colors.foreground; font.pixelSize: 20; font.bold: true; anchors.centerIn: parent }
          }

          // This is a placeholder for the Media player, which needs more files
          Rectangle {
            width: parent.width
            height: 120
            radius: 5
            color: Settings.colors.backgroundLighter
            Text { anchors.centerIn: parent; color: Settings.colors.foreground; text: "Media Player" }
          }

          ListView {
            id: notiList
            model: Notifications.list
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            ScrollBar.vertical: ScrollBar {}
            spacing: 15
            delegate: Item {
              required property Notification modelData
              width: parent.width
              height: 80
              Rectangle {
                anchors.fill: parent
                color: Settings.colors.backgroundLighter
                radius: 5
                IconImage {
                  anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                  width: 48
                  height: 48
                  source: Quickshell.iconPath(modelData.appIcon)
                }
                ColumnLayout {
                  anchors { left: parent.left; leftMargin: 75; top: parent.top; topMargin: 10 }
                  spacing: 5
                  Text { text: modelData.appName; color: Settings.colors.foreground; font { pixelSize: 18; bold: true } }
                  Text { text: modelData.body; color: Settings.colors.foreground; font.pixelSize: 13 }
                }
                Text {
                  text: "x"
                  color: Settings.colors.error
                  font.pixelSize: 16
                  anchors { top: parent.top; topMargin: 5; right: parent.right; rightMargin: 10 }
                  MouseArea {
                    anchors.fill: parent
                    onClicked: {
                      modelData.dismiss();
                      if (Notifications.list.length <= 0) { popup.visible = false; }
                    }
                  }
                }
                // Actions (buttons on notifications) would go here
              }
            }
          }
        }
      }
    }
  }
}
