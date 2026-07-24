import 'package:flutter/material.dart';

import '../models/project_model.dart';
import '../models/episode_model.dart';

import '../clipsystem/clip_setup_screen.dart';


class EpisodeScreen extends StatefulWidget {

  final ProjectModel project;
  final int seasonIndex;


  const EpisodeScreen({
    super.key,
    required this.project,
    required this.seasonIndex,
  });


  @override
  State<EpisodeScreen> createState() =>
      _EpisodeScreenState();

}



class _EpisodeScreenState extends State<EpisodeScreen> {


  @override
  void initState() {

    super.initState();

    _createDefaultEpisode();

  }



  void _createDefaultEpisode(){

    final season =
        widget.project.seasons[widget.seasonIndex];


    if(season.episodes.isEmpty){

      season.episodes.add(

        EpisodeModel(
  id: "1",
  name: "Episode 1",
  clips: [],
),

      );

    }

  }




  void _addEpisode(){

    setState(() {


      final season =
          widget.project.seasons[widget.seasonIndex];



      season.episodes.add(

        EpisodeModel(

  id: (season.episodes.length + 1).toString(),

  name:
  "Episode ${season.episodes.length + 1}",

  clips: [],

),

      );


    });

  }





  @override
  Widget build(BuildContext context) {


    final season =
        widget.project.seasons[widget.seasonIndex];



    return Scaffold(


      appBar: AppBar(

        title: Text(season.name),

        centerTitle: true,

      ),



      body: ListView.builder(

        padding: const EdgeInsets.all(16),


        itemCount: season.episodes.length,


        itemBuilder: (context,index){


          final episode =
              season.episodes[index];



          return Card(


            child: ListTile(


              title: Text(episode.name),


              trailing:
              const Icon(Icons.arrow_forward),



              onTap: () async {


                await Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => ClipSetupScreen(

                      project: widget.project,

                    ),

                  ),

                );


              },


            ),


          );


        },


      ),



      floatingActionButton:

      FloatingActionButton(

        onPressed: _addEpisode,

        child: const Icon(Icons.add),

      ),


    );


  }


}