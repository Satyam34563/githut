import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:githut/helper/NetworkHandler.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static String routeName = 'HomePage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController textController = TextEditingController();
  bool isLoading = true;
  @override
  void initState(){
    super.initState();
    _getOfflineData();
  }
  _getOfflineData()async{
    var sessionmanager = SessionManager();
    print("fetching data from local storage");
    var offlineData = await sessionmanager.get("15records");
    print("done");

    if (offlineData != null) {
      dataSet = offlineData;
    }
    setState(() {
      dataSet;
      isLoading=false;
    });
  }
  _addDataToLocalStorage(data)async{
    if(data!=null){
      var sessionmanager = SessionManager();
      await sessionmanager.set("15records", jsonEncode(data["items"]));
    }
    
    // var prevData = await sessionmanager.get("15records");
    // if(data && data["items"]){
    //   for(var d in data["items"]){
    //     prevData.push(d);
    //   }
    // }
  }
  var dataSet = [];
  _fetchData(var input)async{
    setState(() {
      isLoading = true;
    });
    var data = await NetworkHandler().get("https://api.github.com/search/repositories?q=${input}&per_page=10&page=0");
    _addDataToLocalStorage(data);
    if(data==null){
      dataSet = [];
    }else{
      print("printing... data items");
      print(data["items"]);
      print("object ended");
      dataSet = data["items"];
    }
    setState(() {
      dataSet;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 66, 61, 61),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.network(
              "https://pngimg.com/uploads/github/github_PNG85.png",
              width: 60,
              height: 60,
            ),
            const Text(
              "GitHut",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: buildEmailField(),
          ),
          isLoading?const Center(child: CircularProgressIndicator(),): Flexible(child: ListView.builder(
            itemCount: dataSet.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color.fromARGB(255, 145, 135, 135))
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        child: Image.network(dataSet[index]["owner"]["avatar_url"]),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dataSet[index]["name"], style: const TextStyle(color: Colors.white, fontSize: 20),),
                        Text("Language: ${dataSet[index]["language"]}",
                          style: const TextStyle(color: Color.fromARGB(255, 189, 185, 185), fontSize: 16),
                        ),
                        Text("views: ${dataSet[index]["watchers"]}",
                          style: const TextStyle(color: Color.fromARGB(255, 189, 185, 185), fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Open issues count: ${dataSet[index]["open_issues"]}, ",
                              style:
                                  const TextStyle(color: Color.fromARGB(255, 189, 185, 185), fontSize: 16),
                            ),
                            Text(
                              "forks: ${dataSet[index]["forks"]}",
                              style:
                                  const TextStyle(color: Color.fromARGB(255, 189, 185, 185), fontSize: 16),
                            )
                          ],
                        )
                        
                      ],
                    )
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
  _inputChange(input)async{
      print(input);
    if(input != ""){
      print(input);
      _fetchData(input);
    }else{
      await _getOfflineData();
    }
  }
  TextField buildEmailField() {
    return TextField(
      controller: textController,
      onSubmitted: (value) => _inputChange(value),
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      // style: kInputTextStyle,
      decoration:  InputDecoration(
        labelText: 'User Id',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      
    );
  }
}


