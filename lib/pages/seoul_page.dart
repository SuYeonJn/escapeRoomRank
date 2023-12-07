import 'package:flutter/material.dart';
import '../widgets/ranking_list.dart';

class Seoul extends StatefulWidget {
  const Seoul({super.key, required this.data});
  final List data;

  @override
  State<Seoul> createState() => _SeoulState();
}

class _SeoulState extends State<Seoul> {
  var locations = [
    '강남',
    '신촌',
    "홍대",
    '건대',
    "신림",
    "강북",
    "대학로",
    "서울(기타)",
  ];
  @override
  Widget build(BuildContext context) {
    var lists = [];
    var recievedData = widget.data
        .where((e) => locations.any(e[6].toString().contains))
        .toList();

    for (int i = 0; i < locations.length; i++) {
      var list = recievedData
          .where((e) => e[6].toString().contains(locations[i]))
          .toList();
      lists.add(list);
    }
    return DefaultTabController(
      length: locations.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('방탈출 랭킹'),
          bottom: TabBar(isScrollable: true, tabs: [
            const Tab(text: '서울'),
            for (int i = 0; i < locations.length; i++)
              Tab(
                text: locations[i],
              )
          ]),
        ),
        body: TabBarView(children: <Widget>[
          RankingList(
            data: recievedData,
            checkAll: true,
          ),
          for (int i = 0; i < locations.length; i++)
            RankingList(
              data: lists[i],
              checkAll: false,
            )
        ]),
      ),
    );
  }
}
