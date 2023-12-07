import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../additional_pages/calendar_page.dart';

import '../widgets/dialogbuilder.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key, required this.data});
  final List data;

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  //likedrooms, scores file 가져오기
  late SharedPreferences prefs;

  List<String> likedroomsList = [];
  Map scoresMap = {};
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

    final scores = prefs.getString('scores');
    if (scores != null) {
      setState(() {
        scoresMap = json.decode(scores);
      });
    } else {
      String encodedList = json.encode(scoresMap);
      prefs.setString('scores', encodedList);
    }
  }

  //searchbar controller 함수
  final TextEditingController _textEditingController = TextEditingController();

  //각종 변수들
  int isSearched = 0;
  var searchValue = '';
  bool isSorted = false;
  var items = [];
  late List data;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    //정렬하기
    Map newScoreMap = {};
    for (var i in likedroomsList) {
      if (scoresMap[i] != null && scoresMap[i] != '') {
        newScoreMap[i] = scoresMap[i];
      } else {
        newScoreMap[i] = "0";
      }
    }

    Map sortedMap = Map.fromEntries(newScoreMap.entries.toList()
      ..sort(
        (e1, e2) => double.parse(e2.value).compareTo(double.parse(e1.value)),
      ));

    List scoreSortedList = sortedMap.keys.toList();

    var sortedData = [];
    for (var a in scoreSortedList) {
      for (var i in widget.data) {
        if (i[7].toString() == a) {
          sortedData.add(i);
        }
      }
    }

    if (isSorted) {
      data = sortedData;
    } else {
      data = widget.data
          .where(
            (e) => likedroomsList.contains(
              e[7].toString(),
            ),
          )
          .toList();
    }

    void sortList() {
      if (isSorted) {
        setState(() {
          isSorted = false;
        });
      } else {
        setState(() {
          isSorted = true;
        });
      }
    }

    //search 확인
    if (isSearched == 0) {
      setState(() {
        items = data;
      });
    }

    //SerachBar onchange 함수 계속 호출
    void search(String query) {
      if (query.isEmpty) {
        setState(() {
          isSearched = 0;
        });
      } else {
        setState(() {
          isSearched = 1;
          var searchedItems = [];
          for (int i = 0; i < 7; i++) {
            searchedItems = searchedItems +
                data
                    .where(
                      (e) => e[i].toString().contains(query),
                    )
                    .toList();
          }

          items = searchedItems.toSet().toList();
        });
      }
    }

    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('방탈출 랭킹'),
            IconButton(
              onPressed: sortList,
              icon: isSorted
                  ? const Icon(
                      Icons.toggle_on,
                      size: 40,
                    )
                  : const Icon(
                      Icons.toggle_off_outlined,
                      size: 40,
                    ),
            ),
          ],
        ),
      ),
      body:
          //추가
          Column(
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
                  onHeartTap() async {
                    final likedrooms = prefs.getStringList('likedrooms');
                    if (likedrooms != null) {
                      likedrooms.remove(items[index][7].toString());

                      await prefs.setStringList('likedrooms', likedrooms);
                      setState(() {
                        likedroomsList = likedrooms;
                      });
                    }
                  }

                  //score
                  late String score;

                  if (scoresMap.isNotEmpty) {
                    var ids = scoresMap.keys.toList();
                    if (ids.contains(items[index][7].toString())) {
                      score = scoresMap[items[index][7].toString()];
                    } else {
                      score = "0";
                    }
                  } else {
                    score = "0";
                  }

                  onSubmitTap(text) async {
                    if (text != null) {
                      final String? scores = prefs.getString('scores');

                      if (scores != null) {
                        var newData = json.decode(scores);
                        //newData[id] = 입력한 평점
                        //{'id': '평점'}
                        newData[items[index][7].toString()] = text;
                        await prefs.setString('scores', json.encode(newData));
                        setState(() {
                          scoresMap = newData;
                          score = text;
                        });
                      }
                    }
                  }

                  return Card(
                    margin: const EdgeInsets.all(3),
                    child: Column(
                      children: [
                        ListTile(
                            onLongPress: onHeartTap,
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
                                Text(
                                  items[index][6].toString(),
                                ),
                                // IconButton(
                                //     onPressed: onHeartTap,
                                //     icon: const Icon(Icons.favorite))
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
                        Container(
                          color: const Color.fromARGB(148, 255, 255, 255),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                score,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),

                              //평점 매기기
                              IconButton(
                                onPressed: () {
                                  showModal(context, textController, score,
                                      onSubmitTap);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //making List containing score 0
          var b = scoresMap.keys.toList();
          var c = likedroomsList;
          c.removeWhere((item) => b.contains(item));
          var undoList = items
              .where((element) => c.any(element[7].toString().contains))
              .toList();
          //go to Calendar page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarPage(likedroomsList: undoList),
            ),
          );
        },
        child: const Icon(Icons.calendar_month),
      ),
    );
  }

  Future<void> showModal(
      BuildContext context,
      TextEditingController textController,
      String score,
      Future<void> Function(dynamic text) onSubmitTap) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 100,
                        height: 40,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*'),
                            ),
                          ],
                          controller: textController,
                          onChanged: (value) {
                            setState(() {
                              score = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '평점',
                          ),
                        )),
                    const SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (textController.text != '') {
                            onSubmitTap(textController.text);
                          }

                          // 저장하기
                          Navigator.pop(context);
                        },
                        child: const Text('submit'))
                  ],
                ),
              ],
            ),
          );
        });
  }
}
