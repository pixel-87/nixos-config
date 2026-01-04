import QtQuick
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

Item {
  id: storageRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: storageContainer.implicitWidth
  Layout.preferredHeight: storageContainer.implicitHeight
  
  property string used: "0.0G"

  Process {
    id: storageProcess
    command: ["sh", "-c", "df -h / | awk 'NR==2{gsub(/G/,\"\", $3); gsub(/G/,\"\", $2); printf \"%.1f/%.1fGiB\", $3, $2}'"]
    stdout: StdioCollector {
      onStreamFinished: storageRoot.used = text
    }
  }

  Timer {
    interval: 30000  // Check every 30 seconds instead of 2 seconds
    running: true
    repeat: true
    onTriggered: storageProcess.running = true
  }

  RowLayout {
    id: storageContainer
    spacing: 8
    
    // Storage Icon
    Text {
      text: "󰋊"
      color: Settings.colors.foreground
      font.pointSize: 11
      Layout.alignment: Qt.AlignCenter
    }
    
    // Storage usage
    Text { 
      id: storageText
      text: storageRoot.used
      color: Settings.colors.foreground
      font.pointSize: 10
      font.family: "monospace"
    }
  }
}
