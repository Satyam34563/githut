import 'package:flutter/material.dart';
import 'package:githut/helper/NetworkHandler.dart';
import 'package:url_launcher/url_launcher.dart';
class RepoDetails extends StatefulWidget {
  RepoDetails({super.key, required this.data});
  var data;
  @override
  State<RepoDetails> createState() => _RepoDetailsState();
}

class _RepoDetailsState extends State<RepoDetails> {
  _seeRepo(linkToNavigate)async{
    var _url = Uri.parse(linkToNavigate);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $linkToNavigate');
    }
  }
  @override
  void initState(){
    super.initState();
    _fetchContributors();
  }
  bool isLoading = false;
  var contributorsLocal=[];
  _fetchContributors()async{
    setState(() {
      isLoading=true;
    });
    var contributors = await NetworkHandler().get(widget.data["contributors_url"]);
    if(contributors!=null){
      contributorsLocal=contributors;
    }
    setState(() {
      contributorsLocal;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           CircleAvatar(
            child:  Image.network(
              widget.data["owner"]["avatar_url"],
              width: 60,
              height: 60,
            ),
           ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.data["name"],
                style:
                    const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              widget.data["full_name"],
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
            ),
            Text(
              widget.data["description"],
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 16),
            ),
            const Padding(
              padding:  EdgeInsets.only(top: 18.0),
              child: Text(
                "Contributors",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
            Flexible(child: isLoading?const Center(child: CircularProgressIndicator(),): ListView.builder(
              itemCount: contributorsLocal.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap:()=> _seeRepo(contributorsLocal[index]["html_url"]),
                  leading: CircleAvatar(child: Image.network(contributorsLocal[index]["avatar_url"]),),
                  title: Text(contributorsLocal[index]["login"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  subtitle: Text("Total contributions: ${contributorsLocal[index]["contributions"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 198, 193, 193),
                        fontSize: 14),
                  ),
                );
              },
            )),
            TextButton(onPressed:()=> _seeRepo(widget.data["html_url"]), child: const Text("View this repository",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                    fontSize: 16),
              ),)
          ],
        ),
      ),
    );
  }
}