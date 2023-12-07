import 'package:flutter/material.dart';
import '../widgets/ranking_list.dart';

class NearSeoul extends StatefulWidget {
  const NearSeoul({super.key, required this.data});
  final List data;

  @override
  State<NearSeoul> createState() => _NearSeoulState();
}

class _NearSeoulState extends State<NearSeoul> {
  var locations = [
    '부천',
    '일산',
    '수원',
    '안양',
    '경기(기타)',
    '인천',
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
              const Tab(text: '수도권'),
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
