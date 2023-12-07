import 'package:flutter/material.dart';
import '../widgets/ranking_list.dart';

class NonSeoul extends StatefulWidget {
  const NonSeoul({super.key, required this.data});
  final List data;

  @override
  State<NonSeoul> createState() => _NonSeoulState();
}

class _NonSeoulState extends State<NonSeoul> {
  var locations = [
    '대전',
    '천안',
    '청주',
    '충청(기타)',
    '대구',
    '부산',
    '경상(기타)',
    '전주',
    '광주',
    '전라(기타)',
    '강원',
    '제주'
  ];
  var lists = [];
  @override
  Widget build(BuildContext context) {
    var data = widget.data
        .where((e) => locations.any(e[6].toString().contains))
        .toList();

    for (int i = 0; i < locations.length; i++) {
      var list =
          data.where((e) => e[6].toString().contains(locations[i])).toList();
      lists.add(list);
    }
    return DefaultTabController(
      length: locations.length + 1,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('방탈출 랭킹'),
            bottom: TabBar(isScrollable: true, tabs: [
              const Tab(text: '지방'),
              for (int i = 0; i < locations.length; i++)
                Tab(
                  text: locations[i],
                )
            ]),
          ),
          body: TabBarView(children: <Widget>[
            RankingList(
              data: data,
              checkAll: true,
            ),
            for (int i = 0; i < locations.length; i++)
              RankingList(
                data: lists[i],
                checkAll: false,
              )
          ])),
    );
  }
}
