import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

Rectangle {
  id: wallpaperSwitcher
  color: "#1e1e2e"
  radius: 10
  width: 600
  height: 400
  
  property bool isOpen: false
  property var wallpapers: []
  property string currentWallpaper: ""
  property var currentIndex: 0

  // Load wallpapers on startup
  Component.onCompleted: {
    loadWallpapers()
  }

  function loadWallpapers() {
    const proc = Qt.createQmlObject(
      'import Qt.labs.platform; StandardPaths {}',
      wallpaperSwitcher
    )
    
    // Execute shell command to get wallpapers
    const wallpaperDir = Qt.getEnv("HOME") + "/wallpapers"
    
    // This would typically be done with a proper process/socket mechanism
    // For now, we'll create a simplified version
    wallpapers = [
      wallpaperDir + "/evangelion.jpg",
      wallpaperDir + "/fingers.jpg",
      wallpaperDir + "/might_and_magic.jpg",
      wallpaperDir + "/violet.jpg",
      wallpaperDir + "/wallpaper.png"
    ]
  }

  function setWallpaper(path) {
    const cmd = "wallpaper-switcher set '" + path + "' fade"
    Hyprland.dispatch("exec", cmd)
    currentWallpaper = path
  }

  function nextWallpaper() {
    currentIndex = (currentIndex + 1) % wallpapers.length
    setWallpaper(wallpapers[currentIndex])
  }

  function prevWallpaper() {
    currentIndex = (currentIndex - 1 + wallpapers.length) % wallpapers.length
    setWallpaper(wallpapers[currentIndex])
  }

  Column {
    anchors {
      fill: parent
      margins: 20
    }
    spacing: 15

    Text {
      text: "Wallpaper Switcher"
      color: "#cdd6f4"
      font {
        pixelSize: 24
        bold: true
      }
    }

    // Wallpaper grid
    GridLayout {
      columns: 3
      rowSpacing: 10
      columnSpacing: 10
      Layout.fillWidth: true
      Layout.fillHeight: true

      Repeater {
        model: wallpapers.length

        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "#313244"
          radius: 8
          border {
            color: currentIndex === index ? "#a6e3a1" : "#45475a"
            width: currentIndex === index ? 3 : 1
          }

          Image {
            anchors.fill: parent
            source: "file://" + wallpapers[index]
            fillMode: Image.PreserveAspectCrop
            cache: false
            opacity: 0.6
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              currentIndex = index
              setWallpaper(wallpapers[index])
            }
            hoverEnabled: true
            onEntered: parent.opacity = 0.8
            onExited: parent.opacity = 1.0
          }

          Text {
            anchors {
              bottom: parent.bottom
              left: parent.left
              margins: 8
            }
            text: wallpapers[index].split('/').pop()
            color: "#cdd6f4"
            font.pixelSize: 12
            elide: Text.ElideRight
            width: parent.width - 16
          }
        }
      }
    }

    // Controls
    RowLayout {
      spacing: 10
      Layout.fillWidth: true

      Button {
        text: "← Previous"
        Layout.fillWidth: true
        onClicked: prevWallpaper()
        background: Rectangle {
          color: "#45475a"
          radius: 6
        }
        contentItem: Text {
          text: parent.text
          color: "#cdd6f4"
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      Button {
        text: "Refresh"
        Layout.fillWidth: true
        onClicked: loadWallpapers()
        background: Rectangle {
          color: "#45475a"
          radius: 6
        }
        contentItem: Text {
          text: parent.text
          color: "#cdd6f4"
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }

      Button {
        text: "Next →"
        Layout.fillWidth: true
        onClicked: nextWallpaper()
        background: Rectangle {
          color: "#45475a"
          radius: 6
        }
        contentItem: Text {
          text: parent.text
          color: "#cdd6f4"
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    // Current wallpaper info
    Text {
      text: "Current: " + (currentWallpaper ? currentWallpaper.split('/').pop() : "None")
      color: "#94e2d5"
      font.pixelSize: 12
      Layout.fillWidth: true
    }
  }
}
