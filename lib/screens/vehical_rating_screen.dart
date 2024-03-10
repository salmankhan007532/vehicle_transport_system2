import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vehicle_transport_system2/models/rating.dart';
import '../models/vehical.dart';

class VehicalRatingScreen extends StatefulWidget {
  final Vehical vehical;

  const VehicalRatingScreen({Key? key, required this.vehical}) : super(key: key);

  @override
  State<VehicalRatingScreen> createState() => _VehicalRatingScreenState();
}

class _VehicalRatingScreenState extends State<VehicalRatingScreen> {

  double averageRating = 0.0;
  int totalRatings = 0;

  double yourRatings = 0.0;

  String? seekerId;
  DatabaseReference? ratingsRef;


  @override
  void initState() {
    super.initState();
    seekerId = FirebaseAuth.instance.currentUser!.uid;
    ratingsRef = FirebaseDatabase.instance.ref().child('ratings').child(widget.vehical.vehicalId);
    print('*********************************');
    print(widget.vehical.vehicalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehical Ratings'),
      ),
      body: Column(
        children: [
          Image.network(
            widget.vehical.photos[0] as String,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 5,),

          Expanded(
            child: StreamBuilder(
                stream: ratingsRef?.onValue,
                builder: (context, snapshot){

                  if( snapshot.hasData && !snapshot.hasError){

                    var event = snapshot.data as DatabaseEvent;

                    var snapshot2 = event.snapshot.value;
                    if (snapshot2 == null) {
                      // No ratings in RTDB
                      return TotalRatingWidget(averageRatings: averageRating, totalRatings: totalRatings);

                    }else{

                      // loop through ratings for current hostel

                      Map<String, dynamic> map =
                      Map<String, dynamic>.from(snapshot2 as Map);


                      List<Rating> ratingList = [];
                      for (var ratingMap in map.values) {
                        Rating rating =
                        Rating.fromMap(Map<String, dynamic>.from(ratingMap));

                        ratingList.add(rating);
                      }

                      averageRating = 0.0;

                      for( Rating rating in ratingList){
                        averageRating = averageRating + rating.value;
                      }

                      averageRating = averageRating / ratingList.length;
                      totalRatings = ratingList.length;


                      return TotalRatingWidget(averageRatings: averageRating, totalRatings: totalRatings);

                    }
                  }
                  else{
                    return const Center(child: CircularProgressIndicator(),);
                  }

            }),
          ),

          // Seeker Rating
          Expanded(child: StreamBuilder(

            stream: ratingsRef?.onValue,
            builder: (context, snapshot){
              if( snapshot.hasData && !snapshot.hasError){

                var event = snapshot.data as DatabaseEvent;

                var snapshot2 = event.snapshot.value;
                if (snapshot2 == null) {
                  // No ratings in RTDB

                  return Column(
                    children: [
                      const Text('Your Rating', style: TextStyle(fontSize: 20),),
                      RatingBar.builder(
                        initialRating: yourRatings,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double rating) async{
                          // add a new record in ratings

                          print(rating);

                          yourRatings = rating;
                          String? ratingId = ratingsRef!.push().key;
                          if( ratingId != null ){

                            await ratingsRef!.child(ratingId).set({
                              'ratingId': ratingId,
                              'seekerId': seekerId,
                              'value': rating,
                            });

                            Fluttertoast.showToast(msg: 'Thank you for rating vehical');
                          }else{
                            Fluttertoast.showToast(msg: 'Try Again Later');

                          }


                        },
                      ),
                    ],
                  );
                }else{

                  // loop through ratings for current user
                  Map<String, dynamic> map =
                  Map<String, dynamic>.from(snapshot2 as Map);


                  Rating? seekerRating;
                  for (var ratingMap in map.values) {
                    Rating rating =
                    Rating.fromMap(Map<String, dynamic>.from(ratingMap));

                    if (rating.seekerId == seekerId) {
                      seekerRating = rating;
                    }
                  }

                  if( seekerRating == null )
                  {
                    // current user has not rated yet
                    // add new rating
                    return Column(
                      children: [
                        const Text('Your Rating', style: TextStyle(fontSize: 20),),
                        RatingBar.builder(
                          initialRating: yourRatings,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double rating) async{
                            // add a new record in ratings

                            print(rating);
                            yourRatings = rating;
                            String? ratingId = ratingsRef!.push().key;
                            if( ratingId != null ){

                              await ratingsRef!.child(ratingId).set({
                            'ratingId': ratingId,
                            'seekerId': seekerId,
                            'value': rating,
                            });

                            Fluttertoast.showToast(msg: 'Thank you for rating vehical');
                            }else{
                            Fluttertoast.showToast(msg: 'Try Again Later');

                            }
                          },
                        ),
                      ],
                    );
                  }
                  else{

                    // user has already rated the hostel
                    // update is required
                    yourRatings = seekerRating.value.toDouble();
                    return Column(
                      children: [
                        const Text('Your Rating', style: TextStyle(fontSize: 20),),
                        RatingBar.builder(
                          initialRating: yourRatings,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double rating) {
                            // update record in ratings
                            print(rating);

                            ratingsRef!.child(seekerRating!.ratingId).update(
                                {
                                  'value': rating * 1.0
                                });
                          },
                        ),
                      ],
                    );
                  }

                }
              }
              else{
                return const Center(child: CircularProgressIndicator(),);
              }
            },
          ))

        ],
      ),
    );
  }
}

class TotalRatingWidget extends StatefulWidget {
  final double averageRatings;
  final int totalRatings;
  const TotalRatingWidget({Key? key, required this.averageRatings, required this.totalRatings}) : super(key: key);

  @override
  State<TotalRatingWidget> createState() => _TotalRatingWidgetState();
}

class _TotalRatingWidgetState extends State<TotalRatingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.averageRatings.toString(), style: const TextStyle(fontSize: 42),),
          RatingBar.builder(
            initialRating: widget.averageRatings,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person),
              Text('${widget.totalRatings} total')
            ],
          ),
          const Divider(color: Colors.blueGrey,),
        ],
      ),
    );
  }
}


/*class SeekerRatingWidget extends StatefulWidget {
  final double yourRatings;
  final String seekerId;
  DatabaseReference?  dbRef;
  const SeekerRatingWidget({Key? key, required this.yourRatings, required this.seekerId, DatabaseReference dbRef }) : super(key: key);

  @override
  State<SeekerRatingWidget> createState() => _SeekerRatingWidgetState();
}

class _SeekerRatingWidgetState extends State<SeekerRatingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Text('Your Rating', style: TextStyle(fontSize: 20),),
          RatingBar.builder(
            initialRating: widget.yourRatings,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ],
      ),
    );
  }
}


Text('4.3', style: TextStyle(fontSize: 42),),
          RatingBar.builder(
            initialRating: 4.3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person),
              Text('1077 total')
            ],
          ),
          const Divider(color: Colors.blueGrey,),

          const SizedBox(height: 10,),
          const Text('Your Rating', style: TextStyle(fontSize: 20),),
          RatingBar.builder(
            initialRating: 4.3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
 */