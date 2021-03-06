///
// main.qml
// LifeGame — 2022, Nestik55, toniess
//  Правила игры Жизнь
//  1. Если рядом с мертвой клеткой 3 живых, то зарождается жизнь
//  2. Если рядом с живой клеткой не 2 и не 3 живых, то она умирает
//  3. Обновление поля синхронно
///

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5

import "qrc:/controls" as Controls
import "qrc:/figures" as Figures

ApplicationWindow {
    id: mainWindow
    visible: true

    readonly property real window_scale: 0.75

    readonly property real scale_ratio_x: width / 1650
    readonly property real scale_ratio_y: height / 1050

    width: Screen.width * window_scale
    height: Screen.height * window_scale

    minimumWidth: Screen.width * 0.5
    minimumHeight: Screen.height * 0.5

    onWidthChanged: resizeContent()
    onHeightChanged: resizeContent()

    Component.onCompleted: {
        x = (Screen.width - width) / 2
        y = (Screen.height - height) / 2
    }

    readonly property var theme: {
        "background": "white",
        "bg_second": "#C4C4C4",
        "bg_third": "#E7E7E7",

        "button": "#FFFFFF",
        "pushbutton_active": "#7376F3",
        "pushbutton_inactive": "#CAC9FD",

        "blue": "#7574F3",

        "text_main": "black",
        "text_button": "white",

        "logo_line": "#B0B3F3",
        "separator": "#696BE6",
        "top_panel": "#434AF6",
        "down_panel": "#1F1AF4",

        "cell_alive": "#333333",
        "cell_dead": "transparent"
    }

    function quitApp() {
        Qt.quit()
    }

    function resizeContent() {
        f_animator.resizeContent()
    }

    signal updateWelcomeTextY()
    property int welcomeTextY
    function getWelcomeTextY() {
        updateWelcomeTextY()
        return welcomeTextY
    }

    signal updateWelcomeTextDownY()
    property int welcomeTextDownY
    function getWelcomeTextDownY() {
        updateWelcomeTextDownY()
        return welcomeTextDownY
    }

    signal warning(var err_code)
    function createNewWorld() {
        if(!manager.createNewWorld())
            warning("err")
    }

    function changeMenuPage(page_id) {
        switch (page_id) {
        case "logo":
            pageLoader.sourceComponent = logoPage
            panel.sendTipsY()
            break
        case "plus":
            pageLoader.sourceComponent = newWorldPage
            break
        case "worlds":
            pageLoader.sourceComponent = worldsPage
            break
        case "examples":
            pageLoader.sourceComponent = examplesPage
            break
        case "settings":
            pageLoader.sourceComponent = settingsPage
            break
        }

        f_animator.state = page_id
    }

    FontLoader {
        id: comfortaa_light
        source: "qrc:/fonts/Comfortaa/static/Comfortaa-Light.ttf"
    }
    FontLoader {
        id: comfortaa_regular
        source: "qrc:/fonts/Comfortaa/static/Comfortaa-Regular.ttf"
    }
    FontLoader {
        id: comfortaa_medium
        source: "qrc:/fonts/Comfortaa/static/Comfortaa-Medium.ttf"
    }
    FontLoader {
        id: comfortaa_semibold
        source: "qrc:/fonts/Comfortaa/static/Comfortaa-SemiBold.ttf"
    }

    Component {
        id: logoPage
        LogoPage {id: logoPage_}
    }

    Component {
        id: newWorldPage
        NewWorldPage {}
    }
    Component {
        id: settingsPage
        SettingsPage{}
    }

    background: Rectangle{
        color: theme.background
    }

    property double dx
    property double dy

    Page {
        id: mainPage
        anchors.fill: parent
        anchors.leftMargin: panel.width

        background: Rectangle{
            color: theme.background
        }

        Controls.AnimatorMouseArea {
            id: area
            anchors.fill: parent
            motion_ratio: 500 // the lower the value's module => the more movements
        }

        Loader {
            id: pageLoader
            anchors.fill: parent

        }
        Controls.FigureAnimator {
            id: f_animator
            anchors.fill: parent
        }
    }

    MenuLeftPanel {
        id: panel
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
}
