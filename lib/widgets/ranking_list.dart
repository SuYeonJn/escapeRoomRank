import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dialogbuilder.dart';

class RankingList extends StatefulWidget {
  const RankingList({
    super.key,
    required this.data,
    required this.checkAll,
  });

  final List<dynamic> data;
  final bool checkAll;

  @override
  State<RankingList> createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  //dialogbuilder 함수

  //검색 함수
  var items = [];
  late List data;

  //searchbar controller 함수
  final TextEditingController _textEditingController = TextEditingController();

  int defaultIndex = 0;
  var searchValue = '';

  //좋아요 저장 함수
  late SharedPreferences prefs;
  List likedroomsList = [];
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedrooms = prefs.getStringList('likedrooms');
    if (likedrooms != null) {
      setState(() {
        likedroomsList = likedrooms;
      });
    } else {
      prefs.setStringList('likedrooms', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    //SerachBar onchange 함수 계속 호출
    void search(String query) {
      if (query.isEmpty) {
        setState(() {
          defaultIndex = 0;
        });
      } else {
        setState(() {
          defaultIndex = 1;
          var searchedItems = [];
          for (int i = 0; i < 7; i++) {
            searchedItems = searchedItems +
                data
                    .where(
                      (e) => e[i]
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()),
                    )
                    .toList();
          }

          items = searchedItems.toSet().toList();
        });
      }
    }

    if (defaultIndex == 0) {
      data = widget.data;
      setState(() {
        items = data;
      });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 10.0,
            right: 3.0,
            left: 3.0,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              SearchBar(
                controller: _textEditingController,
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                  search(searchValue);
                },
                leading: IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.search),
                ),
                hintText: '검색',
                constraints: const BoxConstraints(
                  maxHeight: 45,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                late bool isLiked;
                if (likedroomsList.isNotEmpty) {
                  if (likedroomsList.contains(items[index][7].toString()) ==
                      true) {
                    isLiked = true;
                  } else {
                    isLiked = false;
                  }
                } else {
                  isLiked = false;
                }

                onHeartTap() async {
                  final likedrooms = prefs.getStringList('likedrooms');
                  if (likedrooms != null) {
                    if (isLiked) {
                      likedrooms.remove(items[index][7].toString());
                    } else {
                      //id 저장
                      likedrooms.add(items[index][7].toString());
                    }
                    await prefs.setStringList('likedrooms', likedrooms);
                    setState(() {
                      likedroomsList = likedrooms;
                      isLiked = !isLiked;
                    });
                  }
                }

                return Card(
                  margin: const EdgeInsets.all(3),
                  child: ListTile(
                      onLongPress: onHeartTap,
                      selected: isLiked ? true : false,
                      selectedColor: const Color.fromARGB(235, 0, 0, 0),
                      tileColor: const Color.fromARGB(255, 255, 255, 255),
                      leading: Text((index + 1).toString(),
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          )),
                      title: Text(items[index][1].toString()),
                      subtitle: Text(items[index][0].toString()),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          Column(
                            children: [
                              const Text('난이도'),
                              Text(items[index][5].toString()),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('리뷰 수'),
                              Text(items[index][3].toString()),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('평점'),
                              Text(items[index][2].toString()),
                            ],
                          ),
                          if (widget.checkAll)
                            Text(
                              items[index][6].toString(),
                            ),
                          // IconButton(
                          //     onPressed: onHeartTap,
                          //     icon: isLiked
                          //         ? const Icon(Icons.favorite)
                          //         : const Icon(Icons.favorite_border_outlined))
                        ],
                      ),
                      onTap: () async {
                        var store = items[index][0].toString();
                        final Uri mapUrl = Uri.parse(
                          'https://m.map.naver.com/search2/search.naver?query=$store',
                        );
                        final Uri reviewUrl = Uri.parse(
                          items[index][4].toString(),
                        );
                        DialogBuilder()
                            .dialogBuilder(context, mapUrl, reviewUrl);
                      }),
                );
              }),
        ),
      ],
    );
  }
}
