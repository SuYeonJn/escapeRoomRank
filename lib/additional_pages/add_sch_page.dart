import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';

import 'package:intl/intl.dart';

import 'package:dropdown_textfield/dropdown_textfield.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleMaker extends StatefulWidget {
  const ScheduleMaker(
      {super.key, required this.selectedDate, required this.likedroomsList});
  final DateTime selectedDate;
  final List likedroomsList;
  @override
  State<ScheduleMaker> createState() => _ScheduleMakerState();
}

class _ScheduleMakerState extends State<ScheduleMaker> {
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  void _openTimePickerSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: '시작 시간',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
        minuteInterval: 5,
        minHour: 8,
        initialDateTime: widget.selectedDate,
      ),
    );

    if (result != null) {
      var a = DateFormat('HH:mm:ss').format(result).toString();
      var b = DateFormat('dd/MM/yyyy').format(widget.selectedDate).toString();
      setState(() {
        startTime = DateFormat('dd/MM/yyyy HH:mm:ss').parse('$b $a');
      });
    }
  }

  final TextEditingController textController = TextEditingController();
  String playTime = '';
  String theme = '';
  late String id;

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  final db = FirebaseFirestore.instance;

  void onSubmitSch() {
    db.collection("CalendarAppointmentCollection").doc(id).set({
      'Theme': theme,
      'StartTime':
          DateFormat('dd/MM/yyyy HH:mm:ss').format(startTime).toString(),
      'EndTime': DateFormat('dd/MM/yyyy HH:mm:ss').format(endTime).toString(),
      'Id': id,
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (playTime != '') {
      endTime = startTime.add(Duration(minutes: int.parse(playTime)));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            DateFormat('yyyy/MM/dd').format(widget.selectedDate).toString()),
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(title: "테마"),
            DropDownTextField(
              clearOption: false,
              textFieldFocusNode: textFieldFocusNode,
              searchFocusNode: searchFocusNode,
              // searchAutofocus: true,
              dropDownItemCount: 3,
              searchShowCursor: false,
              enableSearch: true,
              dropDownList: [
                for (var a in widget.likedroomsList)
                  DropDownValueModel(
                    name: "${a[1]} - ${a[0]}",
                    value: a[7].toString(),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  theme = value.name;
                  id = value.value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const TitleWidget(title: "Schedule"),
            Row(
              children: [
                Text(
                  '${DateFormat.Hm().format(startTime)} ~ ${DateFormat.Hm().format(endTime)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _openTimePickerSheet(context);
                    },
                    child: const Text('시작 시간')),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const TitleWidget(title: "플레이 타임"),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                    width: 70,
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d*'),
                        ),
                      ],
                      controller: textController,
                      onChanged: (value) {
                        setState(() {
                          if (value != '') {
                            playTime = value;
                          }
                        });
                      },
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 180, 180, 180),
                        ),
                      )),
                    )),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '분',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (theme.isNotEmpty && playTime.isNotEmpty) {
                    onSubmitSch();
                    Navigator.pop(context);
                  } else {
                    const AlertDialog(
                      title: Text('입력을 완료하세요'),
                      content: Text('입력을 완료하세요'),
                    );
                  }
                },
                child: const Text('submit')),
          ],
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 33, 36, 122),
      ),
    );
  }
}
