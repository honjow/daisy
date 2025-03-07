import 'package:daisy/configs/android_display_mode.dart';
import 'package:daisy/configs/auto_clean.dart';
import 'package:daisy/configs/login.dart';
import 'package:daisy/configs/themes.dart';
import 'package:daisy/configs/versions.dart';
import 'package:flutter/material.dart';

import '../cross.dart';
import 'components/badged.dart';
import 'login_screen.dart';

const _releaseUrl = "https://github.com/niuhuan/daisy/releases/";

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AboutState();
  }
}

class _AboutState extends State<AboutScreen> {

  @override
  void initState() {
    loginEvent.subscribe(_l);
    super.initState();
  }

  @override
  void dispose() {
    loginEvent.unsubscribe(_l);
    super.dispose();
  }

  _l(_){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
      ),
      body: ListView(
        children: [
          const Divider(),
          _buildLogo(),
          const Divider(),
          ..._loginInfo(),
          const Divider(),
          _buildCurrentVersion(),
          const Divider(),
          _buildNewestVersion(),
          const Divider(),
          _buildGotoGithub(),
          const Divider(),
          _buildVersionText(),
          const Divider(),
          const Divider(),
          autoCleanSetting(),
          const Divider(),
          lightThemeSetting(),
          darkThemeSetting(),
          const Divider(),
          androidDisplayModeSetting(),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double? width, height;
        if (constraints.maxWidth < constraints.maxHeight) {
          width = constraints.maxWidth / 2;
        } else {
          height = constraints.maxHeight / 2;
        }
        return Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: SizedBox(
              width: width,
              height: height,
              child: Image.asset(
                "lib/assets/startup.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentVersion() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Text("当前版本 : ${currentVersion()}"),
    );
  }

  Widget _buildNewestVersion() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Text.rich(TextSpan(
        children: [
          const TextSpan(text: "最新版本 : "),
          _buildNewestVersionSpan(),
          _buildCheckButton(),
        ],
      )),
    );
  }

  InlineSpan _buildNewestVersionSpan() {
    return WidgetSpan(
      child: Container(
        padding: const EdgeInsets.only(right: 20),
        child: VersionBadged(
          child: Text(
            "${latestVersion ?? "没有检测到新版本"}    ",
          ),
        ),
      ),
    );
  }

  InlineSpan _buildCheckButton() {
    return WidgetSpan(
      child: GestureDetector(
        child: const Text(
          "检查更新",
          style: TextStyle(height: 1.3, color: Colors.blue),
          strutStyle: StrutStyle(height: 1.3),
        ),
        onTap: () {
          manualCheckNewVersion(context);
        },
      ),
    );
  }

  Widget _buildGotoGithub() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GestureDetector(
        child: const Text(
          "去下载地址",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          openUrl(_releaseUrl);
        },
      ),
    );
  }

  Widget _buildVersionText() {
    var info = latestVersionInfo();
    if (info != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: SelectableText("更新内容\n\n$info"),
      );
    }
    return Container();
  }

  List<Widget> _loginInfo() {
    if (loginInfo.status == 0) {
      return [
        ListTile(
          title: Text("已登录 : ${loginInfo.data?.nickname}"),
        ),
      ];
    } else if (loginInfo.status == 1) {
      return [
         ListTile(
           onTap: (){
             Navigator.of(context).push(MaterialPageRoute(
               builder: (BuildContext context) {
                 return const LoginScreen();
               },
             ));
           },
          title: const Text("未登录"),
        ),
      ];
    } else if (loginInfo.status == 2) {
      return [
        ListTile(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return const LoginScreen();
              },
            ));
          },
          title: Text("登录失败 : ${loginInfo.message}"),
        ),
      ];
    }
    return [];
  }
}
