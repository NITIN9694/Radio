import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio/Colors.dart';
import 'package:radio/Module/Radio.dart';
import 'package:velocity_x/velocity_x.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color selectedColor;
  bool _isPlaying =false;
  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fatchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == AudioPlayerState.PLAYING ){
        _isPlaying =true;
      }
      else{
        _isPlaying =true;
      }
    });
  }
  fatchRadios()async{
   final rediojson =await rootBundle.loadString("assests/radio.json");
   radios = MyRadioList.fromJson(
     rediojson
   ).radios;
   print(radios);
   setState(() {
     
   });
  }
  _playmusic(String url){
    _audioPlayer.play(url);
    _selectedRadio =radios.firstWhere((element) => element.url == url);
    print(_selectedRadio.name);
    setState(() {
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body:  Stack(
        children: [
           VxAnimatedBox().size(context.screenWidth, context.screenHeight).withGradient(
             LinearGradient(colors:[
               RadioColor.primaryColor1,
               RadioColor.primaryColor2
             ],
             begin: Alignment.topLeft,
             end: Alignment.bottomRight,
             )
           ).make(),
           AppBar(
             centerTitle: true,
             title: "Radio".text.xl4.bold.white.make(),
             backgroundColor: Colors.transparent,
             elevation: 0.0,
           ).h(100).p16(),
         
            radios !=null ?VxSwiper.builder(itemCount: radios.length,
           aspectRatio: 1.0,
           onPageChanged: (index){
             final colorHex =radios[index].color;
             print(radios[index].color);
             selectedColor = Color(int.tryParse(colorHex));
             setState(() {
               
             });
           },
           enlargeCenterPage: true,
            itemBuilder: (context,index){
             final rad =radios[index];
             return VxBox(
               
             child: ZStack(
            [
            Align(
              alignment: Alignment.bottomCenter,
              child: VStack(
                [
                  rad.name.text.xl3.white.bold.make(),
                  5.heightBox,
                  rad.tagline.text.sm.white.semiBold.make(),
                ],
               crossAlignment: CrossAxisAlignment.center,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: [
             Icon(
               CupertinoIcons.play_circle,color: Colors.white,
             ),
             10.heightBox,
             "Duoble Tap to Paly".text.gray300.make(),
              ].vStack(),
            )
            ]
             )
             ).bgImage(
               DecorationImage(image: NetworkImage(
                 rad.image
               ),
               fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),BlendMode.darken)
               )
             ).withRounded(value:60).
             make().
             onInkDoubleTap(() {
               _playmusic(rad.url);
             })
             .p(
               13
             ).
             
             centered();
             
            }):CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
            Align(alignment: Alignment.bottomCenter,
            child:[
             if(_isPlaying)"Playing Now =${_selectedRadio.name} FM".text.white.makeCentered(), 
              Icon(
             _isPlaying?CupertinoIcons.stop_circle:CupertinoIcons.play_circle,
              color: Colors.white,
              size: 50.0,
            ).onInkTap(() {
              if(_isPlaying=true){
                _audioPlayer.stop();
                
              }else{
                _playmusic(
                  _selectedRadio.url
                  
                );
              }
            })].vStack(),
            ).pOnly(
              bottom: context.percentHeight*12
            )

           
        ],
        fit: StackFit.expand,
      )
    );
  }
}