import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"
import "root:/services"

Item {
  id: workspaces
  property int selectedWorkspace: 1
  Layout.alignment: Qt.AlignVCenter // Align vertically in the center
  width: 200 // Give it horizontal space
  height: 20 // 

  Process {
    id: getSelectedWorkspace
    command: ["hyprctl", "activeworkspace", "-j"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          var jsonData = JSON.parse(text);
          if (jsonData.id) {
            workspaces.selectedWorkspace = jsonData.id;
          }
        } catch (e) {
          console.error("Failed to parse hyprctl JSON:", e, text);
        }
      }
    }
  }

  Timer {
    interval: 200
    running: true
    repeat: true
    onTriggered: getSelectedWorkspace.running = true
  }

  RowLayout {
    spacing: 12
    anchors.verticalCenter: parent.verticalCenter

    Repeater {
      model: 9
      delegate: Item {
        id: workspace
        required property int index
        width: 14
        height: 14

        Rectangle {
          width: 8
          height: 8
          radius: 4
          anchors.centerIn: parent
          color: (workspaces.selectedWorkspace === (index + 1)) ? Settings.colors.accent : "transparent"
          border.color: Settings.colors.foreground
          border.width: 1
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var newWorkspace = index + 1
                Quickshell.run(["hyprctl", "dispatch", "workspace", newWorkspace.toString()])
            }
        }
      }
    }
  }
}
