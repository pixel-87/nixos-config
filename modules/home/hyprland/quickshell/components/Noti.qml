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
  property bool showIndicator: Notifications.list.length > 0
  property bool panelOpen: false
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: notiText.implicitWidth
  Layout.preferredHeight: notiText.implicitHeight

  Text {
    id: notiText
    text: Notifications.list.length > 0 ? "●" + Notifications.list.length : "○"
    color: Settings.colors.foreground
    font.pointSize: 10
    font.family: "monospace"
  }

  MouseArea {
    anchors.fill: parent
    onClicked: noti.panelOpen = !noti.panelOpen
  }

  LazyLoader {
    id: notificationLoader
    loading: noti.panelOpen
    
    PanelWindow {
      id: panel
      visible: noti.panelOpen
      screen: noti.QsWindow.screen
      color: "transparent"
      
      anchors {
        right: true
        top: true
        bottom: true
      }
      
      width: 400
      margins {
        right: 10
        top: 10
        bottom: 10
      }

      Rectangle {
        anchors.fill: parent
        radius: 10
        color: Settings.colors.background
        border.color: Settings.colors.foreground
        border.width: 1

        ColumnLayout {
          spacing: 10
          anchors { fill: parent; topMargin: 15; bottomMargin: 15; leftMargin: 15; rightMargin: 15 }

          RowLayout {
            Layout.fillWidth: true
            height: 30
            spacing: 10
            
            Text { 
              text: "Notifications (" + Notifications.list.length + ")"
              color: Settings.colors.foreground
              font.pixelSize: 20
              font.bold: true
              Layout.fillWidth: true
            }
            
            Text {
              text: "Clear All"
              color: Settings.colors.error
              font.pixelSize: 14
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  Notifications.list.forEach(notif => notif.dismiss())
                  noti.panelOpen = false
                }
              }
            }
            
            Text {
              text: "✕"
              color: Settings.colors.foreground
              font.pixelSize: 20
              font.bold: true
              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: noti.panelOpen = false
              }
            }
          }

          ListView {
            id: notiList
            model: Notifications.list
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical: ScrollBar {}
            spacing: 10
            clip: true
            
            delegate: Item {
              required property Notification modelData
              width: notiList.width
              height: 80
              
              Rectangle {
                anchors.fill: parent
                color: Settings.colors.backgroundLighter
                radius: 5
                border.color: Settings.colors.foreground
                border.width: 1
                
                IconImage {
                  id: appIcon
                  anchors { 
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                  }
                  width: 40
                  height: 40
                  source: Quickshell.iconPath(modelData.appIcon)
                }
                
                ColumnLayout {
                  anchors { 
                    left: appIcon.right
                    leftMargin: 10
                    right: closeButton.left
                    rightMargin: 10
                    top: parent.top
                    topMargin: 10
                    bottom: parent.bottom
                    bottomMargin: 10
                  }
                  spacing: 5
                  
                  Text {
                    text: modelData.appName
                    color: Settings.colors.foreground
                    font.pixelSize: 16
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                  }
                  
                  Text {
                    text: modelData.body
                    color: Settings.colors.foreground
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                  }
                }
                
                Rectangle {
                  id: closeButton
                  anchors {
                    top: parent.top
                    topMargin: 8
                    right: parent.right
                    rightMargin: 8
                  }
                  width: 24
                  height: 24
                  radius: 12
                  color: "transparent"
                  border.color: Settings.colors.error
                  border.width: 1
                  
                  Text {
                    text: "×"
                    color: Settings.colors.error
                    font.pixelSize: 18
                    font.bold: true
                    anchors.centerIn: parent
                  }
                  
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                      modelData.dismiss()
                      if (Notifications.list.length <= 0) {
                        noti.panelOpen = false
                      }
                    }
                  }
                }
              }
            }
          }
          
          // Empty state
          Item {
            visible: Notifications.list.length === 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Text {
              anchors.centerIn: parent
              text: "No notifications"
              color: Settings.colors.foreground
              font.pixelSize: 14
              opacity: 0.5
            }
          }
        }
      }
    }
  }
}