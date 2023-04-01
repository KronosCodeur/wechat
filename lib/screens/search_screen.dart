import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat/services/database_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Search",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 27,),),
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.exit_to_app_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: CupertinoColors.systemBlue.highContrastElevatedColor,
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(color: CupertinoColors.white,fontWeight: FontWeight.w600,fontSize: 18),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups.....",
                      hintStyle: GoogleFonts.poppins(color: CupertinoColors.white.withOpacity(0.5),fontWeight: FontWeight.w600,fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: CupertinoColors.white.withOpacity(0.15)
                    ),
                    child: Icon(Icons.search_rounded,size: 30,),
                  ),
                ),
              ],
            ),
          ),
          _isLoading?Center(child: CircularProgressIndicator(color: CupertinoColors.systemBlue,strokeWidth: 2,),):groupList(),
        ],
      )
    );
  }
  initiateSearchMethod() async{
    if(searchController.text.isNotEmpty){
      setState(() {
        _isLoading=true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          _isLoading=false;
          hasUserSearch=true;
        });
      });
    }else{

    }
  }
  groupList(){
    return hasUserSearch?ListView.builder(
      shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return groupTile();
        },
    ):Container();
  }
  groupTile(String userName, S){

  }
}
