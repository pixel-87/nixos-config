import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Layouts
import "root:/data"

Item {
  id: volRoot
  Layout.alignment: Qt.AlignCenter
  Layout.preferredWidth: volText.implicitWidth
  Layout.preferredHeight: volText.implicitHeight
  
  property string volume: "0%"
  property bool muted: false

  Process {
    id: volumeProcess
    command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
    stdout: StdioCollector {
      onStreamFinished: {
        var output = text.trim();
        volRoot.muted = output.includes("MUTED");
        var vol = output.replace("Volume:", "").replace("MUTED", "").trim();
        var percentage = Math.round(parseFloat(vol) * 100);
        volRoot.volume = percentage + "%";
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: volumeProcess.running = true
  }

  Process {
    id: muteToggle
    running: false
    command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
    onRunningChanged: {
      if (!running) {
        updateTimer.running = true
      }
    }
  }

  Timer {
    id: updateTimer
    interval: 100
    running: false
    onTriggered: volumeProcess.running = true
  }

  Text {
    id: volText
    text: volRoot.muted ? "✕" + volRoot.volume : "♪" + volRoot.volume
    color: Settings.colors.foreground
    font.pointSize: 10
    font.family: "monospace"
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: muteToggle.running = true
  }
}
