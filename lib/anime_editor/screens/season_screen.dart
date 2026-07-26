import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../models/season_model.dart';
import 'episode_screen.dart';


class SeasonScreen extends StatefulWidget {

  final ProjectModel project;


  const SeasonScreen({
    super.key,
    required this.project,
  });


  @override
  State<SeasonScreen> createState() => _SeasonScreenState();

}



class _SeasonScreenState extends State<SeasonScreen> {


  @override
  void initState() {
    super.initState();

    _createDefaultSeason();

  }



  void _createDefaultSeason(){

    if(widget.project.seasons.isEmpty){

      widget.project.seasons.add(

        SeasonModel(
          id: "1",
          name: "Season 1",
          episodes: [],
        ),

      );

    }

  }




  void _addSeason(){

    setState(() {

      widget.project.seasons.add(

        SeasonModel(
          id: (widget.project.seasons.length + 1).toString(),
          name:
          "Season ${widget.project.seasons.length + 1}",
          episodes: [],
        ),

      );

    });

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: Text(widget.project.name),
        centerTitle: true,
      ),



      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: widget.project.seasons.length,


        itemBuilder: (context,index){


          final season =
              widget.project.seasons[index];



          return Card(

            child: ListTile(

              title: Text(season.name),


              trailing:
              const Icon(Icons.arrow_forward),


              onTap: (){


                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                    EpisodeScreen(

                      project: widget.project,

                      seasonIndex: index,

                    ),

                  ),

                );


              },

            ),

          );


        },


      ),




      floatingActionButton: FloatingActionButton.extended(
  onPressed: _addSeason,
  icon: const Icon(Icons.add),
  label: const Text("Add Season"),
),


    );

  }

}