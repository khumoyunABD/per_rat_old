import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';
import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:http/http.dart' as http;
import 'package:per_rat/models/demographics.dart';
import 'package:per_rat/models/genres.dart';
import 'package:per_rat/models/statuses.dart';
import 'package:per_rat/models/studios.dart';

class NewAnime extends StatefulWidget {
  const NewAnime({
    super.key,
    required this.onAddAnime,
  });

  final void Function(Anime anime) onAddAnime;

  @override
  State<NewAnime> createState() => _NewAnimeState();
}

class _NewAnimeState extends State<NewAnime> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredImageUrl = '';
  var _enteredSynopsis = '';
  var _enteredTotalEpisodes = 12;
  var _enteredScore = 5.5;
  var _enteredRank = 1000;
  var _enteredPopularity = 700;
  var _enteredFavorites = 140;
  var _enteredTrailerUrl = '';
  var _selectedGenre = genres[Genres.action]!;
  var _selectedDemographic = demographics[Demographics.josei]!;
  var _selectedStudio = studios[Studios.a1Pictures]!;
  var _selectedStatus = statuses[Statuses.completed]!;
  // var _enteredStartDate = DateTime.now();
  // var _enteredEndDate = DateTime.now();

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'perratauth-default-rtdb.asia-southeast1.firebasedatabase.app',
          'anime-list.json');
      http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'title': _enteredTitle,
            'imageUrl': _enteredImageUrl,
            'synopsis': _enteredSynopsis,
            'totalEpisodes': _enteredTotalEpisodes,
            'score': _enteredScore,
            'rank': _enteredRank,
            'popularity': _enteredPopularity,
            'favorites': _enteredFavorites,
            'trailerUrl': _enteredTrailerUrl,
            'genre': _selectedGenre,
            'demographics': _selectedDemographic,
            'studio': _selectedStudio,
            'status': _selectedStatus,
            // 'startDate': _enteredStartDate,
            // 'endDate': _enteredEndDate,
          },
        ),
      );
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new show'),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        //itemExtent: 1000,
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.amber),
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // if (value == null) {
                    //   return;
                    // }
                    _enteredTitle = value!;
                  },
                ), // instead of TextField()
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Total Episodes'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredTotalEpisodes.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredTotalEpisodes = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLength: 80,
                  decoration: const InputDecoration(
                    label: Text('Image URL'),
                    labelStyle: TextStyle(color: Colors.amber),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 5 ||
                        value.trim().length > 80) {
                      return 'Must provide a valid URL';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // if (value == null) {
                    //   return;
                    // }
                    _enteredImageUrl = value!;
                  },
                ), // instead of TextField()
                const SizedBox(height: 12),
                TextFormField(
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.next,
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  //initialValue: 'Synopsis',
                  maxLength: 500,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    errorMaxLines: 6,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    helperMaxLines: 6,
                    hintText: 'Provide a description of the show...',
                    hintMaxLines: 6,
                    contentPadding: EdgeInsets.all(20),
                    border: OutlineInputBorder(),
                    label: Text(
                      'Description',
                    ),
                    labelStyle: TextStyle(color: Colors.amber),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 10 ||
                        value.trim().length > 500) {
                      return 'Must be between 10 and 500 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredSynopsis = value!;
                  },
                ), // instead of TextField()
                const SizedBox(height: 12),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Genre:',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 0,
                  child: DropdownButtonFormField(
                    menuMaxHeight: 250,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    //style: TextStyle(color: Colors.amber),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    value: _selectedGenre,
                    items: [
                      for (final genre in genres.entries)
                        DropdownMenuItem(
                          enabled: true,
                          value: genre.value,
                          child: Row(
                            children: [
                              const SizedBox(width: 6),
                              Text(genre.value.title),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGenre = value!;
                      });
                    },
                  ),
                ),

                //const SizedBox(height: 12),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Studio:',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 0,
                  child: DropdownButtonFormField(
                    menuMaxHeight: 250,
                    //style: TextStyle(color: Colors.amber),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    //style: TextStyle(color: Colors.amber),
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    value: _selectedStudio,
                    items: [
                      for (final studio in studios.entries)
                        DropdownMenuItem(
                          enabled: true,
                          value: studio.value,
                          child: Row(
                            children: [
                              const SizedBox(width: 6),
                              Text(studio.value.title),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStudio = value!;
                      });
                    },
                  ),
                ),
                //const SizedBox(height: 12),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Status:',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 0,
                  child: DropdownButtonFormField(
                    menuMaxHeight: 250,
                    //style: TextStyle(color: Colors.amber),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    //style: TextStyle(color: Colors.amber),
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    value: _selectedStatus,
                    items: [
                      for (final status in statuses.entries)
                        DropdownMenuItem(
                          enabled: true,
                          value: status.value,
                          child: Row(
                            children: [
                              const SizedBox(width: 6),
                              Text(status.value.title),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Demographics:',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 0,
                  child: DropdownButtonFormField(
                    menuMaxHeight: 250,
                    //style: TextStyle(color: Colors.amber),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    //style: TextStyle(color: Colors.amber),
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    value: _selectedDemographic,
                    items: [
                      for (final demographic in demographics.entries)
                        DropdownMenuItem(
                          enabled: true,
                          value: demographic.value,
                          child: Row(
                            children: [
                              const SizedBox(width: 6),
                              Text(demographic.value.title),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDemographic = value!;
                      });
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Score'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredScore.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              double.tryParse(value) == null ||
                              double.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredScore = double.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Rank'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredRank.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredRank = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Popularity'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredPopularity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPopularity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          label: Text('Favorites'),
                          labelStyle: TextStyle(color: Colors.amber),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredFavorites.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredFavorites = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLength: 80,
                  decoration: const InputDecoration(
                    label: Text('Trailer URL'),
                    labelStyle: TextStyle(color: Colors.amber),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 5 ||
                        value.trim().length > 80) {
                      return 'Must provide a valid URL';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // if (value == null) {
                    //   return;
                    // }
                    _enteredTrailerUrl = value!;
                  },
                ), // instead of TextField()
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: const Text('Add'),
                    )
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
