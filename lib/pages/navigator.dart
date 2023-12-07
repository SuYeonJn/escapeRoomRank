import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

import '../widgets/ranking_list.dart';
import '../pages/seoul_page.dart';
import '../pages/near_seoul_page.dart';
import '../pages/non_seoul_page.dart';
import '../pages/note_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _data = [];

  //csv 파일 로드해서 lists 에 집어넣기

  void loadAll() async {
    final rawData = await DefaultAssetBundle.of(context).loadString(
      "assets/all_location.csv",
    );
    List<List<dynamic>> listData =
        const CsvToListConverter().convert(rawData, eol: '\n');
    setState(() {
      _data = listData;
    });
  }

  int currentPageIndex = 0;

  @override
  void initState() {
    //첫 로드했을 때 실행되는 함수
    super.initState();
    loadAll();
  }

  @override
  Widget build(BuildContext context) {
    late Widget page;

    switch (currentPageIndex) {
      case 0:
        page = Seoul(data: _data);

        break;
      case 1:
        setState(() {
          page = NearSeoul(data: _data);
        });
        break;
      case 2:
        setState(() {
          page = NonSeoul(data: _data);
        });
        break;
      case 3:
        setState(() {
          page = Scaffold(
            appBar: AppBar(
              title: const Text('방탈출 랭킹'),
            ),
            body: RankingList(
              data: _data,
              checkAll: true,
            ),
          );
        });
        break;
      case 4:
        setState(() {
          page = NoteWidget(
            data: _data,
          );
        });
        break;
      default:
        throw UnimplementedError('no widget for');
    }
    return Scaffold(
      body: page,
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: const Color.fromARGB(255, 205, 205, 205),
        backgroundColor: const Color.fromARGB(231, 255, 255, 255),
        indicatorColor: const Color.fromARGB(238, 234, 234, 234),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.location_on_outlined), label: '서울'),
          NavigationDestination(
              icon: Icon(Icons.location_on_outlined), label: '수도권'),
          NavigationDestination(
              icon: Icon(Icons.location_on_outlined), label: '지방'),
          NavigationDestination(
              icon: Icon(Icons.location_on_outlined), label: '전체'),
          NavigationDestination(icon: Icon(Icons.edit_document), label: '기록'),
        ],
      ),
    );
  }
}
