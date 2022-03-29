
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:lambabd2/getData.dart';
 import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {

  late YoutubePlayerController _controller;
  String videoTitle="Video Title";

   @override
   void initState() {
    // TODO: implement initState
    var fetchData = Provider.of<getData>(context, listen: false);
    fetchData.getListData();
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl).toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
      ),

    );
  }

  String videoUrl="https://www.youtube.com/embed/4b2_q7jJGCQ";

  void setUrl(String url){
    setState(() {
      videoUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<getData>().getListData();
    return Scaffold(
      appBar:AppBar(
        title: const Text("Video View Page"),
      ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,//test
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 5,),
                child: Text("user",)
            ),
            YoutubePlayer(controller: _controller,
              liveUIColor: Colors.amber,

            ),
            Container(
              color: Colors.black12,
              height: 50,
              width: 500,
              child: Text("$videoTitle",),

            ),
            const SizedBox(height: 50,),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5,),
              child:Text("You may also Like",),

              ) ,

            getListView()
          ],

        ),
      )
    );
  }
Widget getListView() {
  context.read<getData>().getListData();
  return Center(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child:  Consumer<getData>(
            builder:(context,value,child){
              return value.data.isEmpty
                  ? const CircularProgressIndicator()
                  :
                  Expanded(
                      child:ListView.builder(
                          shrinkWrap: true,
                          physics:  const ScrollPhysics(),
                          itemCount: value.data.length,
                          itemBuilder: (context,i){
                            return  Container(
                                margin: const EdgeInsets.all(8),
                                child:Row(
                                  children: [
                                    Expanded(
                                      child:
                                      Image.network(value.data[i].thumbnail.toString(),),
                                      /*YoutubePlayer(
                                        controller: YoutubePlayerController(
                                        initialVideoId: YoutubePlayer.convertUrlToId(value.data[i].url).toString() ,
                                        flags: const YoutubePlayerFlags(
                                          autoPlay: false,
                                          disableDragSeek: false,
                                          loop: false,
                                          isLive: false,
                                          forceHD: false,
                                        ),
                                      ),
                                    )*/
                                    ),

                                    Expanded(
                                        child: ListTile(

                                          title: Text(value.data[i].artist),
                                          subtitle: Text(value.data[i].title),
                                          trailing: const Icon(Icons.more_vert_outlined),
                                          onTap: (){
                                            _controller.load(YoutubePlayer.convertUrlToId(value.data[i].url).toString());

                                           setState(() {

                                              videoUrl = value.data[i].url.toString();
                                              videoTitle=value.data[i].title.toString();
                                            });/*
                                            setUrl(value.data[i].url.toString());
                                            print(value.data[i].url.toString());*/
                                          },
                                        ))
                                  ],
                                )
                            );
                          }
                      ));

            }
        )
      ),

    );
}
  Future<void> _onRefresh() async{
    await Future.delayed(const Duration(seconds: 2));
    await context.read<getData>().getListData();

    setState(() {

    });
  }
}
